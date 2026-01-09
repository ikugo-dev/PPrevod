package pplv;

public class ParserTables {

    public static final Rule[] RULES = {
            new Rule(Nonterminal.SSPrim, 1),
            new Rule(Nonterminal.SS, 4),
            new Rule(Nonterminal.CL, 2),
            new Rule(Nonterminal.CL, 1),
            new Rule(Nonterminal.C, 4),
            new Rule(Nonterminal.S, 1),
            new Rule(Nonterminal.S, 4),
            new Rule(Nonterminal.S, 4)
    };

    public static final Action[][] ACTION = new Action[23][10];

    static {
        ACTION[0][sym.SELECT] = new Action(ActionType.SHIFT, 2);
        ACTION[1][sym.EOF] = new Action(ActionType.ACCEPT, 0);
        ACTION[2][sym.BEGIN] = new Action(ActionType.SHIFT, 3);
        ACTION[3][sym.CASE] = new Action(ActionType.SHIFT, 6);
        ACTION[4][sym.END] = new Action(ActionType.SHIFT, 7);
        ACTION[4][sym.CASE] = new Action(ActionType.SHIFT, 6);
        ACTION[5][sym.END] = new Action(ActionType.REDUCE, 3);
        ACTION[5][sym.CASE] = new Action(ActionType.REDUCE, 3);
        ACTION[6][sym.ID] = new Action(ActionType.SHIFT, 9);
        ACTION[7][sym.EOF] = new Action(ActionType.REDUCE, 1);
        ACTION[8][sym.END] = new Action(ActionType.REDUCE, 2);
        ACTION[8][sym.CASE] = new Action(ActionType.REDUCE, 2);
        ACTION[9][sym.THEN] = new Action(ActionType.SHIFT, 10);
        ACTION[10][sym.SELECT] = new Action(ActionType.SHIFT, 14);
        ACTION[10][sym.ID] = new Action(ActionType.SHIFT, 13);
        ACTION[11][sym.END] = new Action(ActionType.REDUCE, 4);
        ACTION[11][sym.CASE] = new Action(ActionType.REDUCE, 4);
        ACTION[12][sym.END] = new Action(ActionType.REDUCE, 5);
        ACTION[12][sym.CASE] = new Action(ActionType.REDUCE, 5);
        ACTION[13][sym.ASSIGN] = new Action(ActionType.SHIFT, 15);
        ACTION[15][sym.ID] = new Action(ActionType.SHIFT, 17);
        ACTION[15][sym.CONST] = new Action(ActionType.SHIFT, 18);
        ACTION[16][sym.CASE] = new Action(ActionType.SHIFT, 6);
        ACTION[17][sym.SEMICOLON] = new Action(ActionType.SHIFT, 20);
        ACTION[18][sym.SEMICOLON] = new Action(ActionType.SHIFT, 21);
        ACTION[19][sym.END] = new Action(ActionType.SHIFT, 22);
        ACTION[19][sym.CASE] = new Action(ActionType.SHIFT, 6);
        ACTION[20][sym.END] = new Action(ActionType.REDUCE, 6);
        ACTION[20][sym.CASE] = new Action(ActionType.REDUCE, 6);
        ACTION[21][sym.END] = new Action(ActionType.REDUCE, 7);
        ACTION[21][sym.CASE] = new Action(ActionType.REDUCE, 7);
        ACTION[22][sym.END] = new Action(ActionType.REDUCE, 1);
        ACTION[22][sym.CASE] = new Action(ActionType.REDUCE, 1);
    }

    public static final int[][] GOTO = new int[23][5];
    static {
        GOTO[0][Nonterminal.SS.ordinal()] = 1;
        GOTO[3][Nonterminal.CL.ordinal()] = 4;
        GOTO[3][Nonterminal.C.ordinal()] = 5;
        GOTO[4][Nonterminal.C.ordinal()] = 8;
        GOTO[10][Nonterminal.SS.ordinal()] = 12;
        GOTO[10][Nonterminal.S.ordinal()] = 11;
        GOTO[16][Nonterminal.CL.ordinal()] = 19;
        GOTO[16][Nonterminal.C.ordinal()] = 5;
        GOTO[19][Nonterminal.C.ordinal()] = 8;
    };
}
