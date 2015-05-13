import java.util.Hashtable;

import javax.naming.Context;
import javax.naming.NamingException;
import javax.naming.directory.Attributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.servlet.ServletContext;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Class mettant en place les web services utilis�s pour la r�cup�ration de
 * donn�es du LDAP Unice.
 * 
 * @author LIZARRALDE Dorian
 * 
 */
@Path("/LDAP")
public class LDAP {

	private static Logger logs = LogManager.getLogger(LDAP.class);

	// Permet l'acc�s aux param�tres de la servlet
	@javax.ws.rs.core.Context
	ServletContext context;

	/**
	 * Requ�te le LDAP Unice pour obtenir les donn�es de l'utilisateur.
	 * 
	 * @param param1
	 *            L'identifiant de l'utilisateur
	 * @param param2
	 *            Le type d'utilisateur
	 * @return Les donn�es de l'utilisateurs format�es en JSON.
	 * @throws JSONException
	 */
	@POST
	@Produces("application/json")
	public Response call(@FormParam("param1") String param1,
			@FormParam("param2") String param2) throws JSONException {

		logs.info("{param1 : " + param1 + ", param2:" + param2 + "}");

		// La r�ponse JSON
		JSONObject jsonObject = new JSONObject();

		// Les param�tres de connexion LDAP
		String serverIP = context.getInitParameter("serverIP");
		String serverPort = context.getInitParameter("serverPort");

		logs.info("{serverIP : " + serverIP + ", serverPort:" + serverPort
				+ "}");

		// D�claration de l'environnement
		Hashtable<String, String> environnement = new Hashtable<String, String>();
		environnement.put(Context.INITIAL_CONTEXT_FACTORY,
				"com.sun.jndi.ldap.LdapCtxFactory");
		environnement.put(Context.PROVIDER_URL, "ldap://" + serverIP + ":"
				+ serverPort + "/");
		environnement.put(Context.SECURITY_AUTHENTICATION, "none");

		try {

			DirContext contexte = new InitialDirContext(environnement);

			try {

				logs.info("Recherche de l'utilisateur");

				// Requ�te LDAP
				Attributes attrs = contexte.getAttributes("uid=" + param1
						+ ",ou=" + param2 + ",ou=people,dc=unice,dc=fr");

				Object mail = attrs.get("mail").get();
				Object diplomep = attrs.get("diplomep") != null ? attrs.get(
						"diplomep").get() : "";
				Object givenName = attrs.get("givenName").get();
				Object sn = attrs.get("sn").get();

				logs.info("{mail : " + mail + ", diplomep : " + diplomep
						+ ", givenName : " + givenName + ", sn : " + sn + "}");

				// Mise en place de la r�ponse JSON
				jsonObject.put("mail", mail);
				jsonObject.put("diplomep", diplomep);
				jsonObject.put("givenName", givenName);
				jsonObject.put("sn", sn);
			} catch (NamingException e) {

				logs.error(e.getMessage());

				return Response.status(503).build();
			}
		} catch (NamingException e) {

			logs.error(e.getMessage());

			return Response.status(503).build();
		}

		logs.info("R�ponse : " + jsonObject);

		return Response.status(200).entity(jsonObject.toString()).build();
	}
}
