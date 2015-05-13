import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;

import javax.servlet.ServletContext;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Class mettant en place les web services utilisés pour la génération des KPI.
 * 
 * @author LIZARRALDE Dorian
 * 
 */
@Path("/StoredProcedure")
public class StoredProcedure {

	private static Logger logs = LogManager.getLogger(StoredProcedure.class);

	// Permet l'accès aux paramètres de la servlet
	@Context
	ServletContext context;

	/**
	 * Appel la procédure stockée passée en paramètre et fournit les paramètres
	 * associés si besoin.
	 * 
	 * @param param1
	 *            Le nom de la procédure
	 * @param param2
	 *            Un index à fournir pour la procédure "Top 10"
	 * @param param3
	 *            Un identifiant à fournir pour la procédure "Top 10"
	 * @return La réponse de la procédure stockée formattée en JSON pouvant être
	 *         interprété directement par les KPI.
	 * @throws JSONException
	 */
	@POST
	@Produces("application/json")
	public Response call(@FormParam("param1") String param1,
			@FormParam("param2") String param2,
			@FormParam("param3") String param3) throws JSONException {

		logs.info("{param1 : " + param1 + ", param2:" + param2 + ", param3 : "
				+ param3 + "}");

		// La connexion Bd
		Connection connect = null;

		// La réponse JSON
		JSONObject jsonObject = new JSONObject();

		// Les paramètres de connexion Bd
		String DbUrl = context.getInitParameter("DbUrl");
		String DbName = context.getInitParameter("DbName");
		String DbUser = context.getInitParameter("DbUser");
		String DbPwd = context.getInitParameter("DbPwd");

		logs.info("{DbUrl : " + DbUrl + ", DbName:" + DbName + ", DbUser : "
				+ DbUser + ", DbPwd : " + DbPwd + "}");

		try {

			logs.info("Connexion à la Bd");

			Class.forName("com.mysql.jdbc.Driver");

			// Ouverture de la connexion Bd
			connect = DriverManager.getConnection("jdbc:mysql://" + DbUrl + "/"
					+ DbName, DbUser, DbPwd);

			logs.info("Connexion à la Bd réussie");

			// Déclaration du Stmt
			CallableStatement p = null;

			// Appel avec ou sans paramètres
			if (param2.length() + param3.length() > 0) {

				p = connect.prepareCall("{call " + DbName + "." + param1
						+ "(?, ?)}");

				// Mise en place des paramètres
				p.setInt(1, Integer.parseInt(param2));
				p.setString(2, param3);
			} else {

				p = connect.prepareCall("{call " + DbName + "." + param1
						+ "()}");
			}

			logs.info("Appel de la procédure");

			// Récupération du résultat de la procédure stockée
			ResultSet rs = p.executeQuery();

			// La réponse se fera en asynchrone pour le demandeur.
			// Il faut donc rappeler le nom de la procédure demandée.
			jsonObject.put("procName", param1);

			logs.info("Mise en place du JSON");

			// Résultat Mono/Multi
			if (rs.getMetaData().getColumnCount() != 3) {

				// Chart camembert
				jsonObject.put("type", "pie");

				JSONArray data = new JSONArray();

				// Parcours des données
				while (rs.next()) {

					JSONObject j = new JSONObject();

					j.put("id", rs.getString(ID_COLUMN_NAME));
					j.put("y", rs.getLong(VALUE_COLUMN_NAME));
					j.put("name", rs.getString(FIRST_NAME_COLUMN_NAME) + " "
							+ rs.getString(LAST_NAME_COLUMN_NAME));
					j.put("picture", rs.getString(PICTURE_COLUMN_NAME));

					data.put(j);
				}

				jsonObject.put("data", data);
			} else {

				// Chart ligne
				jsonObject.put("type", "line");

				JSONArray categories = new JSONArray();
				JSONArray series = new JSONArray();

				JSONObject j = null;
				JSONArray data = null;

				String previousId = "";
				String currentId = null;

				// Parcours des données
				while (rs.next()) {

					categories.put(rs.getString(AXIS_COLUMN_NAME));

					currentId = rs.getString(ID_COLUMN_NAME);

					if (!previousId.equals(currentId)) {

						if (!rs.isFirst()) {

							j.put("data", data);

							series.put(j);
						}

						j = new JSONObject();
						data = new JSONArray();

						j.put("name", currentId);

						data.put(rs.getString(VALUE_COLUMN_NAME));
					} else {

						data.put(rs.getString(VALUE_COLUMN_NAME));

						if (rs.isLast()) {

							j.put("data", data);

							series.put(j);
						}
					}

					previousId = currentId;
				}

				jsonObject.put("categories", categories);
				jsonObject.put("data", series);
			}
		} catch (Exception e) {

			logs.error(e.getMessage());

			return Response.status(503).build();
		}

		logs.info("Réponse : " + jsonObject);

		return Response.status(200).entity(jsonObject.toString()).build();
	}

	// Nom des colonnes résultats
	private final static String ID_COLUMN_NAME = "IDENT";
	private final static String AXIS_COLUMN_NAME = "AXIS";
	private final static String VALUE_COLUMN_NAME = "RES";
	private final static String LAST_NAME_COLUMN_NAME = "LAST_NAME";
	private final static String FIRST_NAME_COLUMN_NAME = "FIRST_NAME";
	private final static String PICTURE_COLUMN_NAME = "PICTURE";
}
