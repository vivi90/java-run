#!/bin/bash

########################################################
#                                                      #
#             Java compile and run script              #
#                                                      #
#                    Version 2.1.0                     #
#                                                      #
#  2019 by Vivien Richter <vivien-richter@outlook.de>  #
#  License: GPL                                        #
#                                                      #
########################################################

# Configuration
projectName=$(basename `pwd`)
mainPackage=${projectName}
compileArgumentsFile=".javac-args"
sourcepathFile=".javac-sourcepath"
classpathFile=".javac-classpath"
resourcesPath=$mainPackage"/resources"

# Checks configuration files.
if [ ! -s $compileArgumentsFile ] || [ ! -s $sourcepathFile ] || [ ! -s $classpathFile ]; then
    echo -e "\033[1mConfiguration files incomplete! Aborted.\033[0m"
    exit 1;
fi

# Preparing.
sourceDirectory=$(cut -d : -f 1 $sourcepathFile)
binaryDirectory=$(cut -d : -f 1 $classpathFile)

# Cleaning.
shopt -s extglob
mkdir -p $binaryDirectory
rm -r  $binaryDirectory/!(.gitkeep|.|..)

# Compiling.
javac @$compileArgumentsFile -sourcepath @$sourcepathFile -classpath @$classpathFile $sourceDirectory/$mainPackage/Main.java
cp -r $sourceDirectory/$resourcesPath $binaryDirectory/$resourcesPath

# Packing.
jar -cfe $binaryDirectory/$projectName.jar $mainPackage.Main -C $binaryDirectory .
chmod +x $binaryDirectory/$projectName.jar

# Run.
java -jar $binaryDirectory/$projectName.jar
