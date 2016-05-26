#!/bin/bash
KEYGEN_OUT=`ssh-keygen -F $1`
if [ -z "$KEYGEN_OUT" ] ; then
  ssh-keyscan -H $1 >> ~/.ssh/known_hosts
  ssh-copy-id -i ~/.ssh/id_rsa.pub $1
fi
\ssh $@
