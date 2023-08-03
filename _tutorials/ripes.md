---
layout: default
title: "Installing Ripes"
nav_order: 5
nav_exclude: false
search_exclude: false
has_children: false
has_toc: false
---


## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

# Installing and using Ripes
[Ripes](https://github.com/mortbopet/Ripes) is a visual computer architecture simulator and assembly code editor built for RISC-V. We are going to use Ripes to simulate different processors such as a single-cycle and different pipelined RISC-V cores.


## On Linux
Simply download the `.AppImage` file from the [Ripes github page](https://github.com/mortbopet/Ripes/releases). Once downloaded, navigate to the directory where the file is stored (Probably ~/Downloads) and make it executable by running `chmod +x <ripes-filename>`. Now you should be able to run the simulator by using `./<ripes-filename>`

> :pencil: .AppImage files are complete app executables so usually they do not need any 'installation'.

## On Mac
Download the release for Mac, unzip it and run it by clicking on the .app file.

## On Windows
First install [the latest Ripes version .zip file](https://github.com/mortbopet/Ripes/releases). Select the version for Windows:
![Windows_install](/tutorials/img/windows-rars-install.png "Installation of RARS on Windows")

Unzip the file, then run the ripes.exe program.

As stated on the Github page for Ripes, you wil need the C++ runtime library. By default you will probably have this installed, so just proceed with the installation of Ripes. If you get a *msvcp140.dll* error during the installation, please install the [C++ runtime library](https://www.microsoft.com/en-us/download/details.aspx?id=48145) and try again.
