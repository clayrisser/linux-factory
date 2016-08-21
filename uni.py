import os
import sys

class uni:
    @staticmethod
    def read(message):
        if sys.version_info[0] < 3: # python 2
            return raw_input(message)
        else: # python 3
            return input(message)

    @staticmethod
    def question(message, defaultAnswer = 'y'):
        if defaultAnswer.lower() == 'y':
            response = True
            answer = uni.read(message + ' [Y|n]: ')
            if len(answer) > 0 and answer[0].lower() == 'n':
                response = False
        else:
            response = False
            answer = uni.read(message + ' [y|N]: ')
            if len(answer) > 0 and answer[0].lower() == 'y':
                response = True
        return response
