#!/usr/bin/env python

import argparse
import os
import shutil
import subprocess
import sys

def download(args):
    shutil.rmtree('launcher', ignore_errors=True)
    subprocess.check_call(['git', 'clone', '--recurse-submodules', 'https://github.com/runelite/launcher.git'])
    os.chdir('launcher')
    subprocess.check_call(['git', 'checkout', '928b05d3e21eb94b2145bfa5db89d420cf2c274c'])
    subprocess.check_call(['git', 'submodule', 'update', '--recursive'])

    subprocess.check_call(['sed', '-i', 's@#!/bin/bash@#!/usr/bin/env bash@', 'build-linux-x86_64.sh'])
    subprocess.check_call(['sed', '-i', '/#include <stdlib.h>/a#include <cstdint>', 'native/src/linux/packr_linux.cpp'])

    print('ok')


def build(args):
    os.chdir('launcher')
    subprocess.check_call(['git', 'clean', '-fxd'])
    subprocess.check_call(['nix-shell', '-p', 'clang', 'cmake', 'curl', 'jdk17', 'maven', '--run', 'unset SOURCE_DATE_EPOCH; mvn install && ./build-linux-x86_64.sh'])


def main():
    os.chdir('/home/myuser/Desktop')
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(required=True)
    download_command = subparsers.add_parser('download', help='download runelite source and patch for easy nixos builds')
    download_command.set_defaults(func=download)

    build_command = subparsers.add_parser('build', help='builds runelite source code. Just runs mvn install && ./build-linux-x86_64.sh')
    build_command.set_defaults(func=build)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()

