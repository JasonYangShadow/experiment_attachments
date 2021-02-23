#!/usr/bin/env python3
import random
import os

loopcount = 5

with open('biocontainers') as f:
    arrs = f.readlines()
    i = 0
    while i < loopcount:
        rand = random.randrange(0, len(arrs))
        i = i + 1
        curr = arrs[rand].strip()
        print("currently testing the docker image: %s" %(curr))
        os.system("sudo docker pull %s" %(curr))
        
        names = curr.split(":")[0].split("/")
        exportfile = "%s_%s.tar" % (names[0], names[1])
    
        os.system("sudo docker tag %s %s" %(curr, "%s:%s" % (names[0], names[1])))
        os.system("sudo docker save %s:%s -o %s" %(names[0], names[1], exportfile))
        os.system("sudo chown vagrant:vagrant %s" % exportfile)
        os.system("chmod 644 %s" % exportfile)
        os.system("time singularity build %s.sif docker-archive://%s" %(exportfile, exportfile))
        os.system("time Linux-x86_64-lpmx docker load %s" % exportfile)
    
