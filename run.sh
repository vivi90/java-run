#!/bin/bash

########################################################
#                                                      #
#             Java compile and run script              #
#                                                      #
#  2019 by Vivien Richter <vivien-richter@outlook.de>  #
#  License: GPL                                        #
#                                                      #
########################################################

# Configuration
projectName=$(basename `pwd`)
mainPackageName=${projectName}
compileArgumentsFile=".javac-args"
sourcepathFile=".javac-sourcepath"
classpathFile=".javac-classpath"

# Enable shell option 'extglob'
shopt -s extglob

# Cleaning.
rm -r -f ./bin/!(.gitkeep|.|..)
rm -f ./$projectName.jar

# Compiling.
mkdir -p ./bin
javac @$compileArgumentsFile -sourcepath @$sourcepathFile -classpath @$classpathFile ./src/$mainPackageName/Main.java

# Packing.
jar -cfe ./$projectName.jar $mainPackageName.Main -C ./bin .
chmod +x ./$projectName.jar

# Run.
java -jar ./$projectName.jar
