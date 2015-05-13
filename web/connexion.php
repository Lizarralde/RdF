<?php

//initialisation du message d'erreur
$erreur = '';

if(!empty($_SESSION['user'])){
 header('Location: index.php');
}

if(!empty($_POST)){

  extract($_POST);
    
  $valid=true;


  try{
    include 'bdd.php';
    $bdd->exec('SET NAMES utf8');
  }
  catch(Exeption $e){
    die('Erreur:'.$e->getMessage());
  }

  $email = $_POST['email'];
  $password = $_POST['mdp'];

  $req = $bdd->prepare('SELECT * FROM participant WHERE PART_EMAIL=:email AND PART_MOTDEPASSE=:password');
  $req->execute(array('email'=>$email, 'password'=>$password));
  $result = $req->fetch(PDO::FETCH_ASSOC);
  if(!empty($email) && !empty($password)){
    if($req->rowCount()==0){
      $valid=false;
      $erreur = '<div class="alert alert-danger" role="alert">
                  <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
                  <span class="sr-only">Erreur:</span>
                  Vos identifiants sont incorrects.
                </div>';
    }
  }else{
    $valid=false;
  }
   
  if($valid){
    session_start();
    $_SESSION['user'] = $result['PART_PRENOM'];
    $_SESSION['nom'] = $result['PART_NOM'];
    $_SESSION['email'] = $result['PART_EMAIL'];
    $_SESSION['identifiant'] = $result['PART_IDETUDIANT'];
    $_SESSION['avatar'] = 'img/avatar/'.$result['PART_AVATAR'];
    $_SESSION['certif'] = 'img/certif/'.$result['PART_CERTIFICATMED'];
    header('Location: index.php');
  }
 
}
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
<h1>Connexion</h1><br>
<form method="post" action="" class="form-horizontal">
   <div class="form-group">

        <label for="email">E-mail :</label>
        <span class="form_hint">Format attendu "name@something.com"</span>
        <input type="email" class="form-control" name="email" id="email" required autofocus/><br>

       <label for="mdp">Mot de passe :</label>
       <input type="password" name="mdp" class="form-control" id="mdp"  title = "Le mot de passe doit contenir de 6 à 8 caractères alphanumériques." required/><br>

       <button type="submit" class="btn btn-success">Connexion</button>
   </div>
</form>
<?php 
  if(!empty($_POST)){
    echo $erreur;
  } 
?>
</body>
</html>