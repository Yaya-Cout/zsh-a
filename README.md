# Zsh-A

## Usage

Just type `a` in your terminal and you will be prompted with a list of all the
available directories in `z` database and subdirectories. Select the one you
want and you will be taken there. You can also give an argument to `a` and it will
rebind this argument to the `z`.

## Installation

A depends on z and fzf. You can install them z with your plugin manager of
choice or manually. You can install fzf with your package manager or manually.
You should install tree if you want to have the preview of the directories.

Add one of the following to your .zshrc file depending on your package manager:

### ZPlug

```zsh
zplug "Yaya-Cout/a"
```

### Antigen

```zsh
antigen bundle "Yaya-Cout/a"
```

### Zgen

```zsh
zgen load "Yaya-Cout/a"
```

### Oh-my-zsh

Copy this repository to $ZSH_CUSTOM/custom/plugins, where $ZSH_CUSTOM is the directory with custom plugins of oh-my-zsh (read more):

```zsh
git clone https://github.com/Yaya-Cout/a.git $ZSH_CUSTOM/plugins/a
```

Then add this line to your .zshrc. Make sure it is before the line source $ZSH/oh-my-zsh.sh.

```zsh
plugins=(a $plugins)
```

### Custom

If you don't use any package manager, you can just clone this repository using
git.

```zsh
git clone https//github.com/Yaya-Cout/a.git
```

Then source the `a.plugin.zsh` file in your `.zshrc` file.

```zsh
source /path/to/a/a.plugin.zsh
```
