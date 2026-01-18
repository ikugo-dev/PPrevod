#!/bin/bash
if [[ $# -ne 1 ]]; then
    echo "Usage: ./run <input_file>"
    exit
fi
cd src/pplv || exit
jflex spec.flex
rm MPLexer.java\~
java -jar ../../lib/java_cup.jar -parser MPParser ./MPParser.cup  
cd ../..

javac -cp "./lib/*" -d ./bin $(fd . ./src/pplv/ -e java -t f) # -Xlint:deprecation
java -cp "./bin:./lib/java_cup_runtime.jar" pplv.MPParser $1
