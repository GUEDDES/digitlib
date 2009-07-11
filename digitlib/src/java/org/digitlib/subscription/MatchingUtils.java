package org.digitlib.subscription;

import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import java.util.*;
import java.util.Vector;
import org.digitlib.db.RdfDBAccess;
import org.digitlib.resource.Resource;

public class MatchingUtils {

    RdfDBAccess conn;
    List<String> notifattr;
    VocUtils vocUtils;
    public boolean naiveMode = false;

    public MatchingUtils(RdfDBAccess conn, List<String> notifattr, VocUtils vocUtils) {
        this.conn = conn;
        this.notifattr = notifattr;
        this.vocUtils = vocUtils;
    }

    /**
     *
     * @param resource
     * @return The vector of matching subscription for the Resource given in parameter
     */
    public Vector<Subscription> getSubscriptionsConcerned(Resource resource) {
        Vector<Subscription> vectSubs = new Vector<Subscription>();

        double timeDepart = new Date().getTime();
        if (naiveMode) {
            /**
             * Naive method
             */
            Iterator it = this.getAllSubscriptions().iterator();
            // Loop into all subscriptions
            while (it.hasNext()) {
                Subscription subs = new Subscription((String) it.next(), conn, Locale.ENGLISH);
                // System.out.println("Subscription from " + subs.getSubmitter().getLogin());
                if (matches(subs, resource)) {
                    System.out.println("Ajoute " + subs.getUrl() + " a la liste des subs matchantes");
                    vectSubs.add(subs);
                }
            }
        } else {
            /**
             * SubTree method
             */
            // 1ere etape, on parcours l'arbre des subscriptions en partant de la racine
            SubTreeUtils subTreeUtils = new SubTreeUtils(conn, true);
            ArrayList<String> liste = subTreeUtils.getSubsURImatch(resource.getContent());

            // 2eme etape, a partir de la liste obtenue, on doit verifier les autres parametres
            for (Iterator i = liste.iterator(); i.hasNext();) {
                String uri = (String) i.next();
                // Construit la subscription a partir de l'uri
                Subscription sub = new Subscription(uri, conn);
                //Get the notification attributes (Config parameters)
                Map<String, List<String>> subAttrib = sub.getResAttrib();
                boolean ok = true;
                Iterator itNotifAttr = notifattr.iterator();
                while (itNotifAttr.hasNext() && ok) {
                    String elt = (String) itNotifAttr.next();
                    //Special attribute : content
                    if (!elt.equals("content")) {
                        //For other attributes, such as Author, Language etc...
                        List<String> subsAttrib = (List<String>) subAttrib.get(elt);
                        System.out.println("Pour l'element " + elt);
                        if (!matchingContent(subsAttrib, resource.getResAttrib().get(elt))) {
                            System.out.println(elt + " specified different --> Out");
                            ok = false;
                        }
                    }
                }
                if (ok) {
                    vectSubs.add(sub);
                }
            }
        }
        System.out.println("Temps de calcul (ms) : " + (new Date().getTime() - timeDepart));
        return vectSubs;
    }

    public boolean matches(Subscription subs, Resource resource) {
        //Get the subscription resource's attributes
        Map<String, List<String>> subAttrib = subs.getResAttrib();
        //Get the content for this subscription
        SubTreeUtils subtu = new SubTreeUtils(conn);
        String nodeURI = subtu.getNodeURI(subs.getUrl());
        List<String> subContent = subtu.getTermCodesFromNode(nodeURI);
        //Checks all the notification attributes one by one
        Iterator itNotifAttr = notifattr.iterator();
        while (itNotifAttr.hasNext()) {
            String elt = (String) itNotifAttr.next();
            //Special attribute : content
            if (elt.equals("content")) {
                if (!matchingTerms(subContent, resource)) {
                    return false;
                }
            } else {
                //For other attributes, such as Author, Language etc...
                List<String> subsAttrib = (List<String>) subAttrib.get(elt);
                //System.out.println("Pour l'element " + elt);
                if (!matchingContent(subsAttrib, resource.getResAttrib().get(elt))) {
                    System.out.println(elt + " specified different --> Out");
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Compares the terms describing the resource and the subscription to
     * find matching terms, i.e that are equals or subsumed by
     * @param sub the subscription to compare
     * @param resource the resource to be compared to
     * @return wether the terms are matching the ones from the subscription
     * or not
     */
    public boolean matchingTerms(List<String> subTermCodes, Resource resource) {
        boolean test = false;
        //If there is terms describing the subscription
        if (!subTermCodes.isEmpty()) {
            Iterator subSTerms = subTermCodes.iterator();
            //For each term describing the subscription, look for the term in the
            //description of the resource that are subsumed by this term.
            while (subSTerms.hasNext()) {
                String subTermCode = (String) subSTerms.next();
                System.out.println("subTermCode : " + subTermCode);
                Iterator itResource = resource.getContent().iterator();
                while (itResource.hasNext()) {
                    String resTermCode = (String) itResource.next();
                    System.out.print("\tresTermCode : " + resTermCode);
                    if (vocUtils.subsumes(subTermCode, resTermCode)) {
                        test = true;
                        System.out.println(" (subsumed)");
                        break;
                    } else {
                        test = false;
                        System.out.println(" (not subsumed)");
                    }
                }
                //If for this Sub's Term, there is no term subsumed, the
                //resource is not corresponding
                if (!test) {
                    return test;
                }
            }
        } //Otherwise, it's automatically correct
        else {
            test = true;
        }
        return test;
    }

    /**
     * Compares the rest of the subscription/resource content to find
     * matching ones
     * @param sub
     * @param res
     * @return
     */
    public boolean matchingContent(List<String> sub, String res) {
        boolean test = false;
        //If the list is not empty
        if (!sub.isEmpty()) {
            Iterator itSub = sub.iterator();
            while (itSub.hasNext() && !test) {
                String element = (String) itSub.next();
                if (element.equals("")) {
                    test = true;
                } else {
                    //Separate the different element for an author/language/etc...
                    String[] rscElts = res.split(" ");
                    for (String rscElt : rscElts) {
                        if (rscElt.equalsIgnoreCase(element)) {
                            test = true;
                        }
                    }
                }
            }
        } else {
            test = true;
        }
        return test;
    }

    /**
     * Get all the subscriptions in the database
     * @return The vector containing all the subscriptions
     */
    public Vector<String> getAllSubscriptions() {
        Vector<String> vectSubs = new Vector<String>();

        SubsQueries sbQuery = new SubsQueries();
        //Recupere toutes les subscriptions
        ResultSet result = conn.execSelectQuery(sbQuery.getAllSubs(), sbQuery.getModel());

        // Remplie le vecteur de subscriptions
        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            String url = rb.get("r").toString();
            vectSubs.add(url);
        }
        return vectSubs;
    }

    public void displaySubscription(Subscription subs) {
        System.out.println("-------------------------------------");
        System.out.println("   Subscription");
        System.out.println("Submitter : " + subs.getSubmitter());
        System.out.println("Content : " + subs.descrToString("content"));
        System.out.println("Nature : " + subs.getNature());
    }
}
