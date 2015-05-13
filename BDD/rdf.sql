-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Client :  127.0.0.1
-- Généré le :  Mer 13 Mai 2015 à 11:10
-- Version du serveur :  5.6.17
-- Version de PHP :  5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données :  `rdf`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `nbCoureurDepartement`()
BEGIN
	DECLARE v1 INT DEFAULT 0;

  	WHILE v1 <= 10 DO
        select PART_ORIGINE as IDENT, v1 as AXIS, count(*) as RES
        from participant
        where nbTourCoureur(PART_ID) = v1
        group by PART_ORIGINE
        order by AXIS, IDENT;
        
        SET v1 = v1 + 1;
	END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nbCoureurSexe`()
BEGIN
	DECLARE v1 INT DEFAULT 0;

  	WHILE v1 <= 10 DO
		select PART_SEXE as IDENT, v1 as AXIS, count(*) as RES
        from participant
        where nbTourCoureur(PART_ID) = v1
        group by PART_SEXE
        order by AXIS, IDENT;   
        
    	SET v1 = v1 + 1;
	END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `topRunner`(IN `indexx` INT(10), IN `idEtudiant` VARCHAR(40))
BEGIN
	DECLARE indexmax INT(10);
	SET indexmax := 9;
	if indexx != 0 then
        SET indexx := indexx - 1;
        select PART_IDETUDIANT as IDENT, nbTourCoureur(PART_ID) as RES, PART_NOM as LAST_NAME, PART_PRENOM as FIRST_NAME, PART_AVATAR as PICTURE
        from participant
        inner join carte ON participant.PART_ID = carte.CARTE_IDETUDIANT
        order by res
        limit indexx, indexmax;
    end if;
END$$

--
-- Fonctions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `chronoRunner`(`idEtudiant` INT) RETURNS int(11)
BEGIN
	RETURN (select TIMESTAMPDIFF(second, min(pass_chrono) , max(pass_chrono))
	from passage
	inner join carte ON passage.PASS_IDCARTE = carte.CARTE_IDCARTE
	where CARTE_IDETUDIANT = idEtudiant);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `nbCoureurTourSexe`(`NombreTour` INT, 

`Sexe` CHAR) RETURNS int(11)
BEGIN
    RETURN (select count(*) as NbCoureur
    from participant
    where nbTourCoureur(PART_ID) = NombreTour
    and PART_SEXE = Sexe);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `nbTourCoureur`(`idEtudiant` VARCHAR

(40)) RETURNS int(11)
BEGIN
	RETURN (select FLOOR(count(*)/2)
    from passage
    inner join carte ON passage.PASS_IDCARTE = carte.CARTE_IDCARTE
    inner join participant ON carte.CARTE_IDETUDIANT = participant.PART_ID
    where PART_ID = idEtudiant);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `carte`
--

CREATE TABLE IF NOT EXISTS `carte` (
  `CARTE_IDCARTE` varchar(25) NOT NULL,
  `CARTE_IDETUDIANT` int(10) NOT NULL,
  PRIMARY KEY (`CARTE_IDCARTE`),
  KEY `FKCARTE329128` (`CARTE_IDETUDIANT`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `participant`
--

CREATE TABLE IF NOT EXISTS `participant` (
  `PART_ID` int(10) NOT NULL AUTO_INCREMENT,
  `PART_IDETUDIANT` varchar(10) DEFAULT NULL,
  `PART_NOM` varchar(25) DEFAULT NULL,
  `PART_PRENOM` varchar(25) DEFAULT NULL,
  `PART_SEXE` char(1) DEFAULT NULL,
  `PART_DATENAISSANCE` date DEFAULT NULL,
  `PART_STATUT` tinyint(1) DEFAULT NULL,
  `PART_TYPE` tinyint(1) DEFAULT NULL,
  `PART_CERTIFICATMED` blob,
  `PART_EMAIL` varchar(70) DEFAULT NULL,
  `PART_NATIONALITE` varchar(30) DEFAULT NULL,
  `PART_ORIGINE` varchar(30) DEFAULT NULL,
  `PART_MOTDEPASSE` varchar(30) DEFAULT NULL,
  `PART_CONFIRMATION` tinyint(1) DEFAULT NULL,
  `PART_AVATAR` blob,
  `PART_DIPLOME` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`PART_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `passage`
--

CREATE TABLE IF NOT EXISTS `passage` (
  `PASS_ID` int(10) NOT NULL AUTO_INCREMENT,
  `PASS_IDCARTE` varchar(25) NOT NULL,
  `PASS_IDMACHINE` int(10) DEFAULT NULL,
  `PASS_CHRONO` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`PASS_ID`),
  KEY `FKPASSAGE339701` (`PASS_IDCARTE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `carte`
--
ALTER TABLE `carte`
  ADD CONSTRAINT `FKCARTE329128` FOREIGN KEY (`CARTE_IDETUDIANT`) REFERENCES `participant` (`PART_ID`);

--
-- Contraintes pour la table `passage`
--
ALTER TABLE `passage`
  ADD CONSTRAINT `FKPASSAGE339701` FOREIGN KEY (`PASS_IDCARTE`) REFERENCES `carte` (`CARTE_IDCARTE`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
