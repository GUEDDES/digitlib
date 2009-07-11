package org.digitlib.subscription;

import org.digitlib.db.RdfDBAccess;
import com.hp.hpl.jena.db.*;
import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.vocabulary.*;
import com.hp.hpl.jena.rdf.model.*;
import com.hp.hpl.jena.util.PrintUtil;
import org.digitlib.vocabulary.VocQueries;
import org.digitlib.vocabulary.Vocabulary;
import java.util.*;

public class VocUtils {

    ModelRDB modelVoc;
    ModelRDB modelVocSchema;
    Model inMemModelVoc;
    Model inMemModelVocSchema;
    InfModel infmodel;
    RdfDBAccess conn;
    VocQueries vQuery;
    Vocabulary voc;
    String vocsNS;
    String acmNS;
    Property propSelect;
    public static String VOCNAME = "acmccs98";

    public VocUtils(RdfDBAccess conn, boolean loadInMem) {
        this.conn = conn;
        modelVoc = conn.getModel("vocabularies");
        modelVocSchema = conn.getModel("vocabulariesSchema");
        if (loadInMem) {
            ModelMaker mm = ModelFactory.createMemModelMaker();
            inMemModelVoc = mm.createModel("vocabularies");
            inMemModelVoc.add(modelVoc);
            inMemModelVoc.setNsPrefixes(modelVoc.getNsPrefixMap());
            inMemModelVocSchema = mm.createModel("vocabulariesSchema");
            inMemModelVocSchema.add(modelVocSchema);
            inMemModelVocSchema.setNsPrefixes(modelVocSchema.getNsPrefixMap());
            infmodel = ModelFactory.createRDFSModel(inMemModelVocSchema, inMemModelVoc);
        } else {
            infmodel = ModelFactory.createRDFSModel(modelVocSchema, modelVoc);
        }
        vQuery = new VocQueries();
        voc = new Vocabulary(VOCNAME, conn);
        vocsNS = infmodel.getNsPrefixURI("vocs");
        propSelect = property("selectivite");
        acmNS = infmodel.getNsPrefixURI(VOCNAME);
    }

    public Property property(String local) {
        return ResourceFactory.createProperty(vocsNS, local);
    }

    /**
     * Retourne vrai si le terme1 subsumes le terme2
     * @param termCode1
     * @param termCode2
     * @return
     */
    public boolean subsumes(String termCode1, String termCode2) {
        Resource r1 = infmodel.getResource(acmNS + termCode1);
        Resource r2 = infmodel.getResource(acmNS + termCode2);
        return (infmodel.listStatements(r2, RDFS.subClassOf, r1).hasNext());
    }

    /**
     * @deprecated 
     * @param term
     * @return
     */
    public String getCodeByLabel(String term) {
        VocQueries vocQ = new VocQueries();
        String termCode = "";
        ResultSet result = this.conn.execSelectQuery(vocQ.getTermByLabel(voc, term), vocQ.getModel());
        QuerySolution rb;
        while (result.hasNext()) {
            rb = result.nextSolution();
            String tab[] = rb.get("term").toString().split("/|#");
            termCode = tab[tab.length - 1];
        }
        return termCode;
    }

    public String getLabelByCode(String code) {
        return this.getLabelByUrl(acmNS + code);
    }

    public String getLabelByUrl(String termURL) {
        Resource r1 = infmodel.getResource(termURL);
        Statement stmtTest = infmodel.getProperty(r1, RDFS.label);
        return stmtTest.getObject().toString();
    }

    public String getCodeByUrl(String termURL) {
        String code = termURL.split("#")[1];
        return code;
    }

    /**
     * Renvoie le lub de deux termes
     * @param termCode1
     * @param termCode2
     * @return
     */
    public String miniLub(String termCode1, String termCode2) {
        String res = "";

        if (this.subsumes(termCode1, termCode2)) {
            return termCode1;
        }
        if (this.subsumes(termCode2, termCode1)) {
            return termCode2;
        }

        ArrayList<String> p1 = getParents(termCode1);
        ArrayList<String> p2 = getParents(termCode2);
        ArrayList<String> common = new ArrayList<String>();

        for (Iterator i = p1.iterator(); i.hasNext();) {
            String parent = (String) i.next();
            for (Iterator i2 = p2.iterator(); i2.hasNext();) {
                String parent2 = (String) i2.next();
                if (parent2.equals(parent)) {
                    common.add(parent);
                }
            }
        }

        // Il faut maintenant chercher le parent commun le plus spécifique
        // -> celui qui a le moins de fils
        if (common.size() > 0) {
            res = common.get(0);
            int min = this.getNbFils(res);

            for (Iterator i = common.iterator(); i.hasNext();) {
                String parent = (String) i.next();
                int nbFils = this.getNbFils(parent);
                if (nbFils < min) {
                    min = nbFils;
                    res = parent;
                }
            }
        }

        //res = this.getLabelByUrl(res);
        res = this.getCodeByUrl(res);
        //System.out.println("minilub(" + term1 + "," + term2 + ") : " + res);
        return res;
    }

    /**
     * Retourne tous les parents d'un terme
     * @param termCode
     * @return
     */
    public ArrayList<String> getParents(String termCode) {
        ArrayList<String> l = new ArrayList<String>();
        String termURL = acmNS + termCode;
        Resource r1 = infmodel.getResource(termURL);
        Resource r = null;
        for (StmtIterator i = infmodel.listStatements(r1, RDFS.subClassOf, r); i.hasNext();) {
            Statement stmt = i.nextStatement();
            String parent = PrintUtil.print(stmt.getObject());
            // On ne prend pas le terme lui-même
            if (!parent.equals(termURL)) {
                if (!parent.equals("rdfs:Resource")) {
                    l.add(parent);
                }
            }
        }
        return l;
    }

    /**
     * Retourne le nombre de fils d'un terme
     * @param termURL
     * @return
     */
    public int getNbFils(String termURL) {
        Resource r1 = infmodel.getResource(termURL);
        Resource r = null;
        return infmodel.listStatements(r, RDFS.subClassOf, r1).toList().size() - 1;
    }

    /**
     * Calcule la selectivite de chaque termes.
     * Ne le lancer qu'une seule fois à l'installation de digilib !
     */
    public void calcAllSelectivities() {
        System.out.println("calcAllSelectivities...");
        int[] nbTermes = new int[1];
        nbTermes[0] = 0;
        // On récupère le nombre de termes et on initialise à 0 leur selectivité
        nbTermes[0] = getNbTermes2();
        // Calcule et assigne la selectivité de chaque terme
        calcSelect(VOCNAME, nbTermes[0]);
    }

    /**
     * Fonction récursive du calcul de la selectivite
     * @param termCode
     * @param nbTermes
     * @return
     */
    public double calcSelect(String termCode, int nbTermes) {
       double somme = 0;
        ResIterator rsi = infmodel.listSubjectsWithProperty(ReasonerVocabulary.directSubClassOf, infmodel.getResource(acmNS + termCode));
        while (rsi.hasNext()) {
            Resource res = rsi.nextResource();
            if (!res.getURI().equals(acmNS + termCode)) {
                String succCode = res.getURI().split("#")[1];
                somme += calcSelect(succCode, nbTermes);
            }
        }
        somme += (1.0 / nbTermes);

        if (!termCode.equals(VOCNAME)) {
            String url = acmNS + termCode;
            setSelectivite(url, somme);
        }
        return somme;

    }

    /**
     * Fonction d'affichage du vocabulaire
     * @param termCode
     */
    public void parcoursTerms(String termCode) {
        ResultSet result = conn.execSelectQuery(vQuery.getTermSuccessors(voc, termCode), vQuery.getModel());
        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            String url = rb.get("succ").toString();
            String code = url.split("#")[1];
            String term = rb.get("label").toString();
            int nbFils = getNbFils(url);
            System.out.println("--------");
            System.out.println(url);
            System.out.println(term + " " + code);
            System.out.println("NbFils : " + nbFils);
            System.out.println("select : " + getSelectiviteFromURI(url));
            System.out.println("--------");
            parcoursTerms(code);
        }
    }

    public void getNbTermes(String termCode, int[] nb) {
        System.out.println("getNbTermes(" + termCode + " , " + nb[0] + ")");
        ResultSet result = conn.execSelectQuery(vQuery.getTermSuccessors(voc, termCode), vQuery.getModel());
        while (result.hasNext()) {
            nb[0]++;
            QuerySolution rb = result.nextSolution();
            String url = rb.get("succ").toString();
            String code = url.split("#")[1];
            // Initialisation de la selectivite à 0
            setSelectivite(url, 0);
            getNbTermes(code, nb);
        }
    }

    /**
     * Retourne le nombre de termes de l'arbre
     * @return
     */
    public int getNbTermes2() {
        Resource r = null;
        String s = null;
        int nb = 0;
        for (StmtIterator i = infmodel.listStatements(r, RDFS.label, s); i.hasNext();) {
            Statement stmt = i.nextStatement();
            String subject = stmt.getSubject().toString();
            String ns = subject.split("#")[0];
            if (ns.equals(acmNS.substring(0, acmNS.length() - 1))) {
                //System.out.println(subject + "\t" + nb);
                nb++;
            }
        }
        return nb - 1;
    }

    /**
     * Alloue une valeur de selectivite à un terme
     * @param termURL
     * @param selectivite
     */
    public void setSelectivite(String termURL, double selectivite) {
        Resource r = modelVoc.getResource(termURL);
        r.removeAll(propSelect);
        r.addProperty(propSelect, "" + selectivite);
    }

    public double getSelectiviteFromURI(String termURL) {
        //System.out.print("getSelectiviteFromURI(" + termURL + ") = ");
        double select = 0;
        Resource r = infmodel.getResource(termURL);
        select = Double.parseDouble(r.getProperty(propSelect).getObject().toString());
        //System.out.println(select);
        return select;
    }

    public double getSelectiviteFromCode(String termCode) {
        return this.getSelectiviteFromURI(acmNS + termCode);
    }
}
