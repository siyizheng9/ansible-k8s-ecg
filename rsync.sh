#!/bin/bash

SRC='roles ansible.cfg hosts main.yml'
DST='~/Development/Ansible/'
HOST='r-debian-1'

rsync -ruv $SRC $HOST:$DST