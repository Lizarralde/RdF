<?php
    session_start();

    //!\\ JSON //!\\
    //mail
    //diplomep
    //givenName
    //sn

?>
<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>Formulaire d'inscription</title>
    <!-- Optional theme -->
    <link rel="stylesheet" href="css/bootstrap.css">
    <!-- Latest compiled and minified JavaScript -->
    <script src="js/bootstrap.js"></script>
    <!-- Custom JavaScript -->
    <script src="js/custom.js"></script>
</head>
<body>
    
<!-- include header-->
<?php require('header.php'); ?>

<h1>Inscription</h1><br>

<form method="post" action="traitement.php" class="form-horizontal" enctype="multipart/form-data">
   <div class="form-group">

        <label for="numEtudiant">Numéro d'étudiant ou identifiant UNICE :</label>
        <span class="form_hint">* numéro d'étudiant format attendu "11223344"</span>
        <input type="text" class="form-control" name="numEtudiant" id="numEtudiant" onblur="checkEleve()" required autofocus /><br>

        <label for="email">E-mail :</label>
        <span class="form_hint">Format attendu "name@something.com"</span>
        <input type="email" class="form-control" name="email" id="email"/><br>

       <label for="mdp1">Mot de passe :</label>
       <input type="password" name="mdp1" pattern="[A-Za-z0-9_]{6,8}" class="form-control" id="mdp1" required pattern="regex" onkeyup="validateMdp2()" title = "Le mot de passe doit contenir de 6 à 8 caractères alphanumériques."/><br>

        <label for="mdp2">Confirmation (Mot de passe) :</label>
        <input type="password" name="mdp2" class="form-control" id="mdp2" required onkeyup="validateMdp2()"/><br>


        <label for="avatar"> Votre photo : </label>
        <input type="file" name="avatar">

        <br>

        <label for="nom">Nom :</label>
        <input type="text" name="nom" class="form-control" id="nom"/><br>

        <label for="prenom">Prenom :</label>
        <input type="text" name="prenom" class="form-control" id="prenom"/><br>

        <label for="sexe">Sexe :</label>
        <div class="radio">
          <label>
            <input type="radio" name="sexe" id="Homme" value="H" checked>
            Homme
          </label>
        </div>
        <div class="radio">
          <label>
            <input type="radio" name="sexe" id="Femme" value="F">
            Femme
          </label>
        </div>
        <br>

        <label for="birthdate">Date de naissance :</label>
        <input type="date" name="birthdate" class="form-control" id="birthdate" onchange="computeAge()" /><br>

        <label for="age">Age:</label>
        <input type="text" name="age" class="form-control" id="age" disabled/><br>

        <label for="sexe">Vous etes un professeur ou un(e) etudiant(e) ? :</label>
        <div class="radio">
          <label>
            <input type="radio" name="statut" id="eleve" value="E" checked>
            Etudiant
          </label>
        </div>
        <div class="radio">
          <label>
            <input type="radio" name="statut" id="professeur" value="P">
            Personnel
          </label>
        </div>
        <br>

        <label for="origine">Quel est votre departement ? </label>
        <input type="text" name="origine" class="form-control" id="origine"/><br>

        <label for="type">Dans quel categorie participez-vous ? :</label>
        <div class="radio">
          <label>
            <input type="radio" name="type" id="coureur" value="C" checked>
            Coureur
          </label>
        </div>
        <div class="radio">
          <label>
            <input type="radio" name="type" id="marcheur" value="M">
            Marcheur
          </label>
        </div>
        <br>
        

        
        <label for="nationalite">Votre pays d'origine :</label>
        <select id="nationalite" name="nationalite"> 
             <?php include('nationalite.php'); ?>
        </select>
        <br>

        <label for="certificat">Certificat de medical :</label>
        <input type="file" name="certificat">
        <br>


       <button type="submit" class="btn btn-success">Inscription</button>
   </div>
</form>
</body>
</html>