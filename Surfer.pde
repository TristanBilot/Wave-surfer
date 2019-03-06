PImage bImg = null;
PImage sprite = null;
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

Boolean keyUp = false;
Boolean keyDown = false;
Boolean keyRight = false;
Boolean keyLeft = false;

Generateur generateur; 
 
void setup(){
  orientation(LANDSCAPE);
  //size(2400,800);// 2400, 800
  bImg = loadImage("landscape.png"); 
  bImg.resize(2048, 204);
  xSprite = width / 2;
  sprite = loadImage("personnage.png");
  generateur = new Generateur(height, width);
}
 
void draw(){
  /* Le background */
  background(255);
  image(bImg,x,0);
  /* Placement du perso */
  image(sprite, xSprite, ySprite);
  /* Mouvement de gauche a droite */
  x -= vitesse; 
  /* Recommencer au début de l'image à sa fin */
  x %= width;  
  /* Gravité */
  ySprite += gravite;
  /* Force horizontale */
  xSprite -= vent;
  
  /*  Rendre le sol dur  */
  if (ySprite >= (height - 100))  // height - 100 : ground
    ySprite = height - 100;
   
  clickManager();
  //update(); pour dekstop uniquement
  addObstacle();
  checkGraviteObstacles();
  afficherObstacles();
}

void checkGraviteObstacles() {
  for (Obstacle o: generateur.getObstacles()) {
    o.setX(o.getX() - vent - 3);
    //o.setY(o.getY() + gravite + 5);
  }
}

void clickManager() {
   if (mousePressed == true) {
     if (mouseX < width / 2) xSprite -= 5;
     if (mouseX >= width / 2) xSprite += 5;
     if (mouseY < height / 2) ySprite -= 5;
   } 
}

void addObstacle() {
  int randomSpawn = floor(random(1, 40));
  if (randomSpawn == 5) {
    Obstacle o = generateur.genererObstacle();
    image(o.getImage(), o.getX(), o.getY());
  }
}

void afficherObstacles() {
  for (Obstacle o: generateur.getObstacles()) {
    image(o.getImage(), o.getX(), o.getY());
  }
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
  
