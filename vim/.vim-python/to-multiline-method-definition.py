#!/usr/bin/env python2

import fileinput

def prependTabs(string, numTabs=1, tabLength=4):
    return numTabs * tabLength * ' ' + string 

def handleMethodCallLine(methodCallLine):
    tempLines = methodCallLine.split('(');

    # adds method call line
    newLines = [tempLines[0] + '('] 

    # removes the trailing )
    argumentsString = tempLines[1].replace(')', '') 

    #turns them into a list
    argumentsList = argumentsString.split(', ')

    #strips whitespace
    strippedArguments = map(str.strip, argumentsList)

    #prepends two tabs as spaces
    tabbedArguments = map(lambda a: prependTabs(a, 2), strippedArguments)

    #adds a comma to the arguments that need them, and adds those to the newLine
    newLines.extend(map(lambda a: a + ',', tabbedArguments[:-1]))

    #adds the last argument to the newLines
    newLines.append(tabbedArguments[-1])

    return newLines

def main():
    lines = fileinput.input();
    newLines = handleMethodCallLine(lines[0])
    newLines.append(prependTabs(') {'))
    #print newLines
    for line in newLines:
        print line

if __name__ == "__main__":
    main()
