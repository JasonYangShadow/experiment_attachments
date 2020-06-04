#!/usr/bin/env python3
import ast
import os
import subprocess
import re
exp_url="https://github.com/JasonYangShadow/experiment_attachments.git"
match_file = "match.log"
non_match_file = "nomatch.log"
output_file = "report.log"
program = 'Linux-x86_64-lpmx'

def run_commands(command):
    print('running command: %s\n' % command)
    output = os.popen(command).read()
    return output

def shell_commands(command):
    print('running command: %s\n' % command)
    cp = subprocess.run([command], shell=True, stderr=subprocess.PIPE)
    return cp

def exist(name):
    path = run_commands("command -v %s" % name)
    if not path:
        raise Exception("%s does not exist" % name)

def test_match(dic):
    image_download = '%s docker download %s' %(program, dic['name'])
    image_delete = '%s docker delete -p %s' %(program, dic['name'])
    imports = ''
    commands = ''
    if 'imports' in dic:
        imports = 'import ' + ' '.join(dic['imports'])
        imports = "python -c '%s'"% imports
    if 'commands' in dic:
        commands = ' && '.join(dic['commands'])
    image_run = ''
    if not commands and imports:
        image_run = '%s docker fastrun %s "PATH=/opt/conda/bin:/home/biodocker/bin:$PATH PREFIX=/opt/conda %s"' %(program, dic['name'], imports)
    if commands:
        image_run = '%s docker fastrun %s "PATH=/opt/conda/bin:/home/biodocker/bin:$PATH PREFIX=/opt/conda %s && %s"' %(program, dic['name'], imports, commands)
    #start
    run_commands(image_download)

    #test and run
    cp = shell_commands(image_run)

    #cleanup
    run_commands(image_delete)

    return cp, image_run

def test_nonmatch(dic):
    image_download = '%s docker download %s' %(program, dic['name'])
    image_delete = '%s docker delete -p %s' %(program, dic['name'])
    commands = dic['commands']

    def apt(commands):
        for command in commands:
            matches = re.search(r"\(apt-get install -t buster-backports -y (\S+) \|\| apt-get install -y (\S+)\)", command)
            if matches:
                if matches.group(1) == matches.group(2):
                    return True, matches.group(1)
            matches = re.search(r"apt-get install -y (\S+)", command)
            if matches:
                return True, matches.group(1)
        return False, ''

    succ, app = apt(commands)
    image_run = '''%s docker fastrun %s "PATH=/opt/conda/bin:/home/biodocker/bin:$PATH PREFIX=/opt/conda a=whereis %s awk '{print $2}' && eval "$a --help""''' %(program, dic['name'], app)
    if not succ or not app:
        return None, image_run

    #start
    run_commands(image_download)

    #test and ru
    cp = shell_commands(image_run)

    #cleanup
    run_commands(image_delete)

    return cp, image_run

def main():
    exist('git')
    exist('Linux-x86_64-lpmx')
    cwd=run_commands("pwd").strip()
    expdir = cwd + "/experiment_attachments"
    if not os.path.exists(expdir):
        #git clone experiment_attachments
        run_commands("git clone %s" % exp_url)
    if not os.path.exists('%s/%s' %(expdir, match_file)) or not os.path.exists('%s/%s' %(expdir, non_match_file)):
        raise Exception('match.log or nomatch.log does not exist')

    processed = []
    if os.path.exists('%s' % output_file):
        with open('%s' % output_file) as o:
        #find processed info
            print('starts loading completed records...\n')
            for line in o.readlines():
                dic = ast.literal_eval(line.strip())
                processed.append(dic)
            print('finished loading records, the number is: %d\n' % len(processed))

    with open('%s/%s' %(expdir, match_file)) as m, open('%s/%s' %(expdir, non_match_file)) as n, open('%s' % output_file, 'w') as o:
        #here we opened match_file and non_match_file
        #process matched result firstly

        #here need to write previous successful records to file again, as we will overwrite or erase existing records
        processed_names = []
        for record in processed:
            if record['succ']:
                o.write('%s\n' % record)
                o.flush()
                processed_names.append(record['name'])

        for line in m.readlines():
            dic = ast.literal_eval(line.strip())
            if dic['name'] in processed_names:
                continue
            print('starts processing matched image %s\n' %dic['name'])
            ret, command = test_match(dic)
            data = {}
            data['name'] = dic['name']
            data['command'] = command
            if not ret.stderr:
                data['succ'] = True
                data['msg'] =''
            else:
                data['succ'] = False
                data['msg'] = str(ret.stderr)
            data['type'] = 'match'
            o.write('%s\n' % data)
            o.flush()

        #process nomatched result secondly
        for line in n.readlines():
            dic = ast.literal_eval(line.strip())
            if dic['name'] in processed_names:
                continue
            print('starts procesing non-matched image %s\n' %dic['name'])
            ret,command = test_nonmatch(dic)
            data = {}
            data['name'] = dic['name']
            data['command'] = command
            if ret and not ret.stderr:
                data['succ'] = True
                data['msg'] = ''
            else:
                data['succ'] = False
                if ret and ret.stderr:
                    data['msg'] = str(ret.stderr)
                else:
                    data['msg'] = ''
            data['type'] = 'nomatch'
            o.write('%s\n' %data)
            o.flush()

if __name__=="__main__":
    main()