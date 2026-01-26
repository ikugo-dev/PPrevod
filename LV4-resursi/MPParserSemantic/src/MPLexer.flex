// import sekcija
import java_cup.runtime.*;

%%
// sekcija deklaracija
%class MPLexer

%cup

%line
%column

%eofval{
	return new Symbol( sym.EOF );
%eofval}

%{
   public int getLine()
   {
      return yyline;
   }
%}


//stanja
%xstate KOMENTAR
//macros
slovo = [a-zA-Z]
cifra = [0-9]

%%
// rules section
\(\*			{ yybegin( KOMENTAR ); }
<KOMENTAR>\*\)	{ yybegin( YYINITIAL ); }
<KOMENTAR>~"*)" { yybegin( YYINITIAL ); }

[\t\r\n ]		{ ; }

//operatori
\+				{ return new Symbol( sym.PLUS ); }
\*				{ return new Symbol( sym.MUL );  }

//separatori
;				{ return new Symbol( sym.SEMI );	}
,				{ return new Symbol( sym.COMMA );	}
\.				{ return new Symbol( sym.DOT ); }
:				{ return new Symbol( sym.COLON ); }
:=				{ return new Symbol( sym.ASSIGN ); }
\(				{ return new Symbol( sym.LEFTPAR ); }
\)				{ return new Symbol( sym.RIGHTPAR ); }

//kljucne reci
"program"		{ return new Symbol( sym.PROGRAM );	}	
"var"			{ return new Symbol( sym.VAR );	}
"integer"		{ return new Symbol( sym.INTEGER );	}
"char"			{ return new Symbol( sym.CHAR );	}
"read"			{ return new Symbol( sym.READ );	}
"write"			{ return new Symbol( sym.WRITE );	}
"if"			{ return new Symbol( sym.IF );	}
"then"			{ return new Symbol( sym.THEN );	}
"else"			{ return new Symbol( sym.ELSE );	}
"begin"			{ return new Symbol( sym.BEGIN );	}
"end"			{ return new Symbol( sym.END );	}

//identifikatori
{slovo}({slovo}|{cifra})*	{ return new Symbol( sym.ID, yyline, yytext() ); }

//konstante
\'[^]\'			{ return new Symbol( sym.CHARCONST, new Character( yytext().charAt(1) ) ); }
{cifra}+		{ return new Symbol( sym.INTCONST, new Integer( yytext() ) ); }


//obrada greske
.		{ System.out.println( "ERROR: " + yytext() ); }

