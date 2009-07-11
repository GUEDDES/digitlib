package org.digitlib.subscription;

import java.util.Iterator;
import org.digitlib.db.RdfDBAccess;
import com.hp.hpl.jena.query.*;
import java.util.ArrayList;
import java.util.List;
import org.digitlib.resource.*;
import org.digitlib.ConfigQueries;
import org.digitlib.user.User;

public class Notification {

    RdfDBAccess conn = new RdfDBAccess();
    List<String> notifattr = null;
    VocUtils vocUtils;
    String path;

    public Notification(RdfDBAccess conn, String _path) {
        this.conn = conn;
        this.path = _path;
        ConfigQueries sQuery = new ConfigQueries();
        vocUtils = new VocUtils(conn,true);
        ResultSet result = null;
        try {
            result = conn.execSelectQuery(sQuery.getAllParams(), sQuery.getModel());
            QuerySolution rb;
            List<String> resnattr = new ArrayList();
            while (result.hasNext()) {
                rb = result.nextSolution();
                String tab[] = rb.get("p").toString().split("/|#");
                String p = tab[tab.length - 1];
                String o = rb.get("o").toString();
                if ("resnotifattrib".equals(p)) {
                    resnattr.add(o);
                }
            }
            notifattr = resnattr;
        } catch (Exception e) {
            System.out.println("Exception while recuperating configuration parameters : " + e);
        }
    }

    private String generateMessage(Resource newResource) {
        //Message building
        String msg = "Resource concerned : " + newResource.getUrl() + "\n";
        msg += "Update type : " + newResource.getType_maj() + "\n";
        msg += "Submitter : " + newResource.getSubmitter().getFirstname() +
                " " + newResource.getSubmitter().getLastname() + "\n";
        msg += "Document type : " + newResource.getFormat() + "\n";
        msg += "Terms describing this resource : ";
        Iterator itResource = newResource.getContent().iterator();
        while (itResource.hasNext()) {
            msg += " " + itResource.next();
        }

        return msg;
    }

    /**
     * Send an e-mail notification for an updated resource
     * @param newRessource
     */
    public void sendNotifications(Resource newResource) {

        String msg = generateMessage(newResource);

        MatchingUtils match = new MatchingUtils(conn, notifattr, vocUtils);
        //Recuperate all the subscriptions that are concerned
        //by this modification
        Iterator itSubs = match.getSubscriptionsConcerned(newResource).iterator();
        while (itSubs.hasNext()) {
            Subscription subs = (Subscription) itSubs.next();
            System.out.println("(Mail) Subscription matchante recuperee : "+subs.getUrl());
            try {
                Iterator itUsers = subs.getSubmitter().iterator();
                while (itUsers.hasNext()) {
                    String usrLogin = (String) itUsers.next();
                    System.out.println("Login : "+usrLogin);
                    User us = new User(usrLogin, conn);
                    System.out.println(us.getEmail());

                    List<String> notifMethod = us.getNotifmethod();
                    if (notifMethod.contains("0")) {
                        // Sends the email to the subscriber
                        new Email().send(us.getEmail(),"The resource " + newResource.getUrl() + " has been modified",msg);
                    }
                }
                 
               // System.out.println("Email sent to " + subs.getSubmitter().getLogin() + "(" + subs.getSubmitter().getEmail() + ")");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void feedNotifications(Resource newResource) {

        String msg = generateMessage(newResource);

        MatchingUtils match = new MatchingUtils(conn, notifattr, vocUtils);
        //Recuperate all the subscriptions that are concerned
        //by this modification
        Iterator itSubs = match.getSubscriptionsConcerned(newResource).iterator();
        while (itSubs.hasNext()) {
            Subscription subs = (Subscription) itSubs.next();
            System.out.println("(RSS) Subscription matchante recuperee : "+subs.getUrl());
            String content = "Terms describing this resource :";
            Iterator itResource = newResource.getContent().iterator();
            while (itResource.hasNext()) {
                content += " " + itResource.next();
            }
            try {
                Iterator itUsers = subs.getSubmitter().iterator();
                while (itUsers.hasNext()) {
                    String usrLogin = (String) itUsers.next();
                    System.out.println("Login : "+usrLogin);
                    User us = new User(usrLogin, conn);

                    List<String> notifMethod = us.getNotifmethod();
                    if (notifMethod.contains("1")) {
                        RSSFeed feed = new RSSFeed(us.getLogin(), path);
                        feed.addFeed(newResource.getUrl(), newResource.getType_maj(), msg);
                    }

                    // System.out.println("Email sent to " + subs.getSubmitter().getLogin() + "(" + subs.getSubmitter().getEmail() + ")");
                }

               

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

}
