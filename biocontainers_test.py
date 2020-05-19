#!/usr/bin/env python3
import ast
import os
import subprocess
exp_url="https://github.com/JasonYangShadow/experiment_attachments.git"
match_file = "match.log"
non_match_file = "nomatch.log"
output_file = "report.log"
program = 'Linux-x86_64-lpmx'

def run_commands(command):
    output = os.popen(command).read()
    return output

def shell_commands(command):
    cp = subprocess.run([command], shell=True)
    return cp['returncode']

def exist(name):
    path = run_commands("command -v %s" % name)
    if not path:
        raise Exception("%s does not exist" % name)

def test_match(dic):
    if not isinstance(dict, dic):
        raise Exception('%s should be the type of dict' % dic)
    image_download = '%s docker download %s' %(program, dic['name'])
    image_delete = '%s docker delete -p %s' %(program, dic['name'])
    imports = ''
    commands = ''
    if 'imports' in dic:
        imports = 'import ' + ' '.join(dic['imports'])
    if 'commands' in dic:
        commands = ' && '.join(dic['commands'])
    image_run = '%s docker fastrun %s "PATH=/opt/conda/bin:$PATH %s %s"' %(program, dic['name'], imports, commands)
    #start
    print(run_commands(image_download))

    #test and run
    ret = shell_commands(image_run)

    #cleanup
    print(run_commands(image_delete))

    if ret == 0:
        return True, ''
    else:
        reason = input('reason? \n')
        return False, reason
    

def main():
    exist('git')
    #exist('Linux-x86_64-lpmx')
    cwd=run_commands("pwd").strip()
    expdir = cwd + "/experiment_attachments"
    if not os.path.exists(expdir):
        #git clone experiment_attachments
        run_commands("git clone %s" % exp_url)
    if not os.path.exists('%s/%s' %(expdir, match_file)) or not os.path.exists('%s/%s' %(expdir, non_match_file)):
        raise Exception('match.log or nomatch.log does not exist')

    with open('%s/%s' %(expdir, match_file)) as m, open('%s/%s' %(expdir, non_match_file)) as n, open('%s' % output_file,'a') as o:
        #here we opened match_file and non_match_file
        
        #process matched result firstly
        for line in m.readlines():
            dic = ast.literal_eval(line)
            #download image

if __name__=="__main__":
    main()