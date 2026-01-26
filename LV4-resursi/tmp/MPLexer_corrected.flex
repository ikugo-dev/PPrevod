// import sekcija
package pplv;

import java_cup.runtime.*;

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
true                                 { return new Symbol( sym.BOOLCONST, Boolean.TRUE ); }
false                                { return new Symbol( sym.BOOLCONST, Boolean.FALSE ); }

//identifikatori i kljucne reci
({slovo}|\$)({slovo}|{cifra}|\$)*    { return getKW(); }

//konstante - NOTE: more specific patterns MUST come before more general ones
0{cifraOct}+                         { return new Symbol( sym.INTCONST, Integer.parseInt(yytext().substring(1), 8) ); }
0x{cifraHex}+                        { return new Symbol( sym.INTCONST, Integer.parseInt(yytext().substring(2), 16) ); }
{cifra}+\.{cifra}*(E[+-]?{cifra}+)?  { return new Symbol( sym.REALCONST, Double.parseDouble(yytext()) ); }
\.{cifra}+(E[+-]?{cifra}+)?          { return new Symbol( sym.REALCONST, Double.parseDouble(yytext()) ); }
{cifra}+                             { return new Symbol( sym.INTCONST, Integer.parseInt(yytext()) ); }
'.'                                  { return new Symbol( sym.CHARCONST, Character.valueOf(yytext().charAt(1)) ); }

//obrada gresaka
. { if (yytext() != null && yytext().length() > 0) System.out.println( "ERROR: " + yytext() ); }
