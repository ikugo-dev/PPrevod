// import sekcija
package pplv;

import java_cup.runtime.*;
import SymbolTable.*;

%%

// sekcija opcija i deklaracija
%class MPLexer
%cup
%line
%column
%eofval{
    return new Symbol( sym.EOF );
%eofval}

%{
//dodatni clanovi generisane klase
KWTable kwTable = new KWTable();
SymbolTable symbolTable;

public void setSymbolTable(SymbolTable st) {
    this.symbolTable = st;
}

Symbol getKW()
{
    int tokenType = kwTable.find( yytext() );
    
    // If it's an identifier (not a keyword), attach the string value
    if ( tokenType == sym.ID )
    {
        return new Symbol( tokenType, yytext() );
    }
    else
    {
        // It's a keyword, no semantic value needed
        return new Symbol( tokenType );
    }
}
%}

%{
   public int getLine()
   {
      return yyline;
   }
%}

//stanja
%xstate KOMENTAR

//makroi
slovo = [a-zA-Z]
cifra = [0-9]
cifraHex = [0-9a-fA-F]
cifraOct = [0-7]

%%

// pravila
\|\* { yybegin( KOMENTAR ); }
<KOMENTAR>~"*|" { yybegin( YYINITIAL ); }

[\t\n\r ] { ; }
\( { return new Symbol( sym.LEFTPAR ); }
\) { return new Symbol( sym.RIGHTPAR ); }

//case
=> { return new Symbol( sym.THEN ); }

//assignment
:= { return new Symbol( sym.ASSIGN ); }

//operatori
\<= { return new Symbol( sym.LESSEQUAL ); }
>= { return new Symbol( sym.GREATEREQUAL ); }
== { return new Symbol( sym.EQUAL ); }
\<> { return new Symbol( sym.NOTEQUAL ); }
\<  { return new Symbol( sym.LESS ); }
>  { return new Symbol( sym.GREATER ); }

//separatori
: { return new Symbol( sym.COLON ); }
; { return new Symbol( sym.SEMICOLON ); }
, { return new Symbol( sym.COMMA ); }
\. { return new Symbol( sym.PERIOD ); }

//boolean constants - must come before identifiers
true|false  { 
    Type boolType = symbolTable.getType("boolean");
    Boolean value = Boolean.parseBoolean(yytext());
    return new Symbol(sym.CONST, new Constant(boolType, value)); 
}

//identifikatori i kljucne reci
({slovo}|\$)({slovo}|{cifra}|\$)* { return getKW(); }

//konstante
0{cifraOct}+                         { 
    Type intType = symbolTable.getType("integer");
    Integer value = Integer.parseInt(yytext().substring(1), 8); // skip leading 0, parse as octal
    return new Symbol(sym.CONST, new Constant(intType, value)); 
}

0x{cifraHex}+                        { 
    Type intType = symbolTable.getType("integer");
    Integer value = Integer.parseInt(yytext().substring(2), 16); // skip "0x", parse as hex
    return new Symbol(sym.CONST, new Constant(intType, value)); 
}

{cifra}+                             { 
    Type intType = symbolTable.getType("integer");
    Integer value = Integer.parseInt(yytext());
    return new Symbol(sym.CONST, new Constant(intType, value)); 
}

{cifra}+\.{cifra}*(E[+-]?{cifra}+)?  { 
    Type realType = symbolTable.getType("real");
    Double value = Double.parseDouble(yytext());
    return new Symbol(sym.CONST, new Constant(realType, value)); 
}

\.{cifra}+(E[+-]?{cifra}+)?          { 
    Type realType = symbolTable.getType("real");
    Double value = Double.parseDouble(yytext());
    return new Symbol(sym.CONST, new Constant(realType, value)); 
}

'.'                                  { 
    Type charType = symbolTable.getType("char");
    Character value = yytext().charAt(1); // get character between quotes
    return new Symbol(sym.CONST, new Constant(charType, value)); 
}

//obrada gresaka
. { if (yytext() != null && yytext().length() > 0) System.out.println( "ERROR: " + yytext() ); }
