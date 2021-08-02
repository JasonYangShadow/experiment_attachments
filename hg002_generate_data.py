#!/usr/bin/env python3

import random
import os

def md5_hash(filename):
    import hashlib
    from functools import partial

    with open(filename, mode='rb') as f:
        d = hashlib.md5()
        for buf in iter(partial(f.read, 128), b''):
            d.update(buf)
    return d.hexdigest()

if not os.path.exists('download') and not os.path.isdir('download'):
    os.makedirs('download')

if os.path.exists('HG002_download') and os.path.isfile('HG002_download'):
    with open('HG002_download') as f:
        arrs = f.readlines()
        for arr in arrs:
            strs = arr.split(' ')
            if len(strs) != 4:
                raise Exception('%s length is not 4'%arr)
            fq1, h1, fq2, h2 = strs[0].strip(),strs[1].strip(),strs[2].strip(),strs[3].strip()
            if len(h1.strip()) == 0 or len(h2.strip()) == 0:
                raise Exception('%s or %s is empty'%(h1, h2))
            if not os.path.exists('download/%s.fastq.gz'%h1):
                os.system("curl %s -o download/%s.fastq.gz"%(fq1, h1))
            if not os.path.exists('download/%s.fastq.gz'%h2):
                os.system("curl %s -o download/%s.fastq.gz"%(fq2, h2))

            m1 = md5_hash('download/%s.fastq.gz'%h1)
            if not os.path.exists('download/%s.fastq.gz'%h1) or (os.path.exists('download/%s.fastq.gz'%h1) and  m1 != h1):
                os.system("curl %s -o download/%s.fastq.gz"%(fq1, h1))

            m2 = md5_hash('download/%s.fastq.gz'%h2)
            if not os.path.exists('download/%s.fastq.gz'%h2) or (os.path.exists('download/%s.fastq.gz'%h2) and  m2 != h2):
                os.system("curl %s -o download/%s.fastq.gz"%(fq2, h2))
            
            print('%s and %s are checked'%(m1, m2))
else:
    with open('HG002_data_list') as f, open('HG002_download', 'w') as w:
        arrs = f.readlines()
        loopcount = int(len(arrs) * 0.1) + 1
        i = 0
        exists = set()
        while i < loopcount:
            rand = random.randrange(1, len(arrs))
            if rand not in exists:
                exists.add(rand)
                i = i + 1
                curr = arrs[rand].strip()
                strs = curr.split('\t')
                if len(strs) != 5:
                    raise Exception('%s length is not 5'%strs)
                fq1, h1, fq2, h2 = strs[0], strs[1], strs[2], strs[3]
                print('current line: %s %s <-> %s %s'%(fq1, h1, fq2, h2))
                w.write('%s %s %s %s\n' %(fq1, h1, fq2, h2))