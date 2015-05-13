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

        <h1>A vous de jouer ! </h1><br>
        

        <?php
        $id = $_SESSION['identifiant'];
        include 'bdd.php';

        $req = $bdd->prepare("SELECT * FROM draw WHERE id_dest = $id AND id={$_GET["id"]}");
        $req->execute();

        while($data = $req->fetch(PDO::FETCH_OBJ)){
            echo '<article style="float:left;">';
            echo '<img alt="avatar" src="'.$data->dessin.'" id="solution" class="img-rounded" width="300px" height="300px" data-try="1" data-solution="'
            .$data->mot.'"><br>';
            
            ?>
            <br>
            <form method="post" action="" class="form-horizontal">
                <div class="col-lg-2">
                    <div class="input-group">
                      <input type="text" class="form-control" id="proposition" name="proposition" placeholder="Ecrivez une proposition..">
                      <span class="input-group-btn">
                        <button class="btn btn-default" type="button" onClick="CheckRep()">Proposer</button>
                      </span>
                    </div>
                </div>
            </form>

            <?php
            
            echo '</article>';
        }
        ?>

    <footer>
    </footer>
</body>
</html>