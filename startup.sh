#!/bin/bash

nginx
su -c "/opt/anaconda/bin/conda init" vnc
su -c /start_vnc.sh vnc
