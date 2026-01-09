#!/bin/bash
cd src || exit
jflex spec.flex
java -jar ../lib/java_cup.jar -parser MPParser ./MPParser.cup  
cd ..
javac -cp "./lib/*" -d ./bin ./src/*.java # -Xlint:deprecation
java -cp "./bin:./lib/java_cup_runtime.jar" MPParser input.txt
