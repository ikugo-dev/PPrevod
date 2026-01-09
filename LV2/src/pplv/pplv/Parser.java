package pplv;

import java.util.*;

public class Parser {
    private final Action[][] actionTable;
    private final int[][] gotoTable;
    private final Rule[] rules;
    private final List<Yytoken> tokens;
    private int currentToken;

    public Parser(
            Action[][] actionTable,
            int[][] gotoTable,
            Rule[] rules,
            List<Yytoken> tokens) {
        this.actionTable = actionTable;
        this.gotoTable = gotoTable;
        this.rules = rules;
        this.tokens = tokens;
        this.currentToken = -1;
    }

    private Yytoken nextLex() {
        currentToken++;
        // if (currentToken >= this.tokens.size())
        // return new Yytoken(sym.EOF, "$", -1, -1);
        return this.tokens.get(currentToken);
    }

    public boolean parse() {
        Stack<Object> stack = new Stack<>();

        // init
        stack.push(0);
        boolean known = false;
        boolean mistake = false;

        Yytoken next = nextLex();

        // analyzer
        while (!(known || mistake)) {

            int state = (Integer) stack.peek();
            Action action = actionTable[state][next.m_index];

            if (action == null) {
                System.out.println("Syntax error at token " + next);
                System.out.println("State: " + state);
                mistake = true;
                break;
            }

            switch (action.type) {

                case SHIFT:
                    stack.push(next.m_index);
                    stack.push(action.value);
                    next = nextLex();
                    break;
                case REDUCE:
                    Rule rule = rules[action.value];
                    for (int i = 0; i < rule.size * 2; i++) {
                        stack.pop();
                    }
                    int topState = (Integer) stack.peek();
                    stack.push(rule.symbol);
                    stack.push(gotoTable[topState][rule.symbol.ordinal()]);
                    break;
                case ACCEPT:
                    known = true;
                    break;
                case ERROR:
                    mistake = true;
                    break;
            }
        }

        return known;
    }
}

// int SA_LR() {
// // init
// push(a, 0)
// known = false
// mistake = false
// next = nextlex() // lexical analyzer
// // analyzer
// do {
// switch action(top(a), next) {
// sk:
// push(a, next)
// push(a, k)
// next = nextlex()
// break;
// rk:
// pop(a, 2*rule[k].size)
// top_state = top(a)
// push(a, rule[k].left)
// push(a, goto(top_state, rule[k].left))
// break;
// acc:
// known = true
// break
// acc:
// mistake = true
// break
// }
// } while ( ! (known || mistake))
// return known
// }
