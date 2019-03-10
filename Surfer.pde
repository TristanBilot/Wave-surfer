import android.content.Context;
import android.os.Vibrator;
//import processing.sound.*;
//SoundFile file;

/* Background */
PImage bImg = null;
/* Joueur */
PImage sprite = null;
/* Bouton Replay */
PImage buttonReplay = null;
/* Label perdu */
PImage loseLabel = null;

/* Position de départ du background */
float x = 0;
/* Vitesse de défilement du monde */
float vitesse = 1;
/* Force verticale */
float gravite = 2; 
/* Force horizontale (sens opposé) */
float vent = 0.4;
/* Placement de départ du perso (ordonnées) */
float ySprite = 0;
/* Placement de départ du perso (abscisses) */
float xSprite; // (width / 2)

/* Vitesse sans accélération des obsctales */
int vitesseInitialeObjets = 3;
/* Compteur de score */
int distanceCounter = 0;
/* Etat de la partie */
Boolean perdu = false;

Boolean keyUp = false;
Boolean keyDown = false;
Boolean keyRight = false;
Boolean keyLeft = false;

/* Le generateur d'obstacles */
Generateur generateur;
/* Le vibreur */
Vibrator vibrator;
 
void setup(){
  orientation(LANDSCAPE);
  //size(2400,800);
  bImg = loadImage("test.png"); 
  bImg.resize(2000, 500);
  xSprite = width / 2;
  sprite = loadImage("personnage.png");
  generateur = new Generateur(height, width);
  vibrator = (Vibrator) getContext().getSystemService(Context.VIBRATOR_SERVICE);
  
  // Load a soundfile from the /data folder of the sketch and play it back
  //file = new SoundFile(this, "sample.mp3");
  //file.play();
}

void draw(){
  accelerationEnFonctionDuTemps();
  background(255);
  image(bImg,x,0);
  play();
}
 
void play(){
  /* Le background */
  background(255);
  image(bImg,x,0);
  /* Placement du perso */
  image(sprite, xSprite, ySprite);
  
  if (!perdu) {
    /* Incrémentation du score */
    distanceCounter += 1;  
    /* Mouvement de gauche a droite */
    x -= vitesse; 
    /* Recommencer au début de l'image à sa fin */
    x %= width;  
    /* Gravité */
    ySprite += gravite;
    /* Force horizontale */
    xSprite -= vent;
    /* Gère les clicks */
    clickManager();
    //update(); pour dekstop uniquement
    addObstacle();
    /* Applique le vent à tous les obstacles */
    checkVitesseObstacles();
    /* création des images à chaque boucle */
    afficherObstacles();
    /* Check si le user a touché un obstacle */
    checkIfLose();
    /* Incrémentation du compteur */
    updateCounter();
    /* On élimine la mémoire inutilisée */
    liberationMemoire();
  }
  else { /* PERDU */
    textSize(32);
    text(distanceCounter, 20, 40);
    buttonReplay = loadImage("REPLAY.png");
    loseLabel = loadImage("lose.png");
    //file.stop();
    image(buttonReplay, width / 2 - (248 / 2), height / 2 - (78 / 2), 248, 78);
    image(loseLabel, width / 2 - (253 / 2), height / 2 - 180, 253, 37);
    //file.stop();
    if(mousePressed==true ){
       reset();
     }
  }
}

void accelerationEnFonctionDuTemps() {
   /* A chaque gap de 500, on accélère les projectiles */
  if (distanceCounter % 500 == 0)
    vitesseInitialeObjets += 1; 
}

/* à chaque tour de boucle, il faut réafficher tous les éléments */
void checkVitesseObstacles() {
  for (Obstacle o: generateur.getObstacles()) {
    o.setX(o.getX() - o.vitesse);
  }
}

void clickManager() {
  /* Principe: en fonction de la position du clic et du sprite, on détermine la direction 
     à emprunter. Le coefficiant fixe est une valeur minimum de mouvement, le coefficiant 
     est en relation avec la distance entre le point cliqué et la position du Sprite. On aura donc 
     une vitesse plus importante lorsque le clic est éloigné du sprite.
     Abs permet de ne pas avoir de valeur négative (incohérence de placements)
   */
   if (mousePressed == true) {
     float coeffAccel = 300; // + il est grand, moins d'accel
     float coeffFixe = 3; // vitesse minimum
     /* Distance entre le clic et le sprite */
     float dist = dist(mouseX, mouseY, xSprite, ySprite);
     
     /* GAUCHE */
     if (mouseX < xSprite) xSprite -= coeffFixe + abs(dist / coeffAccel);
     /* DROITE */
     if (mouseX > xSprite) xSprite += coeffFixe + abs(dist / coeffAccel);
     /* HAUT */
     if (mouseY < ySprite) ySprite -= coeffFixe + gravite + abs(dist / coeffAccel);
     /* BAS */
     if (mouseY > ySprite) ySprite += coeffFixe + abs(dist / coeffAccel);
   }
}

void addObstacle() {
  /* 1 obstacle sur 40 */
  int randomSpawn = floor(random(1, 40));
  /* sélection aléatoire d'un numéro */
  if (randomSpawn == 5) {
    /* affichage */
    Obstacle o = generateur.genererObstacle();
    /* Certains obstacles iront plus vites que d'autres */
    int randomVitesse = floor(random(1, 40));
    /* Une petite partie seulement le sera */
    if (randomVitesse <= 7)
    /* Augmentation de la vitesse */
      o.vitesse = vitesseInitialeObjets + 2;
    else
    /* Vitesse initiale */
      o.vitesse = vitesseInitialeObjets;
    image(o.getImage(), o.getX(), o.getY());
  }
}

void afficherObstacles() {
  for (Obstacle o: generateur.getObstacles()) {
    image(o.getImage(), o.getX(), o.getY());
  }
}

void updateCounter() {
  textSize(32);
  text(distanceCounter, 20, 40);
}

void checkIfLose() {
   for (Obstacle o: generateur.getObstacles()) {
    /* Regarder la distance entre la position du sprite et l'obstacles */
     if (dist(xSprite, ySprite, o.getX(), o.getY()) <= 40){
       perdu = true;
       
        //vibrator.vibrate(100);// intensité de la vibration 
     }
   }
   if (xSprite <= 0)
     perdu = true;
   if (ySprite >= height)
     perdu = true;
}

void liberationMemoire() {
  /* Lorsqu'un obstacle sort de la dimension de l'écran (sur la gauche)
    il faut supprimer les objets car ils sont inutilisés et la place
    mémoire sera vite saturée 
  */
    for (Obstacle o: generateur.getObstacles()) {
       if (o.getX() < -50) // a gauche de l'écran
         o = null;
    }
}

void loose() {
  /* On stop toutes les forces éxercées */
   vitesse = 0;
   gravite = 0;
   vent = 0;
   vitesseInitialeObjets = 0;
   perdu = true;
}

/*
  A l'appui, modification des axes
*/
void update() {
  /* Monter */
  /* Cette valeur doit être > à la gravité */
  if (keyUp) ySprite -= 5; 
  /* Descendre */
  if (keyDown) ySprite += 2;
  /* Droite */
  if (keyRight) xSprite += 2; 
  /* Gauche */
  if (keyLeft) xSprite -= 2;
}

void reset(){  
  perdu = false;
  distanceCounter = 0;
  x = 0;
  /* Vitesse de défilement du monde */
  vitesse = 1;
  gravite = 2; 
  vent = 0.4;
  ySprite = 0;
  vitesseInitialeObjets = 3;
  generateur = new Generateur(height, width);
  //file.play();
}
  
  
/* ---- MODE DESKTOP ---- */
/*
  Dès que la touche est appuyée, on modifie l'axe x,y
*/
 void keyPressed() {
  if ( keyCode == UP ) keyUp = true;
  if ( keyCode == DOWN ) keyDown = true;
  if ( keyCode == RIGHT ) keyRight = true;
  if ( keyCode == LEFT ) keyLeft = true;
}

/*
  Au relachement de la touche, on arrête le mouvement
*/
void keyReleased() { 
  if ( keyCode == UP ) keyUp = false;
  if ( keyCode == DOWN ) keyDown = false;
  if ( keyCode == RIGHT ) keyRight = false;
  if ( keyCode == LEFT ) keyLeft = false; 
}
