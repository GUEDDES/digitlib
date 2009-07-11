/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.digitlib.subscription;

import org.digitlib.db.*;
import com.hp.hpl.jena.query.*;
import java.util.*;

import java.util.Vector;

/**
 *
 * @author robu
 */
public class SubsUtils {

    /**
     * @param s1
     * @param s2
     * @param vocUtils
     * @return
     */
    public static boolean refine(Subscription s1, Subscription s2, VocUtils vocUtils) {
        ArrayList listeCodes1 = SubsUtils.getTermCodes(s1, vocUtils);
        ArrayList listeCodes2 = SubsUtils.getTermCodes(s2, vocUtils);
        return (refine2(listeCodes1, listeCodes2, vocUtils));
    }

    public static boolean refine2(List listeCodes1, List listeCodes2, VocUtils vocUtils) {
        //On parcours les termes de s2
        Iterator it2 = listeCodes2.iterator();
        boolean ok = true;
        while (it2.hasNext() && ok) {
            String termCode2 = (String) it2.next();
            boolean found = false;
            Iterator it1 = listeCodes1.iterator();
            while (it1.hasNext() && !found) {
                String termCode1 = (String) it1.next();
                found = vocUtils.subsumes(termCode2, termCode1);
            }
            if (!found) {
                ok = false;
            }
        }

        //////////////////////////////////////////////////////
//        System.out.print("refine(");
//        for (Iterator iter = l1.iterator(); iter.hasNext();) {
//            System.out.print((String) iter.next() + " ");
//        }
//        System.out.print(",");
//        for (Iterator iter = l2.iterator(); iter.hasNext();) {
//            System.out.print(" " + (String) iter.next());
//        }
//        System.out.println(") : " + ok);
        //////////////////////////////////////////////////////

        return ok;
    }

    /**
     * Retourne le lub de deux listes de codes
     * @param listeCode1
     * @param listeCode2
     * @param vocUtils
     * @return
     */
    public static ArrayList<String> lub(ArrayList<String> listeCode1, ArrayList<String> listeCode2, VocUtils vocUtils) {
        ArrayList<String> l = new ArrayList<String>();
        Map<String, String> hashTree = new HashMap();

        // Produit cartesien des deux subscriptions
        for (Iterator i1 = listeCode1.iterator(); i1.hasNext();) {
            String code1 = (String) i1.next();
            for (Iterator i2 = listeCode2.iterator(); i2.hasNext();) {
                String code2 = (String) i2.next();
                String minilub = vocUtils.miniLub(code1, code2);
                hashTree.put(minilub, "pouet");
            }
        }

        ArrayList<String> lunreduced = new ArrayList<String>();
        // Reduction de hashTree
        for (Iterator i = hashTree.keySet().iterator(); i.hasNext();) {
            String termCode = (String) i.next();
            lunreduced.add(termCode);
        }
        l = reduce(lunreduced, vocUtils);

        ////////////////////////////////////////////////////////////////
//        System.out.print("lub( ");
//        for (Iterator i = liste1.iterator(); i.hasNext();) {
//            String t = (String) i.next();
//            System.out.print(t + " ");
//        }
//        System.out.print(", ");
//        for (Iterator i = liste2.iterator(); i.hasNext();) {
//            String t = (String) i.next();
//            System.out.print(t + " ");
//        }
//        System.out.print(") : ");
//        for (Iterator i = l.iterator(); i.hasNext();) {
//            String t = (String) i.next();
//            System.out.print(t + " ");
//        }
//        System.out.println();
        ////////////////////////////////////////////////////////////////
        return l;
    }

    /**
     * R�duit une liste de termes
     * ex : {Java, Programming, OOL, Sort} -> {Java, Sort}
     * @param l
     * @param vocUtils
     * @return
     */
    public static ArrayList<String> reduce(ArrayList<String> listeCode, VocUtils vocUtils) {
        ArrayList<String> reduced = new ArrayList<String>();
        for (Iterator i1 = listeCode.iterator(); i1.hasNext();) {
            String code1 = (String) i1.next();
            boolean ok = true;
            Iterator i2 = listeCode.iterator();
            while (i2.hasNext() && ok) {
                String code2 = (String) i2.next();
                if (!code2.equals(code1)) {
                    if (vocUtils.subsumes(code1, code2)) {
                        ok = false;
                    }
                }
            }
            if (ok) {
                reduced.add(code1);
            }
        }
        return reduced;
    }

    public static Vector<Subscription> getAllSubs(RdfDBAccess conn) {
        Vector<Subscription> vectSubs = new Vector<Subscription>();

        SubsQueries sbQuery = new SubsQueries();
        //Recupere toutes les subscriptions
        ResultSet result = conn.execSelectQuery(sbQuery.getAllSubs(), sbQuery.getModel());

        // Remplie le vecteur de subscriptions
        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            String url = rb.get("r").toString();
            vectSubs.add(new Subscription(url, conn, Locale.ENGLISH));
        }
        return vectSubs;
    }

    public static Vector<Subscription> getAllSubs(RdfDBAccess conn, String vocName) {
        Vector<Subscription> vectSubs = new Vector<Subscription>();
        SubsQueries sbQuery = new SubsQueries();
        //Recupere toutes les subscriptions
        ResultSet result = conn.execSelectQuery(sbQuery.getAllSubs(), sbQuery.getModel());
        // Remplie le vecteur de subscriptions
        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            String url = rb.get("r").toString();
            Subscription subs = new Subscription(url, conn, Locale.ENGLISH);
            if (subs.getVoc().getName().equals(vocName)) {
                vectSubs.add(subs);
            }
        }
        return vectSubs;
    }

    /**
     * @param s
     * @return
     */
    public static ArrayList<String> getTermCodes(Subscription s, VocUtils vocUtils) {
        ArrayList list = new ArrayList<String>();

        // Fill the map
        for (Iterator iter = s.getResAttrib().get("content").iterator(); iter.hasNext();) {
            String code = (String) iter.next();
            //String code = vocUtils.getUrlByLabel(term);
            list.add(code);
        }

        return list;
    }
}
