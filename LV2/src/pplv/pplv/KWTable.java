package pplv;

import java.util.Hashtable;

public class KWTable {

    private Hashtable<String, Integer> mTable;

    public KWTable() {
        // Inicijalizcaija hash tabele koja pamti kljucne reci
        mTable = new Hashtable<String, Integer>();
        mTable.put("begin", Integer.valueOf(sym.BEGIN));
        mTable.put("end", Integer.valueOf(sym.END));

        mTable.put("select", Integer.valueOf(sym.SELECT));
        mTable.put("case", Integer.valueOf(sym.CASE));
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
