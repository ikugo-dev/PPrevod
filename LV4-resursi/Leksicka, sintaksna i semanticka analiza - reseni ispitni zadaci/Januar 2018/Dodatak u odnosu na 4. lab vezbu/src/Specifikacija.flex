import java_cup.runtime.*;

%%

%class Lexer
%cup
%line
%column

%eofval{
	return new Symbol( sym.EOF );
%eofval}

// makroi
slovo = [a-zA-Z]
cifra = [0-9]
okta  = [0-7]
heksa = [0-9A-F]

%%

// pravila

[\t\r\n ]		{ ; }

:				{ return new Symbol( sym.DVE_TACKE ); }
\{				{ return new Symbol( sym.LEVA_ZAGRADA );  }
\}				{ return new Symbol( sym.DESNA_ZAGRADA );  }
,				{ return new Symbol( sym.ZAREZ );	}

"enum"		    { return new Symbol( sym.ENUM );	}	
"INT"			{ return new Symbol( sym.INT );	}
"STRING"		{ return new Symbol( sym.STRING );	}

({slovo}|_)({slovo}|_|{cifra})*	 { return new Symbol( sym.ID, yytext() ); }

\'[^']*\'		{ return new Symbol( sym.STRING_CONST, yytext() ); }
0{okta}+        { return new Symbol( sym.INT_CONST, Integer.parseInt( yytext(), 8 ) ); }
{cifra}+		{ return new Symbol( sym.INT_CONST, Integer.parseInt( yytext() ) ); }
0x{heksa}+      { return new Symbol( sym.INT_CONST, Integer.decode( yytext() ) ); }

// bilo koji drugi simbol predstavlja gresku
.		        { System.out.println( "ERROR: " + yytext() ); }

