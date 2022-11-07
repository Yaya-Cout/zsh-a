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

# Wether to use fzf with arguments or not when arguments are given
export A_ARGS_TO_FZF=true

# Wether to use fzf if z fails to find a directory (if false, it will just
# return a failed exit code)
export A_FALLBACK_TO_FZF=true

# Wether to set the arguments as default search arguments to fzf when falling
# back to fzf (only if A_FALLBACK_TO_FZF is true)
export A_FALLBACK_TO_FZF_SET_DEFAULT_ARGS=true

# Wether to automatically select the first result if there is only one
export A_AUTO_SELECT=true

# Wether to preview the selected directory (using $A_PREVIEW_COMMAND)
export A_PREVIEW=true

# Command to use for previewing the selected directory
export A_PREVIEW_COMMAND=("tree" "-C" "{}")

# List directories from z database, then from the filesystem, but echo
# directories directly when found (don't wait for the end of the search)
function a-list() {
    # Run z search
    z -l | cut -d ' ' -f 2-  | sed 's/^ *//' | tac
    # Run find search
    find . -type d 2>/dev/null
    # Find from root, but exclude already found directories (using -n)
}

# Use fzf to select a directory
# Arguments:
#   $1 (optional): the default query
function a-select() {
    local query=$@
    local args=()

    # Handle settings
    # Default query ($A_ARGS_TO_FZF and $query)
    if [[ $A_ARGS_TO_FZF == true ]] && [[ -n $query ]]; then
        args+=("--query" "$query")
    fi

    # Auto select ($A_AUTO_SELECT)
    if [[ $A_AUTO_SELECT == true ]]; then
        args+=("--select-1")
    fi

    # Preview ($A_PREVIEW)
    if [[ $A_PREVIEW == true ]]; then
        args+=("--preview" "$A_PREVIEW_COMMAND")
    fi


    # Run fzf with arguments specified in $args (splitting them)
    a-list | fzf --prompt 'cd ' --exit-0 $args
    # a-list | fzf --prompt 'cd ' --exit-0 --preview 'tree -C {} | head -200' $args
}


# Use fzf to select a directory and cd into it (without ./ prefix)
# It uses z to find the most used directories
function a () {
    local dir
    # If arguments are given and A_ARGS_TO_FZF is true, set them as the
    # default search
    if [[ $# -gt 0 ]]; then
        default_query="$@"
    else
        default_query=""
    fi

    # If A_ARGS_TO_FZF is false and there are arguments, use directly z and fallback to fzf if z fails
    if [[ $A_ARGS_TO_FZF == false && $# -gt 0 ]]; then
        # Call z with the arguments
        z "$@"
        local z_exit_code=$?
        # If z is successful, return
        if [[ $z_exit_code == 0 ]]; then
            return
        fi
        # If z failed, fallback to fzf if A_FALLBACK_TO_FZF is true
        if [[ $A_FALLBACK_TO_FZF == true ]]; then
            # If A_FALLBACK_TO_FZF_SET_DEFAULT_ARGS is false, set the default query to empty
            if [[ $A_FALLBACK_TO_FZF_SET_DEFAULT_ARGS == false ]]; then
                default_query=""
            fi
        else
            echo "Error: z failed to find a directory"
            # If A_FALLBACK_TO_FZF is false, return
            return $z_exit_code
        fi
    fi

    # We want to use z and find commands in parallel while fzf is waiting for
    # input
    # dir="$(a-list | fzf --prompt 'cd ' --exit-0)"
    dir="$(a-select "$default_query")"

    # Echo the directory and cd into it
    if [[ -n $dir ]]; then
        echo "Selected directory: $dir"
        cd "$dir"
    # If the directory is empty, return a failed exit code (happen when fzf is
    # interrupted)
    else
        echo "Error: no directory selected"
        return 1
    fi
}
