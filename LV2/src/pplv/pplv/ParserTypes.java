package pplv;

enum ActionType {
    SHIFT, REDUCE, ACCEPT, ERROR
}

class Action {
    ActionType type;
    int value;

    Action(ActionType type, int value) {
        this.type = type;
        this.value = value;
    }
}

enum Nonterminal {
    SSPrim, SS, CL, C, S
}

class Rule {
    Nonterminal symbol;
    int size;

    Rule(Nonterminal lhs, int rhsSize) {
        this.symbol = lhs;
        this.size = rhsSize;
    }
}
