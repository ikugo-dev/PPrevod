import java_cup.runtime.*;

%%

%class Lexer
%cup
%line
%column
//%debug

%eofval{
	return new Symbol( sym.EOF );
%eofval}


%%

// pravila

[\t\r\n ]+		{ ; }

"<table>" | "<tr>" | "<td>"	| "<th>"	{ return new Symbol( sym.STARTTAG, yytext().substring(1, yytext().length() - 1 )); }

"</table>" | "</tr>" | "</td>"	| "</th>"	{ return new Symbol( sym.ENDTAG, yytext().substring(2, yytext().length() - 1 )); }

[^<>]+     { return new Symbol( sym.TEXT, yytext() ); }


// bilo koji drugi simbol predstavlja gresku
.		        { System.out.println( "ERROR: " + yytext() ); }

