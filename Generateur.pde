
class Generateur {
  private ArrayList<Obstacle> obstacles;
  private int heightJeu;
  private int widthJeu;
  
  public Generateur(int heightJeu, int widthJeu) {
    obstacles = new ArrayList();
    this.heightJeu = heightJeu;
    this.widthJeu = widthJeu;
  }  
  
  public Obstacle genererObstacle() {
    int random = floor(random(1, 5));
    int randomY = floor(random(1, heightJeu)); // enlever le ground
      
    int positionApparission = widthJeu + 50 ; // a droite de l'écran
    PImage randomImg = null;
    
    random = 1; // a enlever
    switch(random) {
      case 1:
        randomImg = loadImage("personnage.png");
        break;
        
      default:
       break;
    }
    Obstacle o = new Obstacle(randomImg, positionApparission, randomY);
    print(positionApparission);
    print(randomY);
    obstacles.add(o);
    return o;
  }
  
  public ArrayList<Obstacle> getObstacles() {
    return obstacles;
  }
}
