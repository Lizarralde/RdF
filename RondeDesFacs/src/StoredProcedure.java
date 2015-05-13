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
 * Class mettant en place les web services utilis�s pour la g�n�ration des KPI.
 * 
 * @author LIZARRALDE Dorian
 * 
 */
@Path("/StoredProcedure")
public class StoredProcedure {

	private static Logger logs = LogManager.getLogger(StoredProcedure.class);

	// Permet l'acc�s aux param�tres de la servlet
	@Context
	ServletContext context;

	/**
	 * Appel la proc�dure stock�e pass�e en param�tre et fournit les param�tres
	 * associ�s si besoin.
	 * 
	 * @param param1
	 *            Le nom de la proc�dure
	 * @param param2
	 *            Un index � fournir pour la proc�dure "Top 10"
	 * @param param3
	 *            Un identifiant � fournir pour la proc�dure "Top 10"
	 * @return La r�ponse de la proc�dure stock�e formatt�e en JSON pouvant �tre
	 *         interpr�t� directement par les KPI.
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

		// La r�ponse JSON
		JSONObject jsonObject = new JSONObject();

		// Les param�tres de connexion Bd
		String DbUrl = context.getInitParameter("DbUrl");
		String DbName = context.getInitParameter("DbName");
		String DbUser = context.getInitParameter("DbUser");
		String DbPwd = context.getInitParameter("DbPwd");

		logs.info("{DbUrl : " + DbUrl + ", DbName:" + DbName + ", DbUser : "
				+ DbUser + ", DbPwd : " + DbPwd + "}");

		try {

			logs.info("Connexion � la Bd");

			Class.forName("com.mysql.jdbc.Driver");

			// Ouverture de la connexion Bd
			connect = DriverManager.getConnection("jdbc:mysql://" + DbUrl + "/"
					+ DbName, DbUser, DbPwd);

			logs.info("Connexion � la Bd r�ussie");

			// D�claration du Stmt
			CallableStatement p = null;

			// Appel avec ou sans param�tres
			if (param2.length() + param3.length() > 0) {

				p = connect.prepareCall("{call " + DbName + "." + param1
						+ "(?, ?)}");

				// Mise en place des param�tres
				p.setInt(1, Integer.parseInt(param2));
				p.setString(2, param3);
			} else {

				p = connect.prepareCall("{call " + DbName + "." + param1
						+ "()}");
			}

			logs.info("Appel de la proc�dure");

			// R�cup�ration du r�sultat de la proc�dure stock�e
			ResultSet rs = p.executeQuery();

			// La r�ponse se fera en asynchrone pour le demandeur.
			// Il faut donc rappeler le nom de la proc�dure demand�e.
			jsonObject.put("procName", param1);

			logs.info("Mise en place du JSON");

			// R�sultat Mono/Multi
			if (rs.getMetaData().getColumnCount() != 3) {

				// Chart camembert
				jsonObject.put("type", "pie");

				JSONArray data = new JSONArray();

				// Parcours des donn�es
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

				// Parcours des donn�es
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

		logs.info("R�ponse : " + jsonObject);

		return Response.status(200).entity(jsonObject.toString()).build();
	}

	// Nom des colonnes r�sultats
	private final static String ID_COLUMN_NAME = "IDENT";
	private final static String AXIS_COLUMN_NAME = "AXIS";
	private final static String VALUE_COLUMN_NAME = "RES";
	private final static String LAST_NAME_COLUMN_NAME = "LAST_NAME";
	private final static String FIRST_NAME_COLUMN_NAME = "FIRST_NAME";
	private final static String PICTURE_COLUMN_NAME = "PICTURE";
}
