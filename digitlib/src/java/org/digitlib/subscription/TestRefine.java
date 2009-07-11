/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.digitlib.subscription;

import java.util.*;
import org.digitlib.db.RdfDBAccess;
import com.hp.hpl.jena.vocabulary.*;
import com.hp.hpl.jena.rdf.model.*;
import com.hp.hpl.jena.util.*;
import com.hp.hpl.jena.db.*;

/**
 *
 * @author robu
 */
public class TestRefine {

    public static void main(String Args[]) {
        RdfDBAccess conn = new RdfDBAccess();
        conn.init(
                "MySQL",
                "jdbc:mysql://localhost:3306/digitlib?autoReconnect=true",
                "com.mysql.jdbc.Driver",
                "root",
                "rootroot",
                "dl_");
        conn.DBConnect();

//        ModelRDB modelVoc = conn.getModel("vocabularies");
//        ModelRDB modelVocSchema = conn.getModel("vocabulariesSchema");
//        InfModel infmodel = ModelFactory.createRDFSModel(modelVocSchema, modelVoc);
//
//        Resource r1 = infmodel.getResource("http://www.acm.org/class/1998#A.");
//        Resource r2 = infmodel.getResource("http://www.acm.org/class/1998#A.0");
//
//        System.out.println("r1 ss classe de r2 ? :");
//        printStatements(infmodel, r1, RDFS.subClassOf, r2);
//
//        System.out.println("r2 ss classe de r1 ? :");
//        printStatements(infmodel, r2, RDFS.subClassOf, r1);
//
//        System.out.println("r1 est ss classe de :");
//        printStatements(infmodel, r1, RDFS.subClassOf, null);
//
//        System.out.println("r2 est ss classe de :");
//        printStatements(infmodel, r2, RDFS.subClassOf, null);
//
        VocUtils vocUtils = new VocUtils(conn,true);
//        Vector<Subscription> vectSubs = SubsUtils.getAllSubs(conn);

//        // Affichage de toutes les subscriptions
//        Iterator it = vectSubs.iterator();
//        int i = 0;
//        while (it.hasNext()) {
//            Subscription subs = (Subscription) it.next();
//            System.out.println(i + " ---------------------");
//            System.out.println("Url : " + subs.getUrl());
//            System.out.println("Submitter : " + subs.getSubmitter().getLogin());
//            System.out.println("Content : " + subs.descrToString("content"));
//            System.out.println("Nature : " + subs.natureToString());
//            System.out.println("Notif : " + subs.notifToString());
//            System.out.println("Voc : " + subs.getVoc().getName());
//            System.out.println();
//            i++;
//        }

        //SubsUtils.refine(vectSubs.elementAt(0), vectSubs.elementAt(1), vocUtils);
        //SubsUtils.refine(vectSubs.elementAt(1), vectSubs.elementAt(0), vocUtils);
        //SubsUtils.refine(vectSubs.elementAt(1), vectSubs.elementAt(1), vocUtils);

        ArrayList<String> l1 = new ArrayList<String>();
        l1.add("jsp");
        l1.add("quicksort");
        ArrayList<String> l2 = new ArrayList<String>();
        l2.add("ool");
        l2.add("quicksort");
        //SubsUtils.refine(l1, l2, vocUtils);

//        // Test de LUB
//        System.out.println(vocUtils.miniLub("c++", "jsp"));
//
//        SubsUtils.lub(SubsUtils.getTerms(vectSubs.elementAt(0)), SubsUtils.getTerms(vectSubs.elementAt(1)), vocUtils);

        //vocUtils.calcAllSelectivities();
//        vocUtils.parcoursTerms(vocUtils.VOCNAME);

//        // Doit renvoyer true
//        System.out.println("-- True --");
//        SubsUtils.refine(vectSubs.elementAt(1), vectSubs.elementAt(0), vocUtils);
//        SubsUtils.refine(vectSubs.elementAt(2), vectSubs.elementAt(0), vocUtils);
//        SubsUtils.refine(vectSubs.elementAt(3), vectSubs.elementAt(1), vocUtils);
//        SubsUtils.refine(vectSubs.elementAt(3), vectSubs.elementAt(2), vocUtils);
//        SubsUtils.refine(vectSubs.elementAt(3), vectSubs.elementAt(0), vocUtils); // ???
//
//        // Doit renvoyer false
//        System.out.println("-- False --");
//        SubsUtils.refine(vectSubs.elementAt(0), vectSubs.elementAt(1), vocUtils);
//        SubsUtils.refine(vectSubs.elementAt(0), vectSubs.elementAt(2), vocUtils);
//        SubsUtils.refine(vectSubs.elementAt(1), vectSubs.elementAt(3), vocUtils);
//        SubsUtils.refine(vectSubs.elementAt(2), vectSubs.elementAt(3), vocUtils);
//        SubsUtils.refine(vectSubs.elementAt(0), vectSubs.elementAt(3), vocUtils);
//
//        // Zarb
//        System.out.println("-----------");
//        SubsUtils.refine(vectSubs.elementAt(4), vectSubs.elementAt(5), vocUtils);
//        SubsUtils.refine(vectSubs.elementAt(5), vectSubs.elementAt(4), vocUtils);
//
//        //
//        SubsUtils.refine(vectSubs.elementAt(4), vectSubs.elementAt(4), vocUtils);
//        SubsUtils.refine(vectSubs.elementAt(5), vectSubs.elementAt(6), vocUtils);
//        SubsUtils.refine(vectSubs.elementAt(6), vectSubs.elementAt(5), vocUtils);
//
//        SubsUtils.refine(vectSubs.elementAt(7), vectSubs.elementAt(8), vocUtils);
    // Test de LUB
    //ArrayList<String> L = SubsUtils.lub(vectSubs.elementAt(8), vectSubs.elementAt(10), vocUtils);
    }

    public static void printStatements(Model m, Resource s, Property p, Resource o) {
        for (StmtIterator i = m.listStatements(s, p, o); i.hasNext();) {
            Statement stmt = i.nextStatement();
            System.out.println(" - " + PrintUtil.print(stmt));

        }
    }
}
