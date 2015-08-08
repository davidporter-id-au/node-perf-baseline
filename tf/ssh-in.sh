#!/bin/bash
terraform show | grep public_ip | awk '{print $3}' | xargs -I {} tmux new-window "ssh ubuntu@{} -i ~/dev/mobile-sandbox.pem -L 8089:localhost:8089"
