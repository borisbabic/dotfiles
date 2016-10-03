#!/usr/bin/env python2

import fileinput
import re

TAB_LENGTH = 4

def prependTabs(string, numTabs=1):
    return numTabs * TAB_LENGTH * ' ' + string 

def getVariables(string):
    regex = r'\$[a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*'
    return re.findall(regex, string)

def createVariableDeclaration(variable):
    return prependTabs("private {};").format(variable)

def getVariableDeclarations(variables):
    declarations = []
    for variable in variables:
        declarations.append(createVariableDeclaration(variable))
        declarations.append('')
    return declarations

def createPropertyInit(variable):
    dollarLessVariable = variable.replace('$', '')
    return prependTabs("$this->{0} = {1};",2).format(dollarLessVariable, variable)


def getConstructVariables(variables):
    constructLines = [prependTabs('{')]
    for variable in variables:
        constructLines.append(createPropertyInit(variable))
    constructLines.append(prependTabs('}'))
    return constructLines

def finishConstruct(construct):
    variables = getVariables(construct)
    newLines = getVariableDeclarations(variables)
    newLines.append(prependTabs(construct.strip()))
    newLines.extend(getConstructVariables(variables))
    return newLines

def main():
    construct = fileinput.input()[0];
    finished = finishConstruct(construct)
    for line in finished:
        print line

if __name__ == "__main__":
    main()

