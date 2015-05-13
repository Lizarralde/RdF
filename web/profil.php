<?php
    session_start();
?>
<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>Application Pictionnary</title>
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

        <h1>Votre profil</h1><br>
        
        <?php
        if(!empty($_SESSION['avatar'])){
            echo '<img alt="avatar" src="'.$_SESSION['avatar'].'" class="img-thumbnail" width="100" height="100"><br>';
        }else{
            echo '<img alt="avatar" src="img/avatar.jpg" class="img-thumbnail"><br>';
        }
        ?>

        <br>
        <form method="post" action="traitement.php" class="form-horizontal">
           <div class="form-group">
            
                <label for="prenom">Prenom :</label>
                <input type="text" name="prenom" class="form-control" id="prenom" value=<?php echo "'".$_SESSION['user']."'";?> disabled /><br>

                <label for="email">E-mail :</label>
                <input type="email" class="form-control" name="email" value=<?php echo "'".$_SESSION['email']."'";?> disabled /><br>

                <label for="numEtudiant">Numéro d'étudiant :</label>
                <input type="text" class="form-control" name="numEtudiant" value=<?php echo "'".$_SESSION['identifiant']."'";?> disabled /><br>

           </div>
        </form>
        <h3>Votre certificat medical : </h3><br>
        <?php
        if(!empty($_SESSION['avatar'])){
            echo '<img alt="avatar" src="'.$_SESSION['certif'].'" class="img-thumbnail" width="200" height="200"><br>';
        }else{
            echo 'Vous n\'avez pas de certificat medical.<br>';
        }
        ?>
    <footer>
    </footer>
</body>
</html>