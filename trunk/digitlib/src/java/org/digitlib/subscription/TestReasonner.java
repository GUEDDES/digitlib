/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.digitlib.subscription;

import org.digitlib.db.RdfDBAccess;
import com.hp.hpl.jena.db.*;
import com.hp.hpl.jena.util.*;
import com.hp.hpl.jena.rdf.model.*;
import java.util.Iterator;
import java.util.List;

public class TestReasonner {

    static String subRdfs;

    public static void main(String Args[]) {
        RdfDBAccess conn = new RdfDBAccess();
        conn.init(
                "MySQL",
                "jdbc:mysql://127.0.0.1:3306/digitlib?autoReconnect=true",
                "com.mysql.jdbc.Driver",
                "root",
                "rootroot",
                "dl_");
        conn.DBConnect();

        //Creer des modeles par connexion a la BD
        ModelRDB modelVoc = conn.getModel("vocabularies");
        ModelRDB modelVocSchema = conn.getModel("vocabulariesSchema");
        //Le constructeur de modele en memoire
        ModelMaker mm = ModelFactory.createMemModelMaker();
        //Creation du modele inMemVocModel, vide
        Model inMemVocModel = mm.createModel("vocabularies");
        //Ajoute tous les statements du modele
        inMemVocModel.add(modelVoc);
        inMemVocModel.setNsPrefixes(modelVoc.getNsPrefixMap());
        //Creation du modele inMemVocModelSchema, vide
        Model inMemVocModelSchema = mm.createModel("vocabulariesSchema");
        //Ajoute tous les statements du modele en BD
        inMemVocModelSchema.add(modelVocSchema);
        //Construit le modele d'inference sur les modeles memoire
        InfModel infModel = ModelFactory.createRDFSModel(inMemVocModelSchema, inMemVocModel);


//        VocUtils vuMem = new VocUtils(conn, true);
//        vuMem.setSelectivite(vuMem.acmNS+"J.0",vuMem.calcSelect("J.0", 10));
//        VocUtils vuNotMem = new VocUtils(conn, false);
//        System.out.println(vuNotMem.getSelectiviteFromCode("A.0"));
        // Validateur
//        ValidityReport validity = infModel.validate();
//        if (validity.isValid()) {
//            System.out.println("\nOK");
//        } else {
//            System.out.println("\nConflicts");
//            for (Iterator i = validity.getReports(); i.hasNext();) {
//                ValidityReport.Report report = (ValidityReport.Report) i.next();
//                System.out.println(" - " + report);
//            }
//        }
//
//        StmtIterator si = infModel.listStatements();
//        System.out.println("\n\n\n\n\nStatements du modele AVANT : \n\n\n\n\n");
//        while (si.hasNext()) {
//            System.out.println(si.nextStatement().asTriple());
//        }
//        SubTreeUtils subtu = new SubTreeUtils(conn);
//        subtu.printTheTree();
//        Verifie qu'on peut resonner par inference, meme sur les modeles memoire
//        System.out.println(infModel.getNsPrefixURI("acmccs98"));
//        Resource term = infModel.getResource(infModel.getNsPrefixURI("acmccs98") + "A.0.0");
//        System.out.println(term.getURI());
//
//        Retire un label
//        Statement label = infModel.getProperty(term, RDFS.label);
//        System.out.println("LE STATEMENT : " + label.asTriple() + "\n\n\n");
//        inMemVocModel.remove(label);
//        si = inMemVocModel.listStatements();
//        System.out.println("\n\n\n\n\nStatements du modele APRES : \n\n\n\n\n");
//        while (si.hasNext()) {
//            System.out.println(si.nextStatement().asTriple());
//        }
//
//        System.out.println("\n\n\n\nPOUR LE MODEL VOC\n\n\n\n");
//        Sauvegarde le resultat dans la BD
//        D'abord, ajoute les nouveaux
//        modelVoc.add(inMemVocModel);
    //Ensuite fait la difference et retire
//        Model toBeRemoved = modelVoc.difference(inMemVocModel);
//        modelVoc.remove(toBeRemoved);
//        StmtIterator si2 = modelVoc.listStatements();
//        while (si2.hasNext()) {
//            System.out.println(si2.nextStatement().asTriple());
//        }
//        HashMap<Resource, Seq> mrs= new HashMap<Resource, Seq>();
//        subtu.getAllContents(mrs, subtu.racineURI);
//        int cpt = 0;
//        Iterator itRes = mrs.keySet().iterator();
//        while (itRes.hasNext()) {
//            cpt++;
//            Resource r = (Resource) itRes.next();
//            Seq seq = mrs.get(r);
//            System.out.print("Sequence de la resource"+r.getURI()+" : ");
//            for (int i = 1; i <= seq.size(); i++) {
//                System.out.print(seq.getObject(i).toString()+" ");
//            }
//            System.out.println();
//        }

//        Iterator it = s.getSubmitter().iterator();
//        while (it.hasNext()) {
//            System.out.println(it.next());
//        }
//        Iterator it  = s.getNature().iterator();
//        while (it.hasNext()) {
//            System.out.println(it.next());
//        }
//        System.out.println();

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
//        System.out.println("ss classes directes de r1 : ");
//        printStatements(infmodel, null, ReasonerVocabulary.directSubClassOf, r1);
//


    // Test sur l'edition des subs associes a un noeud
//
//        SubTreeUtils subtu = new SubTreeUtils(conn);
//        Vector<String> vs = subtu.getSubsFromNode(r2.getURI());
//        Iterator vsi = vs.iterator();
//        System.out.println("Subs AVANT : ");
//        while (vsi.hasNext()) {
//            System.out.println(vsi.next());
//        }
//
        Subscription sub = new Subscription(
                "http://localhost/digitlib/data/subscriptions.rdf#admin_1237755030727", conn);
        List<String> li = sub.getContentTermsIds();
        System.out.println("Login : "+sub.getResAttrib().get("content"));

//        subtu.removeSubFromNode(sub.getUrl(), r2.getURI());
//
//        vs = subtu.getSubsFromNode(r2.getURI());
//        vsi = vs.iterator();
//        System.out.println("Subs APRES : ");
//        while (vsi.hasNext()) {
//            System.out.println(vsi.next());
//        }
//
//        subtu.addSubToNode(sub, r2);
//        vs = subtu.getSubsFromNode(r2.getURI());
//        vsi = vs.iterator();
//        System.out.println("Subs apres ajout : ");
//        while (vsi.hasNext()) {
//            System.out.println(vsi.next());
//        }

//        /**
//         * Test sur les termes
//         */
//        VocUtils vu = new VocUtils(conn);
//        String term = vu.acmNS + vu.getUrlByLabel("c++");
//        System.out.println("URL du term a traiter : " + term);
//
//        SubTreeUtils subtu = new SubTreeUtils(conn);
//        Vector<String> vs = subtu.getTermUrisFromNode(r2.getURI());
//        Iterator vsi = vs.iterator();
//        System.out.println("Termes AVANT : ");
//        while (vsi.hasNext()) {
//            System.out.println(vsi.next());
//        }
//
//
//        subtu.removeTermFromNode(term, r2);
//
//        vs = subtu.getTermUrisFromNode(r2.getURI());
//        vsi = vs.iterator();
//        System.out.println("Termes APRES : ");
//        while (vsi.hasNext()) {
//            System.out.println(vsi.next());
//        }
//
//        subtu.addTermToNode(term, r2);
//        vs = subtu.getTermUrisFromNode(r2.getURI());
//        vsi = vs.iterator();
//        System.out.println("Termes APRES ajout d'un nouveau terme: ");
//        while (vsi.hasNext()) {
//            System.out.println(vsi.next());
//        }
//        ArrayList al = new ArrayList();
//        String uriJB = "http://localhost/digitlib/data/substree.rdf#admin_1236814134156";
//        al.add("c++");
//        al.add("javabeans");
//        subtu.addNode(al, "admin",uriJB);
//        subtu.printTheTree();
//        String nodeuri = "http://localhost/digitlib/data/substree.rdf#sangue_1236709897109";
//        subtu.deleteNode(uriJB);
//        subtu.printTheTree();
//        String test = subtu.getSubsContentUrl(s);
//        System.out.println("Noeud contenant "+s.getUrl()+" : "+test);
//        ArrayList<String> al = subtu.getTermLabelsFromNode(test);
//        Iterator it = al.iterator();
//        while(it.hasNext()) {
//            System.out.println(it.next());
//        }
    }

    public static void printStatements(Model m, Resource s, Property p, Resource o) {
        for (StmtIterator i = m.listStatements(s, p, o); i.hasNext();) {
            Statement stmt = i.nextStatement();
            System.out.println(" - " + PrintUtil.print(stmt));

        }
    }
}
