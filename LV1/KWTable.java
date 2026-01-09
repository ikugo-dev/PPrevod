import java.util.Hashtable;

public class KWTable {

    private Hashtable<String, Integer> mTable;

    public KWTable() {
        // Inicijalizcaija hash tabele koja pamti kljucne reci
        mTable = new Hashtable<String, Integer>();
        mTable.put("program", Integer.valueOf(sym.PROGRAM));
        mTable.put("begin", Integer.valueOf(sym.BEGIN));
        mTable.put("end", Integer.valueOf(sym.END));

        mTable.put("integer", Integer.valueOf(sym.INTEGER));
        mTable.put("char", Integer.valueOf(sym.CHAR));
        mTable.put("real", Integer.valueOf(sym.REAL));
        mTable.put("boolean", Integer.valueOf(sym.BOOLEAN));

        mTable.put("select", Integer.valueOf(sym.SELECT));
        mTable.put("case", Integer.valueOf(sym.CASE));

        mTable.put("or", Integer.valueOf(sym.OR));
        mTable.put("and", Integer.valueOf(sym.AND));
    }

    /**
     * Vraca ID kljucne reci
     */
    public int find(String keyword) {
        Integer symbol = mTable.get(keyword);
        if (symbol != null)
            return symbol.intValue();

        // Ako rec nije pronadjena u tabeli kljucnih reci radi se o identifikatoru
        return sym.ID;
    }
}
