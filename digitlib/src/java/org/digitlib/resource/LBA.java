/**
 * PersQueryRdb.java
 *
 * Created on 9 février 2006, 11:47
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package org.digitlib.resource;

import java.util.*;
import java.io.*;
import org.digitlib.Config;
import org.digitlib.db.RdfDBAccess;
import org.digitlib.vocabulary.Vocabulary;

/**
 *
 * @author nguer
 */
//Variable pour contenir les preferences
public class LBA {

    public RdfDBAccess rdfDB;
    public PrintWriter out;
    public List<String> nEQAttr = new ArrayList();
    public Config conf = new Config();
    private String vocName;

    /**
     * Creates a new instance of PersQueryRdb
     */
    public LBA() {
    }

    public LBA(RdfDBAccess rdfDB) {
        this.rdfDB = rdfDB;
    }

    public List<List<String>> constructQueryBlocks(List<AttribQuery> prefQuery0) {
        List<AttribQuery> prefQuery = new ArrayList();
        for (AttribQuery attr : prefQuery0) {
            if (attr.prefSize != 0) {
                prefQuery.add(attr);
            }
        }
        List<List<String>> QB = new ArrayList();
        nEQAttr = new ArrayList();

        if (prefQuery.isEmpty()) {
            return QB;
        }

        Resource res = new Resource(rdfDB);
        Vocabulary voc = new Vocabulary(getVocName(),rdfDB);
        
        if (prefQuery.size() == 1) {
            if (prefQuery.get(0).prefSize != 0) {
                if ("content".equals(prefQuery.get(0).name)) {
                    nEQAttr.add(prefQuery.get(0).name);
                    for (List<String> bloc : prefQuery.get(0).prefBlocks()) {
                        QB.add(res.contentUrl(voc.getUrl(), bloc));
                    }               
                } else {
                    nEQAttr.add(prefQuery.get(0).name);
                    QB = prefQuery.get(0).prefBlocks();
                }
            }
        } else {
            //if attributes are equally preference
            List<List<List<String>>> PBL = new ArrayList();
            //Getting individual attribute block list
            //out.print("No empty Individual attributes<br>");

            for (AttribQuery attr : prefQuery) {
                if (attr.prefSize != 0) {
                    nEQAttr.add(attr.name);
                    if ("content".equals(attr.name)) {
                        List<List<String>> descPrefBloc = new ArrayList();
                        for (List<String> bloc : attr.prefBlocks()) {
                            descPrefBloc.add(res.contentUrl(voc.getUrl(), bloc));
                        }
                        PBL.add(descPrefBloc);
                    } else {
                        PBL.add(attr.prefBlocks());
                    }
                }
            }

            List<List<String>> QBL = PBL.get(0);
            List<List<String>> QBR = new ArrayList();

            int n;
            for (int h = 1; h < PBL.size(); h++) {//Parcourt des blocs individuels
                QBR = PBL.get(h);
                n = QBL.size() + QBR.size() - 1;
                List<List<String>> QBT = new ArrayList();
                for (int w = 0; w < n; w++) {
                    //QBL[i] X QBR[j] with i+j=w
                    List<String> BT = new ArrayList();
                    for (int i = 0; i <= w; i++) {
                        if (i < QBL.size()) {
                            for (int k = 0; k < QBL.get(i).size(); k++) {
                                if ((w - i) < QBR.size()) {
                                    for (int j = 0; j < QBR.get(w - i).size(); j++) {
                                        BT.add(QBL.get(i).get(k) + " " + QBR.get(w - i).get(j));
                                    }
                                }
                            }
                        }
                    }
                    if (!BT.isEmpty()) {
                        QBT.add(BT);
                    }
                }

                QBL = QBT;
            }
            QB = QBL;

        }

        return QB;
    }

    public String getBlockQueries(List<String> QB) {
        String query = "";
        int j = 0;
        do {
            String tab[] = QB.get(j).split(" ");
            query += "{";
            for (int i = 0; i < nEQAttr.size(); i++) {
                query += "  ?uri res:" + nEQAttr.get(i) + " ?o" + j + i + " . FILTER(STR(?o" + j + i + ")=\"" + tab[i] + "\" ). ";
            }
            query += "}";
            j++;
            if (j < QB.size()) {
                query += "UNION";
            }
        } while (j < QB.size());

        return query;
    }

    //Getting query for with attribute form
    public String getQuery(List<AttribQuery> prefQuery) {//Creating the rdf query induced by the attribute queries
        List<String> nEAName = new ArrayList();//To store list of no empty query attribute name
        List<List<String>> aTerm = new ArrayList();//To store the list of query

        for (AttribQuery pq : prefQuery) {
            if (pq.queryTerms.size() != 0) {//Storing the non empty attribute query in a list
                nEAName.add(pq.name);
                List<String> ATL = new ArrayList();//ATL: Attribute Term List: Contain the list of term on an attribute query
                for (String term : pq.queryTerms) {
                    ATL.add(term);
                }
                aTerm.add(ATL);
            }
        }
        if (nEAName.isEmpty()) {
            return "";
        }

        List<String> QT = aTerm.get(0);
        for (int i = 1; i < aTerm.size(); i++) {
            List<String> QR = aTerm.get(i);
            List<String> TT = new ArrayList();
            for (int j = 0; j < QT.size(); j++) {
                for (int k = 0; k < QR.size(); k++) {
                    TT.add(QT.get(j) + " " + QR.get(k));
                }
            }
            QT = TT;
        }
        String query = "";
        int j = 0;
        do {
            String tab[] = QT.get(j).split(" ");
            query += "{";
            for (int i = 0; i < nEAName.size(); i++) {
                query += "  ?uri res:" + nEAName.get(i) + " ?o" + i + j + " . FILTER (STR(?o" + i + j + ") = \"" + tab[i] + "\") . ";
            }
            query += "}";
            j++;
            if (j < QT.size()) {
                query += "UNION";
            }
        } while (j < QT.size());

        return query;
    }

    //Getting the query for no attribute form.
    public String getNAQuery(String query) {
        String tab[] = query.split(" ");
        int tabLen = tab.length;
        if (tabLen == 1) {
            if (tab[0].equals("")) {
                tab = null;
            }
        }
        query = "";
        for (int i = 0; i < tabLen; i++) {
            query += "{?uri ?p ?r . FILTER REGEX(str(?r),\"" + tab[i] + "\")}";
            if ((i + 1) < tabLen) {
                query += " UNION ";
            }
        }
        return query;
    }

    //For get the query for rdf data base
    public String getFinalQuery(String queryQ, int nB, List<List<String>> QB) {
        String queryQi;
        String PQ =//The beginning of the query
                "PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>" +
                "PREFIX dc:<http://purl.org/dc/elements/1.1/> " +
                "PREFIX res:<" + conf.getRes() + "s#>" +
                "SELECT  DISTINCT ?uri  " +
                "WHERE {";

        if (!queryQ.equals("")) {
            PQ += "{" + queryQ + "}";
        }
        if (QB.size() != 0) {
            queryQi = getBlockQueries(QB.get(nB));
        } else {
            queryQi = "";
        }

        if (!queryQi.equals("")) {
            if (!queryQ.equals("")) {
                PQ += ".{" + queryQi + "}";
            } else {
                PQ += "{" + queryQi + "}";
            }
        }

        PQ += "}";
        return PQ;
    }

    /**
     * @return the vocName
     */
    public String getVocName() {
        return vocName;
    }

    /**
     * @param vocName the vocName to set
     */
    public void setVocName(String vocName) {
        this.vocName = vocName;
    }
}
