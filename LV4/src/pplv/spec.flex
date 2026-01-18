// import sekcija
package pplv;

import java_cup.runtime.*;
import pplv.SymbolTable.*;

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
	if ( tokenType == sym.ID )
		return new Symbol( tokenType, yytext() );
	else
		return new Symbol( tokenType );
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
cifraOct = [0-8]

%%

// pravila
\|\* { yybegin( KOMENTAR ); }
<KOMENTAR>~"*|" { yybegin( YYINITIAL ); }

[\t\n\r ] { ; }
\( { return new Symbol( sym.LEFTPAR ); }
\) { return new Symbol( sym.RIGHTPAR ); }

//case
=> { return new Symbol( sym.THEN ); }
//aignment
:= { return new Symbol( sym.ASSIGN ); }
//operatori
// \+ { return new Symbol( sym.PLUS ); }
// \* { return new Symbol( sym.MUL ); }
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

//bool
true                                 { return new Symbol( sym.BOOLCONST, Boolean.TRUE ); }
false                                { return new Symbol( sym.BOOLCONST, Boolean.FALSE ); }
//identifikatori i kljucne reci
({slovo}|\$)({slovo}|{cifra}|\$)* { return getKW(); }
//konstante
0{cifraOct}+                         { return new Symbol( sym.INTCONST, Integer.parseInt(yytext().substring(1), 8) ); }
0x{cifraHex}+                        { return new Symbol( sym.INTCONST, Integer.parseInt(yytext().substring(2), 16) ); }
{cifra}+\.{cifra}*(E[+-]?{cifra}+)?  { return new Symbol( sym.REALCONST, Double.parseDouble(yytext()) ); }
\.{cifra}+(E[+-]?{cifra}+)?          { return new Symbol( sym.REALCONST, Double.parseDouble(yytext()) ); }
{cifra}+                             { return new Symbol( sym.INTCONST, Integer.parseInt(yytext()) ); }
'.'                                  { return new Symbol( sym.CHARCONST, Character.valueOf(yytext().charAt(1)) ); }
//obrada gresaka
. { if (yytext() != null && yytext().length() > 0) System.out.println( "ERROR: " + yytext() ); }
