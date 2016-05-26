#!/bin/bash
ssh-keyscan -H $1 >> ~/.ssh/known_hosts
ssh-copy-id -i ~/.ssh/id_rsa.pub $1
\ssh $@
