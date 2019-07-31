#!/bin/bash

########################################################
#                                                      #
#             Java compile and run script              #
#                                                      #
#                    Version 2.0.2                     #
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
rm $binaryDirectory/$projectName.jar

# Compiling.
javac @$compileArgumentsFile -sourcepath @$sourcepathFile -classpath @$classpathFile $sourceDirectory/$mainPackageName/Main.java

# Packing.
jar -cfe $binaryDirectory/$projectName.jar $mainPackageName.Main -C $binaryDirectory .
chmod +x $binaryDirectory/$projectName.jar

# Run.
java -jar $binaryDirectory/$projectName.jar
