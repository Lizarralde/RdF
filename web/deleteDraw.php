<?php
	include 'bdd.php';
	$req = $bdd->exec("DELETE FROM draw WHERE id={$_GET["id"]}") or die (print_r($bdd->errorInfo()));
	header("location: index.php");
	$req->closeCursor();
?>