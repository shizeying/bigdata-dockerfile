#!/bin/bash
ssh -p ${sshPort} ${sshUser}@${remoteHost}  "java -jar ${remotePath}/license.jar --allow=${NetDevice} $1 $2 $3 $4 $5"
