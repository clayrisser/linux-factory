import os
import sys
import yaml
from profile import Profile

class Wizard:
    
    def __init__(self, wizard):
        self.profile = Profile()
        with open(wizard) as stream:
            try:
                self.wizard = yaml.load(stream)
            except yaml.YAMLError as exc:
                print(exc)
        
    def run(self):
        print('im running')
        print(self.wizard)
    
wizard = Wizard('wizard.yml')
wizard.run()
