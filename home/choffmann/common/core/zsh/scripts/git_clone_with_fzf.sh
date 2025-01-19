#!/bin/env bash

_git_clone_with_fzf() {
    get_by_github_user() {
     curl -sL \
      -H "Accept: application/vnd.github+json" \
      "https://api.github.com/users/$1/repos" | yq '.[].ssh_url' > "/tmp/git_clone_cache/$1"
    }

    get_by_github_orga() {
     curl -sL \
      -H "Accept: application/vnd.github+json" \
      "https://api.github.com/orgs/$1/repos" | yq '.[].ssh_url' > "/tmp/git_clone_cache/$1"
    }

    local options selection
    mkdir -p /tmp/git_clone_cache

    if [ ! -f /tmp/git_clone_cache/choffmann ]; then
        get_by_github_user "choffmann"
    fi

    if [ ! -f /tmp/git_clone_cache/green-ecolution ]; then
        get_by_github_orga "green-ecolution"
    fi


    options=$(paste -d '\n' /tmp/git_clone_cache/choffmann /tmp/git_clone_cache/green-ecolution | rg -N .)

    # TODO: change to **
    if [[ $words[CURRENT] == "--" ]]; then
        selection=$(printf "%s\n" "${options[@]}" | fzf)
        if [[ -n $selection ]]; then
            compadd -U "$selection"
        fi
    fi
}

compdef _git_clone_with_fzf git
