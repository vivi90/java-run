#!/bin/bash

########################################################
#                                                      #
#             Java compile and run script              #
#                                                      #
#                    Version 2.0.0                     #
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

# Preparing.
sourceDirectory=$(cut -d : -f 1 $sourcepathFile)
binaryDirectory=$(cut -d : -f 1 $classpathFile)

# Cleaning.
rm -r -f $binaryDirectory
mkdir -p $binaryDirectory
touch $binaryDirectory/.gitkeep
rm -f $binaryDirectory/$projectName.jar

# Compiling.
javac @$compileArgumentsFile -sourcepath @$sourcepathFile -classpath @$classpathFile $sourceDirectory/$mainPackageName/Main.java

# Packing.
jar -cfe $binaryDirectory/$projectName.jar $mainPackageName.Main -C $binaryDirectory .
chmod +x $binaryDirectory/$projectName.jar

# Run.
java -jar $binaryDirectory/$projectName.jar
