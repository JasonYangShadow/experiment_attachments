#!/usr/bin/env python3
import os
import re

exp_url="https://github.com/JasonYangShadow/experiment_attachments.git"
bio_url="https://github.com/bioconda/bioconda-recipes.git"

def run_commands(command):
    output = os.popen(command).read()
    return output

def exist(name):
    path = run_commands("command -v %s" % name)
    if not path:
        raise Exception("%s does not exist" % name)

def parse_yaml(yamlpath):
    with open(yamlpath) as f:
        testfound = False
        importfound = False
        commandsfound = False
        ret = {}
        #pattern for {% set key = "val" %}
        env_p = re.compile(r"{%\s+set\s+(\w+)\s+=\s+\"([\w.]*)\"\s+%}")
        #pattern for xxxxx {{ key }}
        lin_p = re.compile(r"\w*{{\s+(\w+)\s+}}\w*")
        env_dict = {}
        for line in f.readlines():
            #retrieve environment variable info
            m = env_p.match(line)
            if m is not None:
                env_dict[m.group(1)] = m.group(2)
            if line.strip().startswith("test:"):
                testfound = True
            if line.strip().startswith("imports:") and testfound:
                importfound = True
                commandsfound = False
                ret['imports'] = []
                continue
            if line.strip().startswith("commands:") and testfound:
                commandsfound = True
                importfound = False
                ret['commands'] = []
                continue
            
            line = line.strip()
            if line.startswith('#'):
                continue
            #array marker
            if line.startswith('-'):
                line = line[1:]
            #remove inline comment
            if line.find('#') != -1:
                line = line[:line.find('# ')]
            line = line.strip()
            #encounters ending directly return
            if ((importfound and not commandsfound)  or (not importfound and commandsfound))and (line.strip() == "" or re.match('\w+:', line)):
                break
            if importfound or commandsfound:
                #replace all {{ key }} to its real value
                for r in re.findall(lin_p, line):
                    r = r.strip()
                    line = re.sub(r"{{\s+%s\s+}}" % r, env_dict[r], line)
            if line and importfound:
                ret['imports'].append(line)
            if line and commandsfound:
                ret['commands'].append(line)
        return ret

def main():
    exist("git")
    #exist("Linux-x86_64-lpmx")
    cwd=run_commands("pwd").strip()
    expdir = cwd + "/experiment_attachments"
    biodir = cwd + "/bioconda-recipes"
    if not os.path.exists(expdir):
        #git clone experiment_attachments
        run_commands("git clone %s" % exp_url)
    if not os.path.exists(biodir):
        run_commands("git clone %s" % bio_url)
    recipedir = "%s/recipes" % biodir
    if os.path.exists("%s/biocontainers" % expdir):
        with open("%s/biocontainers" % expdir, "r") as f, open("%s/match.log" % cwd, "a") as m, open("%s/nomatch.log" % cwd, "a") as n:
            for line in f.readlines():
                name = line.split(':')[0][14:]
                tag = line.split(':')[1]
                if os.path.exists("%s/%s" %(recipedir, name)) and os.path.exists("%s/%s/meta.yaml" %(recipedir, name)):
                    tests = parse_yaml("%s/%s/meta.yaml" % (recipedir, name))
                    tests['name'] = line
                    tests['recipe'] = "%s/%s" %(recipedir, name)
                    m.write("%s\n" % tests)
                else:
                    n.write("%s" % line)

if __name__=="__main__":
    main()