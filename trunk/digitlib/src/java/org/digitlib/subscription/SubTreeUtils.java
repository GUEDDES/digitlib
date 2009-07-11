/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.digitlib.subscription;

import org.digitlib.db.RdfDBAccess;
import java.util.*;
import com.hp.hpl.jena.db.*;
import com.hp.hpl.jena.rdf.model.*;
import com.hp.hpl.jena.rdf.model.impl.SeqImpl;
import com.hp.hpl.jena.sparql.util.Base64.InputStream;
import com.hp.hpl.jena.sparql.util.Base64.OutputStream;
import com.hp.hpl.jena.vocabulary.RDFS;
import com.hp.hpl.jena.vocabulary.ReasonerVocabulary;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;

/**
 *
 * @author Steff
 */
public class SubTreeUtils {

    ModelRDB modelSubTree;
    ModelRDB modelSubTreeSchema;
    Model inMemModelSubTree;
    Model inMemModelSubTreeSchema;
    InfModel infmodel;
    RdfDBAccess conn;
    String subRdf;
    String subRdfs;
    VocUtils vocUtils;
    String racineURI;

    /**
     * Builds the Tree of subscriptions from the DataBase
     * @param conn
     */
    public SubTreeUtils(RdfDBAccess conn) {
        this.conn = conn;
        vocUtils = new VocUtils(conn, true);
        modelSubTree = conn.getModel("subsTree");
        modelSubTreeSchema = conn.getModel("subsTreeSchema");
        infmodel = ModelFactory.createRDFSModel(modelSubTreeSchema, modelSubTree);
        subRdf = infmodel.getNsPrefixURI("sub");
        subRdfs = infmodel.getNsPrefixURI("subs");
        racineURI = subRdf + "subs";
    }

    /**
     * Builds the Tree of subscriptions from the DataBase
     * Allows to construct the tree with the option of loading it in memory
     * @param conn
     * @param loadInMem
     */
    public SubTreeUtils(RdfDBAccess conn, boolean loadInMem) {
        this.conn = conn;
        vocUtils = new VocUtils(conn, true);
        modelSubTree = conn.getModel("subsTree");
        modelSubTreeSchema = conn.getModel("subsTreeSchema");
        if (loadInMem) {
            ModelMaker mm = ModelFactory.createMemModelMaker();
            inMemModelSubTree = mm.createModel("subsTree");
            inMemModelSubTree.add(modelSubTree);
            inMemModelSubTree.setNsPrefixes(modelSubTree.getNsPrefixMap());
            inMemModelSubTreeSchema = mm.createModel("subsTreeSchema");
            inMemModelSubTreeSchema.add(modelSubTreeSchema);
            inMemModelSubTreeSchema.setNsPrefixes(modelSubTreeSchema.getNsPrefixMap());
            infmodel = ModelFactory.createRDFSModel(inMemModelSubTreeSchema, inMemModelSubTree);
        } else {
            infmodel = ModelFactory.createRDFSModel(modelSubTreeSchema, modelSubTree);
        }
        subRdf = infmodel.getNsPrefixURI("sub");
        subRdfs = infmodel.getNsPrefixURI("subs");
        racineURI = subRdf + "subs";
    }

    /**
     * Return all the Subs URI from one node of the tree
     * @param nodeURI
     * @return The URIs of all the subscriptions associated to this node
     */
    public Vector<String> getSubsFromNode(String nodeURI) {
        Vector<String> vectSubs = new Vector<String>();
        Statement stmt = infmodel.getProperty(infmodel.getResource(nodeURI), infmodel.getProperty(subRdfs + "usersubs"));
        Seq s = stmt.getSeq();
        NodeIterator ni = s.iterator();
        while (ni.hasNext()) {
            vectSubs.add(ni.nextNode().toString());
        }
        return vectSubs;
    }

    /**
     * Remove the subscription from this node
     * @param subs
     * @param rsce
     */
    public void removeSubFromNode(String subsURL, String rsceURL) {
        Resource rsce = infmodel.getResource(rsceURL);
        Property prp = infmodel.getProperty(subRdfs + "usersubs");
        Statement stmt = infmodel.getProperty(rsce, prp);
        Seq s = stmt.getSeq();
        NodeIterator ni = s.iterator();
        int i = 0;
        while (ni.hasNext()) {
            RDFNode rdfn = ni.nextNode();
            i++;
            if (rdfn.toString().equals(subsURL)) {
                s.remove(i);
                return;
            }
        }
    }

    /**
     * Add the given sub to this node of the tree
     * @param subs
     * @param rsce
     */
    public void addSubToNode(Subscription subs, Resource rsce) {
        Property prp = infmodel.getProperty(subRdfs + "usersubs");
        Statement stmt = infmodel.getProperty(rsce, prp);
        stmt.getSeq().add(subs.getUrl());
    }

    /**
     * 
     * @param rsc
     * @return The URIs of all the terms associated to this node
     */
    public Vector<String> getTermUrisFromNode(String nodeURI) {
        Vector<String> vect = new Vector<String>();
        Statement stmt = infmodel.getProperty(infmodel.getResource(nodeURI), infmodel.getProperty(subRdfs + "content"));
        Seq s = stmt.getSeq();
        NodeIterator ni = s.iterator();
        while (ni.hasNext()) {
            vect.add(ni.nextNode().toString());
        }
        return vect;
    }

    /**
     * Remove the terms from a node of the Tree
     * @param termURI
     * @param rsce
     */
    public void removeTermFromNode(String termURI, Resource rsce) {
        Property prp = infmodel.getProperty(subRdfs + "content");
        Statement stmt = infmodel.getProperty(rsce, prp);
        Seq s = stmt.getSeq();
        NodeIterator ni = s.iterator();
        int i = 0;
        while (ni.hasNext()) {
            RDFNode rdfn = ni.nextNode();
            i++;
            if (rdfn.toString().equals(termURI)) {
                s.remove(i);
                return;
            }
        }
    }

    /**
     * Add a term to the Sequence in a node of the Tree
     * @param termURI
     * @param rsce
     */
    public void addTermToNode(String termURI, Resource rsce) {
        Property prp = infmodel.getProperty(subRdfs + "content");
        Statement stmt = infmodel.getProperty(rsce, prp);
        stmt.getSeq().add(termURI);
    }

    /**
     * @param nodeURI
     * @return The URIs of all the subscriptions associated to this node
     */
    public ArrayList<String> getTermLabelsFromNode(String nodeURI) {
        ArrayList<String> list = new ArrayList<String>();
        Statement stmt = infmodel.getProperty(infmodel.getResource(nodeURI), infmodel.getProperty(subRdfs + "content"));
        Seq s = stmt.getSeq();
        NodeIterator ni = s.iterator();
        while (ni.hasNext()) {
            list.add(vocUtils.getLabelByUrl(ni.nextNode().toString()));
        }
        return list;
    }

    public ArrayList<String> getTermCodesFromNode(String nodeURI) {
        ArrayList<String> list = new ArrayList<String>();
        Statement stmt = infmodel.getProperty(infmodel.getResource(nodeURI), infmodel.getProperty(subRdfs + "content"));
        Seq s = stmt.getSeq();
        NodeIterator ni = s.iterator();
        while (ni.hasNext()) {
            String uri = ni.nextNode().toString();
            list.add(vocUtils.getCodeByUrl(uri));
        }
        return list;
    }

    /**
     * Return the URI of the node the subscription s was linked to
     * @param sub
     * @return
     */
    public String getNodeURI(String subsURL) {
        //Instancie le modele
        ModelRDB modelSub = conn.getModel("subscriptions");
        ModelRDB modelSubSchema = conn.getModel("subscriptionsSchema");
        InfModel subModel = ModelFactory.createRDFSModel(modelSubSchema, modelSub);
        String subsRdfs = subModel.getNsPrefixURI("subscrip");
        Resource subRsc = subModel.getResource(subsURL);
        //Va chercher le triplet pour la propriete 'content' sur cette subscription
        Statement contentStmt = subModel.getProperty(subRsc, subModel.getProperty(subsRdfs + "content"));
        //Recupere l'objet du statement
        RDFNode node = contentStmt.getObject();
        //Renvoie l'url de cet objet
        return node.toString();
    }

    /**
     * Return the (one) node of the Tree that has this subscription's content
     * as content. Return null if not found
     * Warning : very expensive function since it has to get throug all
     * the nodes to make sure the content isn't already used.
     * @param subs
     * @return
     */
    public String getSubsContentUrl(Subscription subs) {
        String nodeURI = null;
        //Recupere tous les contents actuellements reserves
        HashMap<Resource, Seq> mrs = new HashMap<Resource, Seq>();
        this.getAllContents(mrs, this.racineURI);
        //Recupere la liste de 'content' de la subs
        List<String> content = subs.getResAttrib().get("content");
        //Parcours la liste de Seq
        Iterator itRes = mrs.keySet().iterator();
        while (itRes.hasNext()) {
            Resource r = (Resource) itRes.next();
            Seq s = mrs.get(r);
            Vector<String> vs = new Vector<String>();
            NodeIterator ni = s.iterator();
            while (ni.hasNext()) {
                vs.add(ni.nextNode().toString().split("#")[1]);
            }
            if (sameContent(content, vs)) {
                nodeURI = r.getURI();
                return nodeURI;
            }
        }
        return nodeURI;
    }

    /**
     * Returns all the contents in the tree
     * @param vvs
     * @param nodeURI
     */
    public void getAllContents(HashMap<Resource, Seq> mrs, String nodeURI) {
        if (mrs == null) {
            mrs = new HashMap<Resource, Seq>();
        }
        //Partie principale
        Resource rsce = infmodel.getResource(nodeURI);
        Property prp = infmodel.getProperty(subRdfs + "content");
        Statement stmt = infmodel.getProperty(rsce, prp);
        Seq s = stmt.getSeq();
        mrs.put(rsce, s);
        //Recursivite
        ArrayList<String> childrens = getChildrens(nodeURI);
        for (Iterator i = childrens.iterator(); i.hasNext();) {
            String childURI = (String) i.next();
            getAllContents(mrs, childURI);
        }
    }

    /**
     * Intern Class for intern usage...
     */
    public class Blob {

        public String nodeURI;
        public ArrayList<String> lub;

        public Blob(String nodeURI, ArrayList<String> lub) {
            this.nodeURI = nodeURI;
            this.lub = lub;
        }
    }

    /**
     * Insert the sub s given in parameter inside the tree
     * @param s
     * @param login
     * @return
     */
    public String insertSubsInTree(Subscription s, String login) {
        ArrayList<String> listeCodes = SubsUtils.getTermCodes(s, vocUtils);
        String uriNode = "";
        SubTreeUtils subMem = new SubTreeUtils(conn, true);
        // Premiere etape : chercher le parent candidat suivant un parcours en profondeur
        String parent = subMem.getCandidateParent(s);
        ArrayList<String> parentTermCodes = subMem.getTermCodesFromNode(parent);
        // Deuxieme étape : chercher les lubs candidats
        Vector<Blob> vect = new Vector<Blob>();
        // Pour chaque fils de parent
        for (Iterator i = subMem.getChildrens(parent).iterator(); i.hasNext();) {
            String child = (String) i.next();
            ArrayList<String> childTermCodes = subMem.getTermCodesFromNode(child);
            ArrayList<String> termScodes = SubsUtils.getTermCodes(s, vocUtils);
            ArrayList<String> lub = SubsUtils.lub(termScodes, childTermCodes, vocUtils);
            // Si on a un lub != de parent...
            if (lub.size() > 0 && !sameContent(parentTermCodes, lub)) {
                vect.add(new Blob(child, lub));
            }
        }
        // Pas de lub candidat
        if (vect.size() == 0) {
            // Si le parent a le meme content 
            if (this.sameContent(SubsUtils.getTermCodes(s, vocUtils), parentTermCodes)) {
                this.addSubToNode(s, infmodel.getResource(parent));
                uriNode = parent;
            } else {
                // Pas de lub candidat, s est un fils de parent
                uriNode = this.addNode(listeCodes, login, parent);
                this.addSubToNode(s, infmodel.getResource(uriNode));
            }
        } // Un lub candidat est trouvé
        else {
            ArrayList<String> termScodes = SubsUtils.getTermCodes(s, vocUtils);
            // Insérer le lub des 2 souscriptions
            // Choisit un noeud N tel que LUB(N,s) est le plus sélectif
            Blob selectiveBlob = subMem.getMostSelectiveBlob(vect);

            // Si le lub a le même content que la suscription, on ne le crée pas
            if (this.sameContent(selectiveBlob.lub, termScodes)) {
                String subURI = this.addNode(termScodes, login, parent);
                this.setParent(subURI, selectiveBlob.nodeURI);
                this.addSubToNode(s, infmodel.getResource(subURI));
                uriNode = subURI;
            } else {
                // Ajoute le noeud artificiel dans l'arbre
                String lubURI = this.addNode(selectiveBlob.lub, login, parent);
                this.setParent(lubURI, selectiveBlob.nodeURI);
                String subURI = this.addNode(termScodes, login, lubURI);
                this.addSubToNode(s, infmodel.getResource(subURI));
                uriNode = subURI;
            }
        }
        //Return the URI of the node the subscription was added to
        return uriNode;
    }

    /**
     * Ajoute un noeud dans l'arbre dont l'uri va être générée avec un user
     * retourne l'uri générée (base + user + date_system)
     * Ce noeud ne contient pas de réelles subscriptions au départ.
     * @param content
     * @param user
     * @return
     **/
    public String addNode(ArrayList<String> contentCodes, String user, String parent) {
        // Premiere étape, création de l'uri
        Calendar cal = Calendar.getInstance();
        String uriSub = subRdf + user + "_" + cal.getTimeInMillis();
        // Deuxieme étape, ajouter la ressource dans le modele
        Resource node = infmodel.createResource(uriSub);
        node.addProperty(RDFS.subClassOf, infmodel.getResource(parent));
        //Terms
        SeqImpl seqTerms = new SeqImpl(modelSubTree);
        for (Iterator i = contentCodes.iterator(); i.hasNext();) {
            String str = (String) i.next();
            seqTerms.add(vocUtils.acmNS + str);
        }
        node.addProperty(infmodel.getProperty(subRdfs + "content"), seqTerms);
        //Subscriptions
        SeqImpl seqSubs = new SeqImpl(modelSubTree);
        node.addProperty(infmodel.getProperty(subRdfs + "usersubs"), seqSubs);
        return uriSub;
    }

    /**
     * Delete a node frome the tree
     * @param nodeURI
     */
    public void deleteNode(String nodeURI) {
        Resource remi = infmodel.getResource(nodeURI);
        Resource parent = infmodel.getProperty(remi, RDFS.subClassOf).getResource();
        ResIterator fils = infmodel.listResourcesWithProperty(ReasonerVocabulary.directSubClassOf, remi);
        while (fils.hasNext()) {
            Resource unFils = fils.nextResource();
            unFils.removeAll(RDFS.subClassOf);
            //The node itself appears among the sons
            if (!unFils.getURI().equals(remi.getURI())) {
                unFils.addProperty(RDFS.subClassOf, parent);
            }
        }
    }

    /**
     * retourne l'uri du parent candidat
     * @param s
     * @return
     */
    public String getCandidateParent(Subscription s) {
        Vector<String> vect = new Vector<String>();
        vect.add(racineURI);
        this.recurGetCandidateParent(racineURI, s, vect);
        return (vect.elementAt(0));
    }

    /**
     * Fonction récursive de la recherche du cadidat parent
     * @param nodeURI
     * @param s
     * @param vect
     */
    private void recurGetCandidateParent(String nodeURI, Subscription s, Vector<String> vect) {
        // Si le noeud est un parent candidant
        if (this.isCandidateParent(nodeURI, s)) {
            vect.removeAllElements();
            vect.add(nodeURI);
        } // Sinon on parcours en profondeur sur le fils le plus sélectif
        else {
            String selectiveChild = this.getMostSelectiveChild(nodeURI, s);
            this.recurGetCandidateParent(selectiveChild, s, vect);
        }
    }

    /**
     * Renvoie vrai si le noeud est nodeURI un parent candidat pour la subscription s
     * Renvoie vrai si S rafine nodeURI et ne raffine aucun fils du noeud nodeURI
     * Renvoie vrai si nodeURI n'a aucun fils aussi
     * @param nodeURI
     * @param s
     * @return
     */
    public boolean isCandidateParent(String nodeURI, Subscription s) {
        ArrayList<String> termScodes = SubsUtils.getTermCodes(s, vocUtils);
        ArrayList<String> termNodeCodes = this.getTermCodesFromNode(nodeURI);

        // Si S raffine le noeud
        if (SubsUtils.refine2(termScodes, termNodeCodes, vocUtils)) {
            //System.out.println("condition 1 ok");
            boolean ok = true;
            ArrayList<String> childrens = getChildrens(nodeURI);
            Iterator it = childrens.iterator();
            while (it.hasNext() && ok) {
                // Si on trouve un fils qui est raffiné par S
                String childURI = (String) it.next();
                ArrayList<String> termChildCodes = this.getTermCodesFromNode(childURI);
                if (SubsUtils.refine2(termScodes, termChildCodes, vocUtils)) {
                    ok = false;
                }
            }
            return ok;
        } else {
            return false;
        }
    }

    /**
     * Retourne le blob dont le lub est le plus sélectif
     * @param vect : vecteur de blobs
     * @return
     */
    public Blob getMostSelectiveBlob(Vector<Blob> vect) {
        Blob bestBlob = vect.elementAt(0);
        double min = this.getTauxFiltrage(bestBlob);
        for (Iterator i = vect.iterator(); i.hasNext();) {
            Blob b = (Blob) i.next();
            double val = this.getTauxFiltrage(b);
            if (val < min) {
                min = val;
                bestBlob = b;
            }
        }
        return bestBlob;
    }

    /**
     * Retourne l'URI du fils le plus sélectif et qui est raffiné par S
     * @param nodeURI
     * @param s
     * @return
     */
    public String getMostSelectiveChild(String nodeURI, Subscription s) {
        ArrayList<String> childrens = getChildrens(nodeURI);

        // Récupere les fils raffinés par S
        ArrayList<String> childrensRefine = new ArrayList<String>();
        for (Iterator i = childrens.iterator(); i.hasNext();) {
            String child = (String) i.next();
            ArrayList<String> termChildCodes = this.getTermCodesFromNode(child);
            ArrayList<String> termScodes = SubsUtils.getTermCodes(s, vocUtils);
            if (SubsUtils.refine2(termScodes, termChildCodes, vocUtils)) {
                childrensRefine.add(child);
            }
        }

        // Parmi les fils raffinés, on prend le plus selectif donc celui qui a
        // le plus petit taux de filtrage
        String best = "";
        if (childrensRefine.size() > 0) {
            double min = this.getTauxFiltrage(childrensRefine.get(0));
            best = childrensRefine.get(0);
            for (Iterator i = childrensRefine.iterator(); i.hasNext();) {
                String child = (String) i.next();
                double taux = this.getTauxFiltrage(child);
                if (taux < min) {
                    min = taux;
                    best = child;
                }
            }
        }
        return best;
    }

    /**
     * Définit nodeURI1 comme le parent de nodeURI2
     * Donc nodeURI2 devient sousclasse de nodeURI1
     * @param nodeURI1
     * @param nodeURI2
     */
    public void setParent(String nodeURI1, String nodeURI2) {
        Resource r = infmodel.getResource(nodeURI2);
        r.removeAll(RDFS.subClassOf);
        r.addProperty(RDFS.subClassOf, infmodel.getResource(nodeURI1));
    }

    /**
     * Retourne vrai si les termes de l1 sont les mêmes que l2
     * @param l1
     * @param l2
     * @return
     */
    public boolean sameContent(List<String> l1, List<String> l2) {
        Collections.sort(l1, String.CASE_INSENSITIVE_ORDER);
        Collections.sort(l2, String.CASE_INSENSITIVE_ORDER);
        return (l1.equals(l2));
    }

    /**
     * Renvoie le taux de filtrage du noeud
     * @param nodeURI
     * @return
     */
    public double getTauxFiltrage(String nodeURI) {
        double prod = 1;
        Vector<String> termeURIs = this.getTermUrisFromNode(nodeURI);
        for (Iterator i = termeURIs.iterator(); i.hasNext();) {
            String termeURI = (String) i.next();
            prod *= vocUtils.getSelectiviteFromURI(termeURI);
        }
        return prod;
    }

    public double getTauxFiltrage(Blob blob) {
        double prod = 1;
        for (Iterator i = blob.lub.iterator(); i.hasNext();) {
            String termLabel = (String) i.next();
            prod *= vocUtils.getSelectiviteFromCode(termLabel);
        }
        return prod;
    }

    /**
     * Retrourne la liste des fils directs du noeud nodeURI dans substree
     */
    public ArrayList<String> getChildrens(String nodeURI) {
        ArrayList list = new ArrayList<String>();
        Resource node = infmodel.getResource(nodeURI);
        Resource r = null;
        for (StmtIterator i = infmodel.listStatements(r, ReasonerVocabulary.directSubClassOf, node); i.hasNext();) {
            Statement stmt = i.nextStatement();
            String uri = stmt.getSubject().toString();
            if (!nodeURI.equals(uri)) {
                list.add(uri);
            }
        }
        return list;
    }

    /**
     * Fonction d'affichage de l'arbre des subscriptions
     */
    public void printTheTree() {
        System.out.println("Contenu de l'abre des subscriptions : ");
        recurPrintTheTree(racineURI, racineURI);
    }

    /**
     * Parcours l'arbre en profondeur (utilisé par printTheTree)
     */
    private void recurPrintTheTree(String nodeURI, String parentURI) {

        String parent[] = parentURI.split("#");
        System.out.println(parent[1] + " -->");
        String node[] = nodeURI.split("#");
        System.out.println("\t" + node[1] + " {");
        System.out.print("\t\tContent :");
        for (Iterator i = this.getTermCodesFromNode(nodeURI).iterator(); i.hasNext();) {
            String code = (String) i.next();
            String label = vocUtils.getLabelByCode(code);
            System.out.print(" " + label + "(" + code + ")");
        }
        System.out.println();
        System.out.println("\t\tSubs :");
        for (Iterator i = this.getSubsFromNode(nodeURI).iterator(); i.hasNext();) {
            String subURI = (String) i.next();
            String sub[] = subURI.split("#");
            System.out.print("\t\t\t- " + sub[1] + " : ");
            Subscription s = new Subscription(subURI, conn);
            for (Iterator it = s.getSubmitter().iterator(); it.hasNext();) {
                System.out.print(it.next() + " ");
            }
            System.out.println();
        }
        System.out.println("\t}");

        ArrayList<String> childrens = getChildrens(nodeURI);
        for (Iterator i = childrens.iterator(); i.hasNext();) {
            String childURI = (String) i.next();
            recurPrintTheTree(childURI, nodeURI);
        }
    }

    /**
     * Renvoie les uris des subscriptions qui matchent le content (algo CMatch)
     * @param content
     * @return
     */
    public ArrayList<String> getSubsURImatch(List<String> contentCodes) {
        ArrayList<String> listeURIs = new ArrayList<String>();
        this.recurGetSubsURImatch(racineURI, contentCodes, listeURIs);
        return listeURIs;
    }

    public void recurGetSubsURImatch(String nodeURI, List<String> contentCodes, ArrayList<String> listeURIs) {
        ArrayList<String> termCodes = this.getTermCodesFromNode(nodeURI);
        // Si le content raffine le noeud, alors on peut continuer
        if (SubsUtils.refine2(contentCodes, termCodes, vocUtils)) {
            // On ajoute les subscriptions du noeud en cours
            for (Iterator i = this.getSubsFromNode(nodeURI).iterator(); i.hasNext();) {
                listeURIs.add((String) i.next());
            }
            // Appel sur les fils...
            ArrayList<String> childrens = getChildrens(nodeURI);
            for (Iterator i = childrens.iterator(); i.hasNext();) {
                String childURI = (String) i.next();
                recurGetSubsURImatch(childURI, contentCodes, listeURIs);
            }
        }
    }

    /**
     * Writes the model loaded in memory as an RDF/XML serialized document
     * @param fileName
     * @throws java.io.FileNotFoundException
     */
    public void saveToFile(String fileName) throws FileNotFoundException {
        File outFile = new File(fileName);
        OutputStream dos = new OutputStream(new FileOutputStream(outFile, true));
        this.infmodel.write(dos, "RDF/XML");
        System.out.println(outFile.getAbsolutePath());
    }

    /**
     * Reads (load) the model in memory
     * @param fileName
     * @throws java.io.FileNotFoundException
     */
    public void readFromFile(String fileName) throws FileNotFoundException {
        File inFile = new File(fileName);
        InputStream is = new InputStream(new FileInputStream(inFile));
        this.infmodel.read(is, "", "RDF/XML");
        System.out.println(inFile.getAbsolutePath());
    }
}
