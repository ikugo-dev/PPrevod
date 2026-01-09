// import sekcija
import java_cup.runtime.*;

%%

// sekcija opcija i deklaracija
//%function next_token
//%type Symbol

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
	return new Symbol( kwTable.find( yytext() ) );
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

//identifikatori i kljucne reci
({slovo}|\$)({slovo}|{cifra}|\$)* { return getKW(); }
//konstante (tehnicki je moglo sve da bude CONST)
0{cifraOct}+                         { return new Symbol( sym.CONST ); }
0x{cifraHex}+                        { return new Symbol( sym.CONST ); }
{cifra}+                             { return new Symbol( sym.CONST ); }
{cifra}+\.{cifra}*(E[+-]*{cifra}+)*  { return new Symbol( sym.CONST ); }
\.{cifra}+(E[+-]*{cifra}+)*          { return new Symbol( sym.CONST ); }
'.'                                  { return new Symbol( sym.CONST ); }
//obrada gresaka
. { if (yytext() != null && yytext().length() > 0) System.out.println( "ERROR: " + yytext() ); }
