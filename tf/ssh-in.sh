#!/bin/bash
cat terraform.tfstate | jq '.modules[0].resources["aws_instance.stress-tester"].primary.attributes.public_ip' | xargs -I {} tmux new-window "ssh ubuntu@{} -i ~/dev/mobile-sandbox.pem -L 8089:localhost:8089"
cat terraform.tfstate | jq '.modules[0].resources["aws_instance.webserver"].primary.attributes.public_ip' | xargs -I {} tmux new-window "ssh ubuntu@{} -i ~/dev/mobile-sandbox.pem"
