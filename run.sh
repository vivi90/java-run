#!/bin/bash

########################################################
#                                                      #
#             Java compile and run script              #
#                                                      #
#                    Version 3.0.0                     #
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
libraryPath="lib"
manifestFile="MANIFEST.MF"
resourcesPath=$mainPackage"/resources"

# Checks configuration files.
if [ ! -s $compileArgumentsFile ] || [ ! -s $sourcepathFile ] || [ ! -s $classpathFile ] || [ ! -s $manifestFile ]; then
    echo -e "\033[1mConfiguration files incomplete! Aborted.\033[0m"
    exit 1;
fi

# Preparing.
sourceDirectory=$(cut -d : -f 1 $sourcepathFile)
binaryDirectory=$(cut -d : -f 1 $classpathFile)

# Cleaning.
shopt -s extglob
mkdir -p $binaryDirectory
rm -r $binaryDirectory/!(.gitkeep|.|..)

# Compiling.
javac @$compileArgumentsFile -sourcepath @$sourcepathFile -classpath @$classpathFile $sourceDirectory/$mainPackage/*.java

# Packing.
jar -cmf $manifestFile $binaryDirectory/$projectName.jar -C $sourceDirectory $resourcesPath -C $libraryPath . -C $binaryDirectory .
chmod +x $binaryDirectory/$projectName.jar

# Run.
java -jar $binaryDirectory/$projectName.jar
