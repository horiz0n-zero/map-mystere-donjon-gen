# map-mystere-donjon-gen
teste : generer une map de facon aléatoire avec un dictionnaire [entier: structure]

# map-mystere

![alt tag](https://drive.google.com/open?id=0B5yn3ZQfHwb1bEFkeWFFUVdFM1E)

un jeu teste écrit en swift avec spritekit visant a générer des donjons aléatoires avec un dictionaire [Entier: structure]

-[ Comment fonctionne la map ? ]-

GameScene.swift -> Initialise le joueur, pose les tiles en fonction de se qui est généré.

une case est parametré par une structure : evenement 

struct evenement {

var character: Character = "x" <br />
    var colonne: Int = 0 <br />
    var ranger: Int = 0 <br />
    var sprites: SKSpriteNode? = nil <br />

}

Par default, chaque case est composé d'herbe mais s'ajoute a celui ci si le characters n'est pas 'x' un obstacle, un objet etc.<br />
On retrouve par consequent le systeme suivant : <br />
m -> grandPlant // obligatoirement poser sur les bords pour empecher le joueur de sortir. <br />
g -> grand arbre <br />
h -> herbe <br />
p -> petit tronc <br />
u -> mousse <br />
c -> caillou <br />
a -> champignon <br />
b -> branchette <br />
<br />
cases specials : <br />
@ -> cle, permet au joueur de passer au niveau suivant <br />
%, £ et - sont des objets collectable pour le joueur et les enemies. <br />
x designe vide <br />
1 et 2 designe des cases occupers par un obstacle dont la texture est plus grande qu'une case. <br />
exemple : <br />

1 1 <br />
g 1 -> grandarbre <br /> 
Note : par default les cases et leur contenues ont un anchor de zero, il est donc inutile de faire ceci : <br />
<br />
1 1 1 <br />
1 g 1 <br />
le bas gauche de l'image sera toujours le point de depart de l'affichage du sprite. <br />
<br />
tile.swift contient toute les fonctions necessaire a la creation d'une map en generant un dictionaire [entier: evenement]<br />
celui ci sera directement traiter dans GameScene.swift qui sauvegardera et affichera le dictionaire.<br />

struct materiel {<br />
// textures ici<br />
}<br />
let texture = materiel() // point d'acces des textures de la map<br />
<br />
la class func genererString() genere le dictionaire<br />
la class func positionner() lis le dictionaire pour retourner un array d'obstacle qui sera traiter dans GameScene.swift<br />
<br />
<br />
-[ Comment fonctionne le joueur et les collisions ? ]- <br />
<br />
le joueur ( player.swift ) herite de l'SKSpriteNode et est conforme au protocol hero { <br />
// pv et sac pour garder des objets  <br />
} <br />
il possede des fonctions d'animation de textures en fonction des touches qui vous faites -> voir : <br />
GameScene.swift <br />
touchesBegan <br />
touchesMoved <br />
touchesEnded <br />
<br />
le joueur ne se deplace jamais, lorsque vous appuyez sur une fleche, les cases alentours sont calculers pour regarder son contenue et ainsi valider le deplacement:<br />
on retrouve ainsi dans la struct de base evenement une ranger et une colonne le dictionaire etablit la cle de chacune de ces cases par la relation suivante :<br />
colonne x 1000 + ranger<br />
<br />
ainsi on peux acceder a la case du joueur lui meme : <br />
let exempleCaseDuJoueur = collection[joueur.colonne x 1000 + joueur.ranger] <br />
// collection est le nom du dictionaire <br />
puis extraire des informations : <br />
print(exempleCaseDuJoueur.character) <br />
// print x par exemple. <br />
Si le mouvement est autorisé ( aucun obstacle ) <br />
la map entiere se deplacera et la colonne et la ranger du joueur ajuster en fonction du mouvement effectuer <br />
<br />
<br />
-[ a quoi serve les enemies ? ]-<br />
<br />
les enemies sont la pour se promener et piquer des objets que vous auriez pu ramasser, ils ne peuvent tenir plus d'un objet, si ils disparaissent l'objet est relacher.<br />
<br />
enemie.swift possede toute les fonctions necessaire au fonctionement d'un enemie il est comparable a celui du joueur.<br />
A chaque fois que vous vous deplacez, les enemies se deplacent aussi, cela est un "tour".<br />
<br />
-[ Mais a quoi sert BlackScene ? ]-<br />
<br />
lorsque votre hero a marché sur la clef, il change de niveau pour cela il appelle BlackScene.swift qui sert de transition.<br />



