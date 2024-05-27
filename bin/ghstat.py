#!/usr/bin/env python3

import requests
import os
import sys

# invoke like this:
# GITHUB_TOKEN=$(gh auth token -u username) ghstat.py username

# TODO fetch user, token from `gh auth` using `--json` output format flag 
# TODO filter counted commits - only include commits by username 
# TODO limit counted commits to past timeperiod (e.g. year)
# TODO decide what branches to include

# Function to get all repositories for the user
def get_repositories(github_token, username):
    headers = {
        'Authorization': f'token {github_token}',
    }
    repos = []
    page = 1
    while True:
        url = f'https://api.github.com/users/{username}/repos?page={page}&per_page=100'
        response = requests.get(url, headers=headers)
        if response.status_code != 200:
            break
        repos.extend(response.json())
        if len(response.json()) < 100:
            break
        page += 1
    return repos

# Function to get the number of commits in a repository
def get_commit_count(github_token, owner, repo):
    url = f'https://api.github.com/repos/{owner}/{repo}/commits'
    headers = {
        'Authorization': f'token {github_token}',
    }
    response = requests.get(url, headers=headers)
    # TODO over past year
    if response.status_code == 200:
        return len(response.json())
    return 0


def main(args):

    GITHUB_TOKEN = os.getenv('GITHUB_TOKEN')
    if len(args) > 1:
        username = args[0]
    else: 
        username = os.getenv('USER')
    # Fetch all repositories for the user
    repositories = get_repositories(GITHUB_TOKEN, username)

    # Aggregate commit counts
    total_commits = 0
    for repo in repositories:
        commit_count = get_commit_count(GITHUB_TOKEN, username, repo['name'])
        total_commits += commit_count
        print(f"{repo['name']}: {commit_count} commits")

    print(f"Total commits across all repositories: {total_commits}")
    return 0


if __name__ == '__main__':
    if not os.getenv('GITHUB_TOKEN'):
        print("No GITHUB_TOKEN env var set")
        ret = 1
    else:
        ret = main(sys.argv[1:])
    sys.exit(ret)

