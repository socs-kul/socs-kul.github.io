---
layout: default
title: Terminal Basics
nav_order: 3
nav_exclude: false
has_children: false
---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}



# Getting used to the CLI
You are probably used a graphical user interface (GUI) to interact with your system. However, using the command line interface (CLI) can save you much time and will sometimes even be necessary in some cases such as with WSL. Here we will put a small tutorial to get to know the basics of getting around the file system.

## Directories and files
### Moving around Directories and finding files
To view your current location in the directory, you can use the `pwd` command. This stands for 'print working directory'.

To list all files and folders in your current directory, use the `ls` command. There are some helpful options you could give the `ls` command so it provides more information, such as -la. To find out what options there are and how to use them, use `man ls`. man stands for manual. Usually you can also give `--help` as an argument to get a shorter description. Another great command to get a short recap of how to use a tool is to use `tldr`, you will probably have to install it seperately.

You can use the `cd` command to **c**hange your **d**irectory, for example
```bash
$ cd .. # .. refers to the parent directory, so it takes you back a level
$ cd .  # .  refers to the current directory, so it doesn't do anything
$ cd ~  # ~  refers to your users home directory
$ cd -  # -  also refers to your users home directory
$ cd /  # /  refers to the root directory
```
Another thing to note is that you can denote a full path or a relative path.

Another useful command to get a quick overview of where you are in the directory is the `tree` command.\

### Interacting with Files and Directories
Now that you know how to get around directories, it is probably important to know how to interact with files and directories.

```bash
cp <file_to_copy> <destination> # Copy a file
mv <file_to_move> <destination> # Move a file
rm <filepath> # Remove a file
touch <filepath> # Create a file
mkdir <directory> # Create a directory
rmdir <directory> # Remove a directory
rm -rf <directory> # Remove a directory and its contents recursively
apropos <command> # If you don't know the exact spelling of a command
clear # Clear your terminal, you can also press ctrl+L for a similar effect usually
```
**Please never do `rm -rf /`** since this will remove everything recursively starting from root. Since in Linux everything is a file so you'll just end up bricking your entire system.

### Terminology
The terminal is the surrounding program you use to interact with the shell. Examples include the Gnome Terminal, Alacritty, Foot...\
The shell runs inside the terminal and is the way you interact with your system. Examples include bash, zsh, sh, fish...
\

## Extra resources
### Custom Prompts
It is possible to customize your prompt to display more useful information, an example can be found below.
This prompt gives the user information about the current directory they're in and also on the git status:\
\
![Custom prompt](/tutorials/img/custom-prompt.png)

Some links:
[ohmyzsh](https://ohmyz.sh/)
[zapzsh](https://www.zapzsh.org/)
[powerlvl10k](https://github.com/romkatv/powerlevel10k)
### Meaning of directories
If you want to know the meanings of all the different Linux directories:
[ Linux Directories Explained in 100 Seconds ](https://youtu.be/42iQKuQodW4)
### Gamification of cd/ls/pwd
[Learn pwd/cd/ls](http://web.mit.edu/mprat/Public/web/Terminus/Web/main.html)
