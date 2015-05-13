validateMdp2 = function(e) {
    var mdp1 = document.getElementById('mdp1');
    var mdp2 = document.getElementById('mdp2');
    if (mdp1.value == mdp2.value) {  
        // ici on supprime le message d'erreur personnalisé, et du coup mdp2 devient valide.
        document.getElementById('mdp2').setCustomValidity('');  
    } else {
        // ici on ajoute un message d'erreur personnalisé, et du coup mdp2 devient invalide.  
        document.getElementById('mdp2').setCustomValidity('Les mots de passes doivent être égaux.');  
    }
}

computeAge = function(e) {  
    try{ 
        //Recuperation des deux dates
        var aujourdhui = new Date(); //date du jour
        var birthdate = document.getElementById('birthdate').value; //date de naissance

        //Recuperation des années
        var annee = birthdate.substr(0,4); // l'année (les quatre premiers caractères de la chaîne à partir de zéro)
        var age = aujourdhui.getFullYear()-annee; // l'âge du joueur

        //Recuperation des mois
        var moisBd = birthdate.substr(5,2);
        var moisTd = aujourdhui.getMonth();

        //Recuperation des jours
        var dayBd = birthdate.substr(9,2);
        var dayTd = aujourdhui.getDate();

        //compare les mois
        if(moisBd > moisTd){
            age = age-1;
            document.getElementById('age').value = age;
        }else{
            document.getElementById('age').value = age;
        }
        /*
        if((moisBd = moisTd) && (dayBd > dayTd)){
            age = age-1;
            document.getElementById('age').value = age;
        }else{
            document.getElementById('age').value = age;
        }
        */
        
    } catch(e) {  
        document.getElementById('age').value = " "; 
    }  
}
loadProfilePic = function (e) {
    // on récupère le canvas où on affichera l'image
    var canvas = document.getElementById("preview");
    var ctx = canvas.getContext("2d");
    // on réinitialise le canvas: on l'efface, et déclare sa largeur et hauteur à 0
    ctx.setFillColor("white");
    ctx.fillRect(0,0,canvas.width,canvas.height);
    canvas.width=0;
    canvas.height=0;
    // on récupérer le fichier: le premier (et seul dans ce cas là) de la liste
    var file = document.getElementById("profilepicfile").files[0];
    // l'élément img va servir à stocker l'image temporairement
    var img = document.createElement("img");
    // l'objet de type FileReader nous permet de lire les données du fichier.
    var reader = new FileReader();
    // on prépare la fonction callback qui sera appelée lorsque l'image sera chargée
    reader.onload = function(e) {
        //on vérifie qu'on a bien téléchargé une image, grâce au mime type
        if (!file.type.match(/image.*/)) {
            // le fichier choisi n'est pas une image: le champs profilepicfile est invalide, et on supprime sa valeur
            document.getElementById("profilepicfile").setCustomValidity("Il faut télécharger une image.");
            document.getElementById("profilepicfile").value = "";
        }
        else {
            // le callback sera appelé par la méthode getAsDataURL, donc le paramètre de callback e est une url qui contient 
            // les données de l'image. On modifie donc la source de l'image pour qu'elle soit égale à cette url
            // on aurait fait différemment si on appelait une autre méthode que getAsDataURL.
            img.src = e.target.result;
            // le champs profilepicfile est valide
            document.getElementById("profilepicfile").setCustomValidity("");
            var MAX_WIDTH = 96;
            var MAX_HEIGHT = 96;
            var width = img.width;
            var height = img.height;

            // A FAIRE: si on garde les deux lignes suivantes, on rétrécit l'image mais elle sera déformée
            // Vous devez supprimer ces lignes, et modifier width et height pour:
            //    - garder les proportions, 
            //    - et que le maximum de width et height soit égal à 96
            var width = MAX_WIDTH;
            var height = MAX_HEIGHT;
            
            canvas.width = width;
            canvas.height = height;
            // on dessine l'image dans le canvas à la position 0,0 (en haut à gauche)
            // et avec une largeur de width et une hauteur de height
            ctx.drawImage(img, 0, 0, width, height);
            // on exporte le contenu du canvas (l'image redimensionnée) sous la forme d'une data url
            var dataurl = canvas.toDataURL("image/png");
            // on donne finalement cette dataurl comme valeur au champs profilepic
            document.getElementById("profilepic").value = dataurl;
        };
    }
    // on charge l'image pour de vrai, lorsque ce sera terminé le callback loadProfilePic sera appelé.
    reader.readAsDataURL(file);
}

function CheckRep() {
    var reponse = document.getElementById('proposition');
    var solution =document.getElementById('solution');
    
    //recup data avec reponse
    var lasolution = solution.getAttribute("data-solution");
    //recup data avec le nombre de coups
    var nbtry = solution.getAttribute("data-nbtry");
    
    if(lasolution == reponse.value){
        console.log('Bien joué ! Vous avez trouvé ');
    }else{
        console.log('NUL');
    }
}

/*
$.ajax({

    method: 'POST',

    dataType: 'json',

    url: 'http://127.0.0.1:8080/rondefac/',

    data: {param1:'topRunner', param2:'1', param3:'ld011429'},
        success: function (code_html, statut) {
        $("#code_html").text(code_html);
        },
    error: function (resultat, statut, erreur) {
        $("#resultat").text(resultat.responseText);
        $("#erreur").text(erreur);
        }
        
});
*/

function checkEleve() {

    var idEleve = document.getElementById('numEtudiant');
    console.log(idEleve.value);

    mail = 'mail@mail.fr';
    diplomep = 'B';
    givenName = 'Paul';
    sn = 'Pierre';

    document.getElementById('email').value = mail;
    document.getElementById('origine').value = diplomep;
    document.getElementById('nom').value = givenName;
    document.getElementById('prenom').value = sn;

}

