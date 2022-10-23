#!/usr/bin/env zsh
# A is a plugin for zsh that provides a frontend to jump to directories.
# Copyright (c) 2022
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


export A_VERSION='1.0.0'

# List directories from z database, then from the filesystem, but echo
# directories directly when found (don't wait for the end of the search)
function a-list() {
    # Run z search
    z -l | cut -d ' ' -f 2-  | sed 's/^ *//' | tac
    # Run find search
    # find . -type d -not -path '*/\.*' -path '*/node_modules' 2>/dev/null
    find . -type d 2>/dev/null
}


# Use fzf to select a directory and cd into it (without ./ prefix)
# It uses z to find the most used directories
function a () {
    local dir
    # If arguments are given, rebind to z
    if [[ -n "$@" ]]
    then
        z "$@"
        return
    fi

    # We want to use z and find commands in parallel while fzf is waiting for
    # input
    # dir="$(a-list | fzf --prompt 'cd ' --exit-0)"
    dir="$(a-list | fzf --prompt 'cd ' --exit-0 --preview 'tree -C {} | head -200')"

    # dir="$(z -l | fzf --prompt 'cd ' --exit-0 --tac)"
    # Return if the directory doesn't exist (shouldn't happen)
    [[ -z "${dir}" ]] && return 1
    # Change directory
    builtin cd "${dir}"
}
