import os
import sys

def read(message):
    if sys.version_info[0] < 3: # python 2
        return raw_input(message)
    else: # python 3
        return input(message)

def question(message, defaultAnswer = 'y'):
    if defaultAnswer.lower() == 'y':
        response = True
        answer = read(message + ' [Y|n]: ')
        if len(answer) > 0 and answer[0].lower() == 'n':
            response = False
    else:
        response = False
        answer = read(message + ' [y|N]: ')
        if len(answer) > 0 and answer[0].lower() == 'y':
            response = True
    return response

if os.getuid() == 0:
    os.system('''
        cd /tmp
        apt-get remove -y --purge nodejs-legacy
        wget https://nodejs.org/dist/v0.12.7/node-v0.12.7.tar.gz
        tar -vxzf node-*.tar.gz
        rm -rf node-*.tar.gz
        mv node-* nodejs
        cd nodejs
        ./configure
        make
        make install
        rm -rf nodejs
        cd /tmp
        sudo -u $SUDO_USER curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash
    ''')

else:
    print 'This program must be run as root'
    exit()
