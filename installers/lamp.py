# LAMP Stack Installer
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
    if False:
        os.system('cd /tmp')
        os.system(''' # apache
            apt-get install -y apache2
            adduser $SUDO_USER www-data
            sudo -u $SUDO_USER ln -s /var/www/html/ ~/Localhost
        ''')
        os.system(''' # mysql
            apt-get install -y mysql-server
            mysql_secure_installation
        ''')
        os.system(''' # php
            apt-get install -y php libapache2-mod-php php-mcrypt php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-xdebug
            sudo tee -a /etc/php/7.0/apache2/php.ini<<EOF
            [xdebug]
            xdebug.remote_enable=1
            xdebug.remote_host=127.0.0.1
            xdebug.remote_connect_back=1    # Not safe for production servers
            xdebug.remote_port=9000
            xdebug.remote_handler=dbgp
            xdebug.remote_mode=req
            xdebug.remote_autostart=true
            EOF
            service apache2 restart
        ''')

else:
    print 'This program must be run as root'
    exit()
