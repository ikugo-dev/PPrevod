package pplv;

import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;

public class Main {

    public static void main(String[] args) throws Exception {
        if (args.length != 1) {
            System.err.println("Usage: java -cp bin pplv.Main <input file>");
            System.exit(1);
        }
        MPLexer lexer = new MPLexer(new FileReader(args[0]));

        List<Yytoken> tokens = new ArrayList<>();
        Yytoken t = lexer.next_token();
        while (t.m_index != sym.EOF) {
            tokens.add(t);
            t = lexer.next_token();
        }
        tokens.add(lexer.next_token());
        Parser parser = new Parser(ParserTables.ACTION, ParserTables.GOTO, ParserTables.RULES, tokens);

        boolean ok = parser.parse();

        if (ok) {
            System.out.println("Valid program!!!");
        } else {
            System.out.println("Syntax error!!!");
        }
    }
}
