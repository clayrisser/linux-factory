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
        add-apt-repository ppa:webupd8team/atom
        apt-get update
        apt-get install -y atom
        sudo -u $SUDO_USER apm install color-picker linter-eslint linter-markdown linter-less floobits emmet atom-material-ui bracket-matcher docblockr aligner polymer-snippets linter-polymer atom-beautify php-debug linter-php minimap wordpress-api
    ''')

else:
    print 'This program must be run as root'
    exit()
