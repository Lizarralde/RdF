<header><h1><img alt="Brand" src="img/logo.png">Ronde des facs</h1><br></header>
<nav>
    <ul class="nav nav-tabs">
		<li role="presentation"><a href="index.php"><span class="glyphicon glyphicon-home"></span> Home</a></li>
		<?php
		if(!empty($_SESSION['user'])){
			echo '<li role="User"><a href="profil.php"><span class="glyphicon glyphicon-user"> </span> '.$_SESSION['user'].'</a></li>';
			echo '<li role="kpi"><a href="kpi.php"><span class="glyphicon glyphicon-stats"> </span> Statistiques </a></li>';
			echo '<li role="classement"><a href="classement.php"><span class="glyphicon glyphicon-list"> </span> Classement </a></li>';
			echo '<li role="logout"><a href="logout.php"><span class="glyphicon glyphicon-off"> </span> Deconnexion</a></li>';
		}else{
			echo '<li role="inscription"><a href="inscription.php"><span class="glyphicon glyphicon-pencil"></span> Inscription</a></li>';
			echo '<li role="connexion"><a href="connexion.php"> <span class="glyphicon glyphicon-user"> </span> Connexion</a></li>';
			echo '<li role="classement"><a href="classement.php"><span class="glyphicon glyphicon-list"> </span> Classement </a></li>';
		}
		?>
		
    </ul>
</nav>
<br>