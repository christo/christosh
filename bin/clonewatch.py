#!/usr/bin/env python3

# requires pyperclip: pip install pyperclip

# continuously watches the system clipboard, aka pastebuffer for git repos
# and automatically clones them into a specific location
# if the repo already exists, does nothing

from os.path import expanduser
from subprocess import Popen, PIPE, DEVNULL
import logging
import os
import pyperclip
import re
import sys
import time

# TODO support https urls, gitlab, bitbucket
# TODO if the repo is already on disk, pull from remote instead of clone
# TODO add ThreadPoolExecutor concurrency from concurrent.futures see: 
# https://docs.python.org/dev/library/concurrent.futures.html#threadpoolexecutor-example

INTERVAL=1.5
PARSE_REPO_URL= r'^(?:https://|git@)git(?:hu|la)b\.com:([^/]+)/(.*?)(\.git)?$'
CHECKOUT_BASEDIR=expanduser("~/src/other/")
LOG=os.path.join(CHECKOUT_BASEDIR, "clonewatch.log")

def parse_repo(s):
    return re.search(PARSE_REPO_URL, s)

def update_console(num_running):
    print("   \x1b[2Kdownloads active: {}".format(num_running), end='\r')

def main():
    print("check log file at {}".format(LOG))
    logging.basicConfig(filename=LOG, format='%(asctime)s %(levelname)s %(message)s', level=logging.DEBUG)
    logging.info("startup")
    previous_clipboard = ""
    gits=[]
    while True:
        url = pyperclip.paste().strip()
        if len(url) > 0 and url != previous_clipboard: 
            previous_clipboard = url
            parsed = parse_repo(url)
            if parsed:
                user, repo = parsed.group(1, 2)
                # the following can fail, but we probably want to die in that case
                user_basedir = os.path.join(CHECKOUT_BASEDIR, user)
                os.makedirs(name=user_basedir, mode=0o755, exist_ok=True)
                repo_dir = os.path.join(user_basedir, repo)
                if os.path.exists(repo_dir):
                    logging.warning("repo dir {} exists, not cloning {}".format(repo_dir, url))
                else:
                    gits.append(Popen(["git", "clone", "-q", url, repo_dir], stdout=DEVNULL, stderr=DEVNULL))
                    logging.info("cloning {} by {}: {}".format(repo, user, url))
            else:
                logging.warning("not parse {}".format(url))

        time.sleep(INTERVAL)
        # TODO fix race condition
        finished = (x for x in gits if not x.poll() is None)
        for x in finished:
            if x.poll() == 0:
                logging.info("completed {}".format(x.args))
            else:
                logging.info("fail code {} for {}".format(x.poll(), x.args))
        # remove completed processes
        gits = [x for x in gits if x.poll() == None]
        update_console(len(gits))



if __name__ == "__main__":
    main()
