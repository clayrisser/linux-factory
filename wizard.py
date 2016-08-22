import os
import sys
import yaml

class Wizard:
    
    def __init__(self, wizard):    
        self.profile = {}
        with open(wizard) as stream:
            try:
                self.wizard = yaml.load(stream)
            except yaml.YAMLError as exc:
                print(exc)

    def start(self):
        for i in range(len(self.wizard)):
            self.goToPanel(i)
                
    def goToPanel(self, id):
        panel = self.wizard[id]
        answers = []
        for answer in panel['answers']:
            if 'if' in answer:
                for requiredItem in answer['if']['required']:
                    parent = self.profile[answer['if']['parent']]
                    if not isinstance(parent, basestring) and len(parent) > 0:
                        for profileItem in parent:
                           if requiredItem == profileItem:
                               answers.append(answer)
                               break
                    elif requiredItem == parent:
                        answers.append(answer)
            else:
                answers.append(answer)
        for i in range(len(answers)):
            answer = answers[i]
            print('[' + str(i) + ']' + ' ' + answer['name'])
        response = raw_input(panel['question'] + ': ')
        if 'multiple' in panel and panel['multiple']:
            self.profile[panel['id']] = []
            for char in response:
                self.profile[panel['id']].append(panel['answers'][int(char)]['id'])
        else:
            self.profile[panel['id']] = panel['answers'][int(response)]['id']

wizard = Wizard('wizard.yml')
wizard.start()
print(wizard.profile)
