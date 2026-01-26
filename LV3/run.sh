#!/bin/bash
if [[ $# -ne 1 ]]; then
    echo "Usage: ./run <input_file>"
    exit
fi
cd src || exit
jflex spec.flex
rm MPLexer.java\~   
java -jar ../lib/java_cup.jar -parser MPParser ./MPParser.cup  
cd ..
javac -cp "./lib/*" -d ./bin ./src/*.java # -Xlint:deprecation
java -cp "./bin:./lib/java_cup_runtime.jar" MPParser $1
