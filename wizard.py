import os
import sys
from uni import Uni
from profile import Profile

class Wizard:
    
    def __init__(self):
        global uni
        uni = Uni()
        self.profile = Profile()

    def chooseDeveloperType(self):
        print '[0] Backend'
        print '[1] Front-end'
        print '[2] Full-stack'
        print '[3] Hacker'
        self.profile.developerType = uni.read('Select what kind of developer you are: ')

    def chooseProgrammingTechnologies(self):
        if self.profile.developerType == 'Backend':
            print '[0] Java'
            print '[1] Python'
            print '[2] Go'
            print '[3] JavaScript'
            print '[4] PHP'
        else if self.profile.developerType == 'Front-end':
            print '[0] JavaScript'
            print '[1] ReactJS'
            print '[2] AngularJS'
            print '[3] Polymer'
        else:
        
        self.profile.technologies = uni.read('Select the technologies you use:')
        
    def install(self):
        print self.profile.developerType
        
wizard = Wizard()
wizard.chooseDeveloperType()
wizard.install()
