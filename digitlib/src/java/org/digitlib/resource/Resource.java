package org.digitlib.resource;

/**
 * NoTaxoRegister.java
 * Created on 1 novembre 2006, 16:46
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 *
 * @author unascribed
 * @version 1.58, 12/03/01
 * @param
 * @since JDK1.0
 * @return
 * @throws
 * @deprecated
 * @see java.lang.Class
 */
import com.hp.hpl.jena.db.ModelRDB;
import com.hp.hpl.jena.query.*;
import com.hp.hpl.jena.rdf.model.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.digitlib.db.RdfDBAccess;
import org.digitlib.user.User;
import org.digitlib.vocabulary.Vocabulary;

public class Resource {

    /**
     * NoTaxoRegister.java
     * Created on 1 novembre 2006, 16:46
     * To change this template, choose Tools | Template Manager
     * and open the template in the editor.
     *
     * @author unascribed
     * @version 1.58, 12/03/01
     * @param
     * @since JDK1.0
     * @return
     * @throws
     * @deprecated
     * @see java.lang.Class
     */
    public static final String NEW = "insertion";
    public static final String UPDATE = "modification";
    public static final String DELETE = "suppression";
    private String url = "";
    private String language = "";
    private String format = "";
    private String state = "";
    private String type = "";
    private Vocabulary voc = new Vocabulary();
    private User submitter = new User();
    private List<String> content = new ArrayList();
    private String author ="";//= new ArrayList();
    private Map<String, String> resAttrib = new HashMap();
    private ResQueries query = new ResQueries();
    RdfDBAccess conn = new RdfDBAccess();
    // NEW by default
    private String type_maj = Resource.NEW;
    private String path;

    /**
     * Creates a new instance of NoTaxoRegister
     */
    public Resource() {
    }

    public Resource(RdfDBAccess conn) {
        this.conn = conn;
    }

    public Resource(RdfDBAccess conn, String _path) {
        this.conn = conn;
        this.path = _path;
    }

    public Resource(Map<String, String> rsrce, RdfDBAccess conn) {
        this(conn);
        this.url = rsrce.get("url");
        try{
        this.submitter = new User(rsrce.get("submitter"), conn);
        }catch(Exception ex){

        }
        this.language = rsrce.get("language");
        this.author = rsrce.get("author");//query.stringToList(rsrce.get("author"));
        this.format = rsrce.get("format");
        this.state = rsrce.get("state");
        this.type = rsrce.get("type");
        this.voc = new Vocabulary(rsrce.get("vocname"), this.conn);
        this.content = this.voc.labelsToIs(rsrce.get("content"));
        this.resAttrib = rsrce;
    }
    
    // Ajout du parametre path, servant a placer le fichier rss au bon endroit lors de la notification
    public Resource(Map<String, String> rsrce, RdfDBAccess conn, String _path) {
        this(conn, _path);
        this.url = rsrce.get("url");
        try{
        this.submitter = new User(rsrce.get("submitter"), conn);
        }catch(Exception ex){

        }
        this.language = rsrce.get("language");
        this.author = rsrce.get("author");//query.stringToList(rsrce.get("author"));
        this.format = rsrce.get("format");
        this.state = rsrce.get("state");
        this.type = rsrce.get("type");
        this.voc = new Vocabulary(rsrce.get("vocname"), this.conn);
        this.content = this.voc.labelsToIs(rsrce.get("content"));
        this.resAttrib = rsrce;
    }

    public Resource(String url, RdfDBAccess conn) {
        this(conn);
        Map<String, String> resAttr = new HashMap();
        String descr = "";
        ResultSet result = this.conn.execSelectQuery(query.getRsrceByUrl(url), query.getModel());
        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            String tab[] = rb.get("p").toString().split("/|#");
            String p = tab[tab.length - 1];
            String o = rb.get("o").toString();
            if (!"content".equals(p)) {
                resAttr.put(p, o);
            } else {
                this.content.add(o);
            }
        }
        resAttr.put("content", descr);
        this.url = resAttr.get("url");
        try{
        this.submitter = new User(resAttr.get("submitter"), this.conn);
        }catch(Exception ex){

        }
        this.language = resAttr.get("language");
        this.author = resAttr.get("author");//query.stringToList(resAttr.get("author"));
        this.format = resAttr.get("format");
        this.state = resAttr.get("state");
        this.type = resAttr.get("type");
        this.voc = new Vocabulary(resAttr.get("vocname"), this.conn);
        this.resAttrib = resAttr;
    }

    public void activateResource(String url, String value) {//Delete resource from the model
        this.conn.execUpdateQuery(this.query.changeState(url, value), this.query.getModel());
    }

    public void deleteResource(String resUrl) {//Delete resource from the model
        ModelRDB model = conn.getModel(query.getModel());
        com.hp.hpl.jena.rdf.model.Resource r = model.createResource(resUrl);

        this.conn.execUpdateQuery(this.query.deleteResource(resUrl), this.query.getModel());
        String contUrl = contentUrl(resUrl);
        if(contUrl==null)
            return;
        if(!contentIsUsed(contUrl)){
            deleteContent(contUrl);
        }
    }

    public String contentUrl(String resUrl) {
        ResultSet result = conn.execSelectQuery(query.getContentUrl(resUrl), query.getModel());
        String contUrl = null;
        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            contUrl = rb.get("o").toString();
        }
        return contUrl;
    }
    
    public void deleteContent(String contUrl) {//Delete resource from the model
        this.conn.execUpdateQuery(this.query.deleteContent(contUrl), this.query.getModel());
    }
    /**
     *
     * @param contUrl
     * @return true if there exists a resource with content's url contUrl
     */
    public boolean contentIsUsed(String contUrl) {
        return conn.execAskQuery(query.existContent(contUrl), query.getModel());

    }
    public boolean resourceExist() {
        return conn.execAskQuery(query.existResource(this), query.getModel());
        
    }



    /**
     *
     * @return the url of the content of this resource
     */
    public String contentUrl() {
        ResultSet result = conn.execSelectQuery(query.getContentUrl(this.getUrl()), query.getModel());
        String contUrl = null;
        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            contUrl = rb.get("o").toString();
        }
        return contUrl;
    }

    public String contentToString(String contUrl) {
        ResultSet result = conn.execSelectQuery(query.contentTerm(contUrl), query.getModel());
        String cont = "";
        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            cont += rb.get("o").toString().split("#")[1]+" ";            
        }
        return cont;
    }

    /**
     *
     * @return the description'url of a resource if it exists and null otherwise
     */
    public String getContentUrl() {
        ResultSet result = conn.execSelectQuery(query.listContent(this), query.getModel());

        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            String contURL = rb.get("r").toString();
            ResultSet result1 = conn.execSelectQuery(query.contentTerm(contURL), query.getModel());
            if(conn.size(result1)==this.getContent().size())
                return contURL;
        }
        return null;
    }
/**
 *
 * @param vocUrl th url of the courant vocabulary
 * @param labelsIds a list of terms' id without url
 * @return a list of resource'url
 */
    public List<String> resourceUrl(String vocUrl, List<String> labelsIds) {
        List<String> contentUrls = new ArrayList();
        ResultSet result = conn.execSelectQuery(query.contentUrlList(vocUrl,labelsIds), query.getModel());

        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            String contURL = rb.get("r").toString();
            ResultSet result1 = conn.execSelectQuery(query.getResource("content", contURL), query.getModel());
            if(result1.hasNext())
                contentUrls.add(result1.nextSolution().get("url").toString());
        }
        return contentUrls;
    }
/**
 *
 * @param labelsIds a list of terms' id url
 * @return a list of resource'url
 */
    public List<String> resourceUrl(List<String> labelsIds) {
        List<String> contentUrls = new ArrayList();
        ResultSet result = conn.execSelectQuery(query.contentUrlList(labelsIds), query.getModel());

        while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            String contURL = rb.get("r").toString();
            ResultSet result1 = conn.execSelectQuery(query.getResource("content", contURL), query.getModel());
            if(result1.hasNext())
                contentUrls.add(result1.nextSolution().get("url").toString());
        }
        return contentUrls;
    }

    public List<String> contentUrl(String vocUrl, List<String> labelsIds) {
        List<String> contentUrls = new ArrayList();
        ResultSet result = conn.execSelectQuery(query.contentUrlList(vocUrl,labelsIds), query.getModel());


       while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            //String contURL = rb.get("r").toString();

            contentUrls.add(rb.get("r").toString());
        }
        return contentUrls;
    }

    public List<String> contentUrl(List<String> labelsIds) {
        List<String> contentUrls = new ArrayList();
        ResultSet result = conn.execSelectQuery(query.contentUrlList(labelsIds), query.getModel());


       while (result.hasNext()) {
            QuerySolution rb = result.nextSolution();
            //String contURL = rb.get("r").toString();

            contentUrls.add(rb.get("r").toString());
        }
        return contentUrls;
    }
    
    /**
     * Add a new resource in the catalogue
     * 
     * @return
     */
    public boolean addResource() {
        if (resourceExist()) {
            return false;
        } else {
            String contUrl = getContentUrl();
            if(contUrl==null){ //check if content exists
                Date date = new Date();
                contUrl = query.getRes()+"#"+Long.toString(date.getTime());
                conn.execUpdateQuery(query.insertContent(this,contUrl), query.getModel());
            }

            conn.execUpdateQuery(query.insertResource(this, contUrl), query.getModel());
            //When a new ressource is added, the notifications are sent

            new org.digitlib.subscription.Notification(conn, path).sendNotifications(this);
            new org.digitlib.subscription.Notification(conn, path).feedNotifications(this);
            return true;
        }
    }

    public void updateResource(String url) {
        deleteResource(url);
        this.setType_maj(Resource.UPDATE);
        addResource();
    }

    public String getUrl() {
        return url;
    }

    public Vocabulary getVoc() {
        return voc;
    }

    public User getSubmitter() {
        return submitter;
    }

    public String getLanguage() {
        return language;
    }

    public String getAuthor() {
        return author;
    }

    public String getFormat() {
        return format;
    }

    public String getState() {
        return state;
    }

    public String getType() {
        return type;
    }

    public List<String> getContent() {
        return content;
    }

    /**
     * @return the type_maj
     */
    public String getType_maj() {
        return type_maj;
    }

    /**
     * @param type_maj the type_maj to set
     */
    public void setType_maj(String type_maj) {
        this.type_maj = type_maj;
    }

    /**
     *
     * @return The map of all attributes for this resource
     */
    public Map<String, String> getResAttrib() {
        return resAttrib;
    }
}

