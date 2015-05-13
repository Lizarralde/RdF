<?php

// récupérer les éléments du formulaire
$numEtudiant=stripslashes($_POST['numEtudiant']);
$email=stripslashes($_POST['email']);
$password=stripslashes($_POST['mdp1']);
$nom=stripslashes($_POST['nom']);
$prenom=stripslashes($_POST['prenom']);
$sexe='';
if (array_key_exists('sexe',$_POST)) {
    $sexe=stripslashes($_POST['sexe']);
}
$birthdate=stripslashes($_POST['birthdate']);
$nationalite=stripslashes($_POST['nationalite']);
$origine=stripslashes($_POST['origine']);

$statut=stripslashes($_POST['statut']);
$type=stripslashes($_POST['type']);

$certificat = $_FILES['certificat'];
$certificatName = $certificat['name'];

$photo = $_FILES['avatar'];
$photoName = $photo['name'];


//////////////////////////
////  UPLOAD D'IMAGE  ////
//////////////////////////


//!\\ UPLOAD AVATAR //!\\
$success = FALSE;
if(!empty($_FILES))
{
    $avatar = $_FILES['avatar'];
    $avatar_name = $avatar['name'];
    $ext = strtolower(substr(strrchr($avatar_name,'.'),1));
    $ext_aut = array('jpg','jpeg','png','gif');

    function check_extension($ext,$ext_aut)
    {
      if(in_array($ext,$ext_aut))
      {
        return true;
      }
    }

    $valid = (!check_extension($ext,$ext_aut)) ? false : true;
    $erreur = (!check_extension($ext,$ext_aut)) ? 'Veuillez charger une image' : '';

    if($valid)
    {
      $max_size = 2000000;
      if($avatar['size']>$max_size)
      {
        $valid = FALSE;
        $erreur = 'Fichier trop gros';
      }
    }

    if($valid)
    {
      if($avatar['error']>0)
      {
        $valid = FALSE;
        $erreur = 'Erreur lors du transfert';
      }
    }

    if($valid)
    {
      $path_to_image = 'img/avatar/';
      
      $filename = stripslashes($_POST['numEtudiant']);
      
      $source = $avatar['tmp_name'];
      $target = $path_to_image . $filename. '.'. $ext;
      
      move_uploaded_file($source,$target);
      
      $nomImage = $filename.'.'.$ext;
      
      $success = TRUE;
    }
}
$photo = $nomImage;

//!\\ UPLOAD AVATAR //!\\
$success = FALSE;
if(!empty($_FILES))
{
    $avatar = $_FILES['certificat'];
    $avatar_name = $avatar['name'];
    $ext = strtolower(substr(strrchr($avatar_name,'.'),1));
    $ext_aut = array('jpg','jpeg','png','gif');

    function check_ext($ext,$ext_aut)
    {
      if(in_array($ext,$ext_aut))
      {
        return true;
      }
    }

    $valid = (!check_extension($ext,$ext_aut)) ? false : true;
    $erreur = (!check_extension($ext,$ext_aut)) ? 'Veuillez charger une image' : '';

    if($valid)
    {
      $max_size = 2000000;
      if($avatar['size']>$max_size)
      {
        $valid = FALSE;
        $erreur = 'Fichier trop gros';
      }
    }

    if($valid)
    {
      if($avatar['error']>0)
      {
        $valid = FALSE;
        $erreur = 'Erreur lors du transfert';
      }
    }

    if($valid)
    {
      $path_to_image = 'img/certif/';
      
      $filename = stripslashes($_POST['numEtudiant']);
      
      $source = $avatar['tmp_name'];
      $target = $path_to_image . $filename. '.'. $ext;
      
      move_uploaded_file($source,$target);
      
      $nomCertif = $filename.'.'.$ext;
      
      $success = TRUE;
    }
}

$certificat = $nomCertif;


try {
    // Connect to server and select database.
    include 'bdd.php';


        // Tenter d'inscrire l'utilisateur dans la base
        $sql = $bdd->prepare("INSERT INTO participant (PART_IDETUDIANT, PART_EMAIL, PART_MOTDEPASSE, PART_NOM, PART_PRENOM, PART_SEXE, 
                            PART_DATENAISSANCE, PART_CERTIFICATMED, PART_STATUT, PART_TYPE, PART_NATIONALITE, PART_ORIGINE, PART_AVATAR)
                            VALUES (:numEtudiant, :email, :password, :nom, :prenom, :sexe, :birthdate, :certificat, :statut, :type, 
                            :nationalite, :origine, :avatar)");
            
            $sql->bindValue(":numEtudiant", $numEtudiant);
            $sql->bindValue(":email", $email);
            $sql->bindValue(":password", $password);
            $sql->bindValue(":nom", $nom);
            $sql->bindValue(":prenom", $prenom);
            $sql->bindValue(":sexe", $sexe);
            $sql->bindValue(":birthdate", $birthdate);
            $sql->bindValue(":certificat", $certificat);
            $sql->bindValue(":statut", $statut);
            $sql->bindValue(":type", $type);
            $sql->bindValue(":nationalite", $nationalite);
            $sql->bindValue(":origine", $origine);
            $sql->bindValue(":avatar", $photo);
            
        
        // on tente d'exécuter la requête SQL, si la méthode renvoie faux alors une erreur a été rencontrée.
        if (!$sql->execute()) {
            echo "PDO::errorInfo():<br/>";
            $err = $sql->errorInfo();
            print_r($err);
        } else {

            session_start();

            $req = $bdd->prepare('SELECT * FROM participant WHERE PART_IDETUDIANT=:numEtudiant');
            $req->execute(array('numEtudiant'=>$numEtudiant));
            $result = $req->fetch(PDO::FETCH_ASSOC);

            if(!empty($result)){
                $_SESSION['user'] = $result['PART_PRENOM'];
                $_SESSION['nom'] = $result['PART_NOM'];
                $_SESSION['email'] = $result['PART_EMAIL'];
                $_SESSION['identifiant'] = $result['PART_IDETUDIANT'];
                $_SESSION['avatar'] = 'img/avatar/'.$result['PART_AVATAR'];
                $_SESSION['certif'] = 'img/certif/'.$result['PART_CERTIFICATMED'];
                header('Location: index.php');
            }else{
                header('Location: connexion.php');
            }
        }
        $bdd = null;

}catch (PDOException $e){
    print "Erreur !: " . $e->getMessage() . "<br/>";
    $bdd = null;
    die();
}

?>