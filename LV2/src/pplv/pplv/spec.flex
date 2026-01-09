// import sekcija
%%

// sekcija opcija i deklaracija
%class MPLexer
%function next_token
%type Yytoken
%line
%column
%debug

%eofval{
return new Yytoken( sym.EOF, null, yyline, yycolumn);
%eofval}

%{
//dodatni clanovi generisane klase
KWTable kwTable = new KWTable();
Yytoken getKW()
{
	return new Yytoken( kwTable.find( yytext() ),
	yytext(), yyline, yycolumn );
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

//case
=> { return new Yytoken( sym.THEN,   yytext(), yyline, yycolumn ); }
//aignment
:= { return new Yytoken( sym.ASSIGN, yytext(), yyline, yycolumn ); }
//separatori
; { return new Yytoken( sym.SEMICOLON, yytext(), yyline, yycolumn ); }

//identifikatori i kljucne reci
({slovo}|\$)({slovo}|{cifra}|\$)* { return getKW(); }
//konstante (tehnicki je moglo sve da bude CONST)
0{cifraOct}                         { return new Yytoken( sym.CONST,yytext(), yyline, yycolumn ); }
0x{cifraHex}                        { return new Yytoken( sym.CONST,yytext(), yyline, yycolumn ); }
{cifra}                             { return new Yytoken( sym.CONST,yytext(), yyline, yycolumn ); }
{cifra}+\.{cifra}*(E[+-]*{cifra}+)* { return new Yytoken( sym.CONST,yytext(), yyline, yycolumn ); }
\.{cifra}+(E[+-]*{cifra}+)*         { return new Yytoken( sym.CONST,yytext(), yyline, yycolumn ); }
'.'                                 { return new Yytoken( sym.CONST,yytext(), yyline, yycolumn ); }
//obrada gresaka
. { if (yytext() != null && yytext().length() > 0) System.out.println( "ERROR: " + yytext() ); }
