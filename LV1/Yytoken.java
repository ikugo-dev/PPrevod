class Yytoken {
    public int m_index;
    public String m_text;
    public int m_line;
    public int m_column;
    public Object value;

    Yytoken(int index, String text, int line, int column) {
        m_index = index;
        m_text = text;
        m_line = line;
        m_column = column;
    }

    public String toString() {
        return m_index + ": " + m_text;
        // return "Text : " + m_text
        // + "\nindex : " + m_index
        // + "\nline : " + m_line
        // + "\ncolumn : " + m_column;
    }
}
