#include "clientWebS.h"
#include <stdio.h>      /* printf */
#include <stdlib.h>     /* system, NULL, EXIT_FAILURE */ 
#include<time.h>   
#include <winsock.h>
#include <mysql.h>

int saveCardID(char* cardId, char* etuId)
{
	MYSQL mysql;
	mysql_init(&mysql);
	mysql_options(&mysql, MYSQL_READ_DEFAULT_GROUP, "option");

	if (mysql_real_connect(&mysql, "www.goldzoneweb.info", "mon_pseudo", "******", "ma_base", 0, NULL, 0))
	{
		mysql_query(&mysql, strcat(strcat("SELECT part_id FROM participant where part_idetudiant = '",etuId),"'"));
		//Déclaration des objets
		MYSQL_RES *result = NULL;
		MYSQL_ROW row;
		char* id;

		//On met le jeu de résultat dans le pointeur result
		result = mysql_use_result(&mysql);
		//Tant qu'il y a encore un résultat ...
		while ((row = mysql_fetch_row(result)))
		{
			id = row[0];
		}
		//Libération du jeu de résultat
		mysql_free_result(result);
		mysql_query(&mysql, strcat(strcat(strcat(strcat("INSERT INTO carte VALUES('", cardId),"', "), id), ")"));
		mysql_close(&mysql);
	}
	else
	{
		printf("Une erreur s'est produite lors de la connexion à la BDD!");
	}

	return 0;

}

void saveLapDateTime(char* carteId, char* machineName)
{
	MYSQL mysql;
	mysql_init(&mysql);
	mysql_options(&mysql, MYSQL_READ_DEFAULT_GROUP, "option");

	if (mysql_real_connect(&mysql, "www.goldzoneweb.info", "mon_pseudo", "******", "ma_base", 0, NULL, 0))
	{
		mysql_query(&mysql, strcat(
							strcat(
							strcat(
							strcat(
							strcat(
							strcat("INSERT INTO passage VALUES(DEFAULT, '", carteId)
							, "', '")
							, machineName)
							, "', ")
							, "CURRENT_TIMESTAMP")
							, ")"));
		mysql_close(&mysql);
	}
	else
	{
		printf("Une erreur s'est produite lors de la connexion à la BDD!");
	}

	return ;

}