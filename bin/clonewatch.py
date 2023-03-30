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

# TODO support bitbucket, sourcehut: need different base dirs
# TODO add ThreadPoolExecutor concurrency from concurrent.futures see: 
# https://docs.python.org/dev/library/concurrent.futures.html#threadpoolexecutor-example

INTERVAL=1.5

PARSE_REPO_URL= r'^(?:https://|git@)git(?:hu|la)b\.com:([^/]+)/(.*?)(\.git)?$'
PARSE_SOURCEHUT_REPO_URL = r'(?:https://git\.sr\.ht/|git@git\.sr\.ht:)~([^/]+)/([^/]+)'
PARSE_BITBUCKET_REPO_URL = r'^(?:git clone )?(?:git@bitbucket.org:)([^/]+)/([^/]+).git$'
PARSE_GITHUB_URL = r'^https://github\.com/([^/]+)/([^/?]+)'
CHECKOUT_BASEDIR=expanduser("~/src/other/")
LOG=os.path.join(CHECKOUT_BASEDIR, "clonewatch.log")

# parse URLs that are for browser visiting
# like: https://github.com/under4mhz/microbee
def parse_github_url(s):
    return re.search(PARSE_GITHUB_URL, s)

# parses repo urls for github, gitlab, sourcehut
def parse_github_repo(s):
    return re.search(PARSE_REPO_URL, s)

def parse_bb_repo(s):
    return re.search(PARSE_BITBUCKET_REPO_URL, s)

def parse_sh_repo(s):
    return re.search(PARSE_SOURCEHUT_REPO_URL, s)

# constructs a github git repo URL from user and reponame
def github_repo(user, reponame):
    return "git@github.com:{}/{}.git".format(user, reponame)

def update_console(num_running, latest_repo):
    print("\x1b[1F   latest: {}/{}             ".format(latest_repo[0], latest_repo[1]), end='\n')
    print("   downloads active: {}             ".format(num_running), end='\r')

def git_pull(repo_dir):
    return Popen(["git", "-C", repo_dir, "pull", "-q"], stdout=DEVNULL, stderr=DEVNULL)

def git_clone(url, repo_dir):
    return Popen(["git", "clone", "-q", url, repo_dir], stdout=DEVNULL, stderr=DEVNULL)

def main():
    print("check log file at {}\n".format(LOG))
    logging.basicConfig(filename=LOG, format='%(asctime)s %(levelname)s %(message)s', level=logging.DEBUG)
    logging.info("startup")
    previous_clipboard = ""
    gits=[]
    latest = ("?", "?")
    while True:
        url = pyperclip.paste().strip()
        if len(url) > 0 and url != previous_clipboard: 
            previous_clipboard = url
            subdir = "github.com"
            parsed = parse_github_repo(url)
            if not parsed:
                subdir = "git.sr.ht"
                parsed = parse_sh_repo(url)
            if not parsed:
                subdir = "bitbucket.org"
                parsed = parse_bb_repo(url)
            if not parsed:
                # try as github front-end url
                parsed = parse_github_url(url)
                if parsed:
                    subdir = "github.com"
                    # rewrite URL as git
                    user, repo = parsed.group(1, 2)
                    url = github_repo(user, repo)
                    logging.info("interpreting front-end URL as {}".format(url))
            if parsed:
                user, repo = parsed.group(1, 2)
                latest = (user, repo)
                # the following can fail, but we probably want to die in that case
                user_basedir = os.path.join(os.path.join(CHECKOUT_BASEDIR, subdir), user)
                os.makedirs(name=user_basedir, mode=0o755, exist_ok=True)
                repo_dir = os.path.join(user_basedir, repo)
                if os.path.exists(repo_dir):
                    logging.warning("pull existing {} assuming {}".format(repo_dir, url))
                    # maybe check this ^ with git remote -v
                    gits.append(git_pull(repo_dir))
                else:
                    gits.append(git_clone(url, repo_dir))
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
        update_console(len(gits), latest)



if __name__ == "__main__":
    main()
