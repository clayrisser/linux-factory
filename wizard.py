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
    chrome = question('Install Chrome?')
    virtualbox = question('Install VirtualBox?')
    vagrant = question('Install Vagrant?', 'n')
    lamp = question('Install LAMP Stack?')
    wordpress = None
    if lamp: wordpress = question('Install WordPress?')
    atom = question('Install Atom?')
    emacs = question('Install Emacs?')
    enpass = question('Install Enpass?')
    spotify = question('Install Spotify?')
    slack = question('Install Slack?')
    lmms = question('Install LMMS?')
    intellij = question('Install IntelliJ?', 'n')
    lightworks = question('Install LightWorks?')
    googleCloudSDK = question('Install Google Cloud SDK?')
    androidStudio = question('Install Android Studio?')
    audacity = question('Install Audacity?')
    blender = question('Install Blender?')
    rsaKey = question('Would you like an RSA key generated for you?')
    privateInternetAccess = question('Install Private Internet Access?')
    mongodb = question('Install MongoDB?')
    deluge = question('Install Deluge?')
    poedit = question('Install PoEdit?')
    synfig = question('Install Synfig?')
    inkscape = question('Install Inkscape?')
    robomongo = question('Install RoboMongo?')
    mysqlWorkbench = question('Install MySql Workbench?')
    aircrack = question('Install Aircrack?')
    johnTheRipper = question('Install John the Ripper?')
    ophcrack = question('Install Ophcrack?')
    angryIpScanner = question('Install Angry IP Scanner?')
    pycharm = question('Install PyCharm?', 'n')
    musescore = question('Install MuseScore?')
    googleWebDesigner = question('Install Google Web Designer?')
    kazam = question('Install Kazam?')
    freemat = question('Install FreeMat?')
    nodejs = question('Edit NodeJS Installation?', 'n')
    os.system('''
        cd /tmp
        apt-get -y update
        apt-get -y upgrade
        apt autoremove -y
        apt-get clean
        apt-get install ubuntu-restricted-extras
    ''')
    if chrome: os.system('bash installers/chrome.sh')
    if virtualbox: os.system('bash installers/virtualbox.sh')
    if vagrant: os.system('bash installers/vagrant.sh')
    if lamp: os.system('python installers/lamp.py')
    if wordpress: os.system('bash installers/wordpress.sh')
    if atom: os.system('python installers/atom.py')
    if emacs: os.system('python installers/emacs.py')
    if enpass: os.system('bash installers/enpass.sh')
    if spotify: os.system('bash installers/spotify.sh')
    if slack: os.system('bash installers/slack.sh')
    if lmms: os.system('bash installers/lmms.sh')
    if lightworks: os.system('bash installers/lightworks.sh')
    if googleCloudSDK: os.system('bash installers/google-cloud-sdk.sh')
    if androidStudio: os.system('bash installers/android-studio.sh')
    if audacity: os.system('bash installers/audacity.sh')
    if blender: os.system('bash installers/blender.sh')
    if rsaKey: os.system('bash installers/rsa-key.sh')
    if privateInternetAccess: os.system('bash installers/private-internet-access.sh')
    if mongodb: os.system('bash installers/mongodb.sh')
    if deluge: os.system('bash installers/deluge.sh')
    if poedit: os.system('bash installers/poedit.sh')
    if synfig: os.system('bash installers/synfig.sh')
    if inkscape: os.system('bash installers/inkscape.sh')
    if robomongo: os.system('bash installers/robomongo.sh')
    if mysqlWorkbench: os.system('bash installers/mysql-workbench.sh')
    if aircrack: os.system('bash installers/aircrack.sh')
    if johnTheRipper: os.system('bash installers/john-the-ripper.sh')
    if ophcrack: os.system('bash installers/ophcrack.sh')
    if angryIpScanner: os.system('bash installers/angry-ip-scanner.sh')
    if pycharm: os.system('bash installers/pycharm.sh')
    if musescore: os.system('bash installers/musescore.sh')
    if googleWebDesigner: os.system('bash installers/google-web-designer.sh')
    if kazam: os.system('bash installers/kazam.sh')
    if freemat: os.system('bash installers/freemat.sh')
    if nodejs: os.system('python installers/nodejs.py')
else:
    print 'This program must be run as root'
    exit()
