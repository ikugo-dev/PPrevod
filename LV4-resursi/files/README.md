# MP Language Parser - Complete Implementation Guide

## Files Included

1. **MPParser.cup** - Complete CUP specification with semantic analysis
2. **MPLexer.flex** - Updated lexer with proper semantic value handling
3. **KWTable.java** - Keyword table (no changes needed from your version)
4. **test_input.txt** - Sample test program

## Critical Changes Made

### 1. MPLexer.flex

**Key Fix:** The `getKW()` method now properly returns the identifier string:

```java
Symbol getKW()
{
    int tokenType = kwTable.find( yytext() );
    
    // If it's an identifier (not a keyword), attach the string value
    if ( tokenType == sym.ID )
    {
        return new Symbol( tokenType, yytext() );  // ← STRING VALUE ATTACHED!
    }
    else
    {
        // It's a keyword, no semantic value needed
        return new Symbol( tokenType );
    }
}
```

**Added:** Import for SymbolTable classes:
```java
import SymbolTable.*;
```

**Added:** Symbol table field and setter:
```java
SymbolTable symbolTable;

public void setSymbolTable(SymbolTable st) {
    this.symbolTable = st;
}
```

**Added:** Boolean constant support:
```java
true|false  { 
    Type boolType = symbolTable.getType("boolean");
    Boolean value = Boolean.parseBoolean(yytext());
    return new Symbol(sym.CONST, new Constant(boolType, value)); 
}
```

**Changed:** All constant rules now return `Constant` objects:
```java
// Integer constant
{cifra}+ { 
    Type intType = symbolTable.getType("integer");
    Integer value = Integer.parseInt(yytext());
    return new Symbol(sym.CONST, new Constant(intType, value)); 
}

// Real constant
{cifra}+\.{cifra}*(E[+-]?{cifra}+)? { 
    Type realType = symbolTable.getType("real");
    Double value = Double.parseDouble(yytext());
    return new Symbol(sym.CONST, new Constant(realType, value)); 
}

// Character constant
'.' { 
    Type charType = symbolTable.getType("char");
    Character value = yytext().charAt(1);
    return new Symbol(sym.CONST, new Constant(charType, value)); 
}
```

**Fixed:** Octal constant parsing bug (was using wrong range [0-8], now [0-7]):
```java
cifraOct = [0-7]  // Fixed from [0-8]
```

**Fixed:** Optional sign in exponent:
```java
E[+-]?{cifra}+  // Changed from E[+-]*{cifra}+
```

### 2. MPParser.cup

**Terminal Changes:**
```java
terminal String ID;        // Now carries string value
terminal Constant CONST;   // Now carries Constant object (not CONST_VAL)
```

**Added Helper Methods:**
```java
public boolean canConvert( Type from, Type to )
{
    // Implements implicit type conversion: char → integer → real
}

public boolean isNumericType( Type t )
{
    // Checks if type is char, integer, or real
}
```

**Semantic Rules Implemented:**

1. **Duplicate declaration check** (in Declaration):
```java
if ( ! parser.symbolTable.addVar( ime, t ) )
{
    System.out.println( "Greska u liniji " + parser.getLine() + ": " + 
        "Promenljiva " + ime + " je vec deklarisana." );
    parser.errNo++;
}
```

2. **Undeclared variable check** (in Statement and Term):
```java
Variable var = parser.symbolTable.getVar( varName );
if ( var == null )
{
    System.out.println( "Greska u liniji " + parser.getLine() + 
        ": promenljiva " + varName + " nije deklarisana.");
    parser.errNo++;
}
```

3. **Uninitialized variable check** (in Term):
```java
if ( var.last_def == -1 )
{
    System.out.println( "Greska u liniji " + parser.getLine() + 
        ": promenljiva " + varName + " nije inicijalizovana.");
    parser.errNo++;
}
```

4. **Type conversion check** (in Statement assignment):
```java
if ( !parser.canConvert( exprType, var.type ) )
{
    System.out.println( "Greska u liniji " + parser.getLine() + ": " +
        "Tip izraza (" + exprType.name + 
        ") se ne moze dodeliti promenljivoj '" + varName + 
        "' tipa " + var.type.name + "." );
    parser.errNo++;
}
```

5. **Boolean expression in CASE** (in Case):
```java
if ( exprType == null || exprType.tkind != Type.BOOLEAN )
{
    System.out.println( "Greska u liniji " + parser.getLine() + ": " +
        "Izraz u CASE naredbi mora biti tipa boolean." );
    parser.errNo++;
}
```

6. **Relational operators** (in RelExpression):
```java
if ( !parser.isNumericType( t1 ) || !parser.isNumericType( t2 ) )
{
    System.out.println( "Greska u liniji " + parser.getLine() + ": " +
        "Relacioni operator < zahteva numeričke operande." );
    parser.errNo++;
    RESULT = parser.symbolTable.getType( "unknown" );
}
else
{
    RESULT = parser.symbolTable.getType( "boolean" );
}
```

7. **Logical operators** (in Expression and AndExpression):
```java
if ( e1 == null || e1.tkind != Type.BOOLEAN || 
     e2 == null || e2.tkind != Type.BOOLEAN )
{
    System.out.println( "Greska u liniji " + parser.getLine() + ": " +
        "Operator AND zahteva operande tipa boolean." );
    parser.errNo++;
    RESULT = parser.symbolTable.getType( "unknown" );
}
else
{
    RESULT = parser.symbolTable.getType( "boolean" );
}
```

**Error Recovery:** Comprehensive error productions for all major constructs

**Usage Tracking:** Variables track `last_def` (definition) and `last_use` (usage) for warnings

## Compilation Instructions

### 1. Generate Lexer
```bash
jflex MPLexer.flex
```

### 2. Generate Parser
```bash
java -jar java-cup-11b.jar -parser MPParser -symbols sym MPParser.cup
```

### 3. Compile Everything
```bash
javac -cp .:java-cup-11b-runtime.jar pplv/*.java SymbolTable/*.java
```

### 4. Run Parser
```bash
java -cp .:java-cup-11b-runtime.jar pplv.MPParser test_input.txt
```

## Expected Output for test_input.txt

```
Greska u liniji 6: Nedostaje ';'.
Greska u liniji 12: Nedostaje ';'.
Greska u liniji 14: Nedostaje ';'.
Greska u liniji 16: Nedostaje ';'.
Analiza zavrsena. Broj gresaka: 4 Broj upozorenja: 0
```

## Test Programs

### Valid Program
```
program
begin
    x, y : integer;
    c : char;
    r : real;
    
    c := 'A';
    x := 10;
    y := x;
    r := y
end.
```

### Semantic Errors Examples

**1. Duplicate Declaration:**
```
program
begin
    x : integer;
    x : char
end.
```
Expected: "Promenljiva x je vec deklarisana."

**2. Undeclared Variable:**
```
program
begin
    x : integer;
    y := 10
end.
```
Expected: "promenljiva y nije deklarisana."

**3. Uninitialized Variable:**
```
program
begin
    x, y : integer;
    y := x
end.
```
Expected: "promenljiva x nije inicijalizovana."

**4. Type Mismatch:**
```
program
begin
    b : boolean;
    i : integer;
    
    i := 10;
    b := i
end.
```
Expected: "Tip izraza (integer) se ne moze dodeliti promenljivoj 'b' tipa boolean."

**5. Non-Boolean in CASE:**
```
program
begin
    x : integer;
    
    x := 5;
    select begin
        case x => x := 10
    end
end.
```
Expected: "Izraz u CASE naredbi mora biti tipa boolean."

**6. Invalid Relational Operands:**
```
program
begin
    b1, b2 : boolean;
    result : boolean;
    
    b1 := true;
    b2 := false;
    result := b1 < b2
end.
```
Expected: "Relacioni operator < zahteva numeričke operande."

**7. Invalid Logical Operands:**
```
program
begin
    x, y : integer;
    b : boolean;
    
    x := 5;
    y := 10;
    b := x and y
end.
```
Expected: "Operator AND zahteva operande tipa boolean."

## Type Conversion Rules

The parser implements implicit upward type conversion:

```
char → integer → real
```

**Valid conversions:**
- char can be assigned to integer or real
- integer can be assigned to real
- Same types can always be assigned

**Invalid conversions:**
- real cannot be assigned to integer or char
- integer cannot be assigned to char
- boolean cannot be converted to/from any numeric type

## Troubleshooting

### "Variable name is null" Error
**Cause:** Lexer not returning string value with ID token
**Fix:** Ensure `getKW()` returns `new Symbol(sym.ID, yytext())` for identifiers

### "Cannot invoke String.split() because local is null"
**Cause:** Same as above - ID tokens missing string values
**Fix:** Check that lexer's `getKW()` method is implemented correctly

### "SymbolTable not found" Error
**Cause:** Missing import in lexer
**Fix:** Add `import SymbolTable.*;` to MPLexer.flex

### "Cannot find symbol: Constant"
**Cause:** Lexer can't access Constant class
**Fix:** Ensure SymbolTable package is compiled and accessible

### Constants not recognized
**Cause:** Symbol table not set in lexer
**Fix:** Ensure parser's main() calls `lexer.setSymbolTable(symbolTable)`

## Summary of Fixes

✅ **Fixed getKW()** to return identifier strings
✅ **Added SymbolTable support** to lexer
✅ **Added Constant objects** for all literal values
✅ **Added boolean literal support** (true/false)
✅ **Fixed octal digit range** (was [0-8], now [0-7])
✅ **Fixed exponent pattern** (E[+-]? instead of E[+-]*)
✅ **Implemented all 7 semantic rules**
✅ **Added comprehensive error recovery**
✅ **Added usage tracking** for warnings

All files are ready to use - just compile and test!
