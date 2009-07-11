/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.digitlib.subscription;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.digitlib.db.RdfDBAccess;

/**
 *
 * @author sebastien
 */
public class TestAjoutSub {

    private RdfDBAccess conn;
    private int nbSubAGe = 0;
    private Map<String, String> attrCont = new HashMap<String, String>();
    private String tabCont [] = new String [15000];

    public TestAjoutSub (int nbSub){
        conn = new RdfDBAccess();
        conn.init(
                "MySQL",
                "jdbc:mysql://127.0.0.1:3306/digitlib3?autoReconnect=true",
                "com.mysql.jdbc.Driver",
                "root",
                "rootroot",
                "dl_");
        conn.DBConnect();

        nbSubAGe = nbSub;
    }

    public boolean parcourFichierRessource(String namFic) {
        //tout d'abord on va ouvrir le fichier description.rdf qui va nous permettre de récupérer touts les contents du voc
        Vector<Subscription> vectSub = new Vector<Subscription>();
        
        
        VocUtils vu = new VocUtils(conn, true);
        int indice = 0;
        try {
            InputStream ips;
            //ici on lit fichier par fichier
            ips = new FileInputStream("web/includes/data/resources/descriptionTest.rdf");
            InputStreamReader ipsr = new InputStreamReader(ips);
            BufferedReader br = new BufferedReader(ipsr);
            String ligne;
            //faut récupérer l'ID des contents ainsi que la liste des content
            Pattern patDesDeb = Pattern.compile("<rdf:Description rdf:ID=\".*\">", Pattern.CASE_INSENSITIVE);
            Pattern patDesFin = Pattern.compile("</rdf:Description>", Pattern.CASE_INSENSITIVE);
            Pattern patCont = Pattern.compile("<rdf:type rdf:resource=\"&acmccs98;#.*\"/>", Pattern.CASE_INSENSITIVE);

            Matcher matDesDeb, matDesFin, matCont;
            String idCont = "", listCont = "";

            while ((ligne = br.readLine()) != null) {
                matDesDeb = patDesDeb.matcher(ligne);
                matDesFin = patDesFin.matcher(ligne);
                matCont = patCont.matcher(ligne);

                if (matDesDeb.find()) {
                    //la on va récupérer l'ID de notre liste de content
                    int start = matDesDeb.start();
                    int end = matDesDeb.end();
                    idCont = ligne.substring(start + 25, end - 2);
                }

                if (matCont.find()) {
                    int start = matCont.start();
                    int end = matCont.end();
                    String cont = ligne.substring(start + 35, end - 3);
                    cont = cont.replaceAll(" ", "_");
                    if(listCont.equals("")){
                        listCont = cont;
                    }else{
                    listCont += " " + cont;
                    }
                }

                if (matDesFin.find()) {
                    //maintenant on va ajouter nos content dans une map
                  //  System.out.println("id du content "+idCont+" ----"+listCont);
                    attrCont.put(idCont, listCont);
                    tabCont [indice] =listCont;
                    idCont = "";
                    listCont = "";
                    indice ++;
                }
            }
        } catch (IOException ex) {
            Logger.getLogger(TestAjoutSub.class.getName()).log(Level.SEVERE, null, ex);
        }
        int nbSub = 0;
        try {
            InputStream ips;
            //ici on lit fichier par fichier
            ips = new FileInputStream("web/includes/data/resources/resourceTest.rdf");
            InputStreamReader ipsr = new InputStreamReader(ips);
            BufferedReader br = new BufferedReader(ipsr);
            String ligne;
            //faut récupérer le vocname le submitter le state générer une url
            Pattern patDesDeb = Pattern.compile("<rdf:Description rdf:about=" + ".*" + ">", Pattern.CASE_INSENSITIVE);
            Pattern patDesFin = Pattern.compile("</rdf:Description>", Pattern.CASE_INSENSITIVE);
            Pattern patVoc = Pattern.compile("<res:vocname>.*</res:vocname>", Pattern.CASE_INSENSITIVE);
            Pattern patState = Pattern.compile("<res:state>.*</res:state>", Pattern.CASE_INSENSITIVE);
            Pattern patCont = Pattern.compile("<res:content rdf:resource=\"#.*\"/>", Pattern.CASE_INSENSITIVE);

            Matcher matDesDeb, matDesFin, matVoc, matState, matCont;
            Map<String, String> attrSub = null;
            String idCont = "";

            while ((ligne = br.readLine()) != null) {
                matDesDeb = patDesDeb.matcher(ligne);
                matDesFin = patDesFin.matcher(ligne);
                matVoc = patVoc.matcher(ligne);
                matState = patState.matcher(ligne);
                matCont = patCont.matcher(ligne);

                if (matDesDeb.find()) {
                    //on doit créer une new Sub
                    attrSub = new HashMap<String, String>();
                    attrSub.put("nature", "0");
                    attrSub.put("submitter", "admin");
                    attrSub.put("login", "admin");
                    attrSub.put("url", vu.acmNS + "subTest" + "_" + new Date().getTime());
                    attrSub.put("vocname", "acmccs98");
                    attrSub.put("state", "1");
                    attrSub.put("author", "");
                    attrSub.put("language", "");
                    attrSub.put("format", "");
                    attrSub.put("resnotifattrib", "author-content-format-language");

                }

                if (matCont.find()) {
                    int start = matCont.start();
                    int end = matCont.end();
                    idCont = ligne.substring(start + 28, end - 3);
                   // System.out.println(" je rentre ici "+idCont);
                }

                if (matDesFin.find()) {
                    //fin de la sub on l'ajoute dans notre vect
                    if(!idCont.equals("")){
                        String IDlabels = attrCont.get(idCont);
                        String tab [] = IDlabels.split(" ");//on va récupéré chaque code des label
                        String labels ="";
                        for(int i = 0;i<tab.length;i++){
                            if(labels.equals("")){
                                labels = vu.getLabelByCode(tab[i]);
                            }
                            else{
                                labels += " "+vu.getLabelByCode(tab[i]);
                            }
                        }
                        attrSub.put("content",labels);
                        Locale locale = new Locale("english");
                       // if(nbSub>393){
                            //labels = labels.replace("\"", "&quot;");
                            Subscription sub = new Subscription(attrSub, conn, locale);
                            double timeDepart = new Date().getTime();
                            System.out.print(""+nbSub);
                            sub.addSubscription();
                            System.out.println("\t" + (new Date().getTime() - timeDepart));
                       // }
                        if(nbSub>=nbSubAGe){
                            return true;
                        } else {
                            nbSub++;
                        }
                    }
                    idCont = "";
                }
            }

        } catch (IOException ex) {
            Logger.getLogger(TestAjoutSub.class.getName()).log(Level.SEVERE, null, ex);
        }
        return true;
    }

    public boolean ajoutSubRacine (){
        VocUtils vu = new VocUtils(conn, true);
        int nbSub = 0;
        Vector<String> nomSubmiter = new Vector<String> ();
        nomSubmiter.add("robu");
        nomSubmiter.add("steff");
        nomSubmiter.add("sokaru");
        nomSubmiter.add("sisi");
        nomSubmiter.add("nguer");

        Map<String, String> attrSub = null;
        int indiceTabCont = 0;

        while (nbSub <=nbSubAGe){

            java.util.Iterator<String> iter = nomSubmiter.iterator();
            while(iter.hasNext()){
                String subTest = iter.next();
                attrSub = new HashMap<String, String>();
                attrSub.put("nature", "0");
                attrSub.put("submitter", subTest);
                attrSub.put("login", subTest);
                attrSub.put("url", vu.acmNS + "subTest" + "_" + new Date().getTime());
                attrSub.put("vocname", "acmccs98");
                attrSub.put("state", "1");
                attrSub.put("author", "");
                attrSub.put("language", "");
                attrSub.put("format", "");
                attrSub.put("resnotifattrib", "author-content-format-language");

                String IDlabels = tabCont [indiceTabCont];
                String tab [] = IDlabels.split(" ");//on va récupéré chaque code des label
                String labels ="";
                for(int i = 0;i<tab.length;i++){
                        if(labels.equals("")){
                            labels = vu.getLabelByCode(tab[i]);
                        }
                        else{
                            labels += " "+vu.getLabelByCode(tab[i]);
                        }
                }
                attrSub.put("content",labels);
                Locale locale = new Locale("english");
                Subscription sub = new Subscription(attrSub, conn, locale);
                double timeDepart = new Date().getTime();
                System.out.print(""+(nbSub+nbSubAGe+1));
                sub.addSubscription();
                // new SubTreeUtils(conn).printTheTree();
                System.out.println("\t" + (new Date().getTime() - timeDepart));
                nbSub++;
            }
            indiceTabCont++;
        }
        return true;

    }
    public void ajoutTestSub() {

        Map<String, String> attrCont = new HashMap<String, String>();
        Map<String, String> attrSub = null;
        RdfDBAccess conn = new RdfDBAccess();
        conn.init(
                "MySQL",
                "jdbc:mysql://127.0.0.1:3306/digitlib2?autoReconnect=true",
                "com.mysql.jdbc.Driver",
                "root",
                "rootroot",
                "dl_");
        conn.DBConnect();
        VocUtils vu = new VocUtils(conn, true);
        int i = 0;
        System.out.println("debut");
      // while(i<10){
        attrSub = new HashMap<String, String>();

        attrSub.put("content", "security,_integrity,_and_protection access_methods authentication");
         attrSub.put("nature", "0");
        attrSub.put("submitter", "admin");
        attrSub.put("login", "admin");
        attrSub.put("url", "subTest" + "_" + new Date().getTime());
        attrSub.put("vocname", "acmccs98");
        attrSub.put("state", "1");
        attrSub.put("author", "sisi");
        attrSub.put("language", "english");
        attrSub.put("format", "pdf");
        attrSub.put("resnotifattrib", "author-content-format-language");

        Locale locale = new Locale("english");
        Subscription sub = new Subscription(attrSub, conn, locale);
        sub.addSubscription();
        i++;
        // }
        System.out.println("fin");
    }

    public static void main(String[] args) {
                
        TestAjoutSub tAS = new TestAjoutSub(249);
        double timeDepart = new Date().getTime();
      
        //double timeDepart = new Date().getTime();
        tAS.parcourFichierRessource("test");
        tAS.ajoutSubRacine();
        //tAS.ajoutTestSub();
        System.out.println("Temps de calcul (ms) : " + (new Date().getTime() - timeDepart));
    }
}
