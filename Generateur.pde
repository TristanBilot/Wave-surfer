
class Generateur {
  private ArrayList<Obstacle> obstacles;
  private int heightJeu;
  private int widthJeu;
  
  public Generateur(int heightJeu, int widthJeu) {
    obstacles = new ArrayList();
    this.heightJeu = heightJeu;
    this.widthJeu = widthJeu;
  }  
  
  public synchronized Obstacle genererObstacle() {
    int random = floor(random(1, 3));
    int randomY = floor(random(1, heightJeu)); // enlever le ground      
    int positionApparission = widthJeu + 50 ; // a droite de l'écran
    PImage randomImg = null;
  
    switch(random) {
      case 1:
        randomImg = loadImage("missile.png");
        break;
       case 2:
         randomImg = loadImage("missile2.png");
         break;
      default:
       break;
    }
    Obstacle o = new Obstacle(randomImg, positionApparission, randomY);
    obstacles.add(o);
    return o;
  }
  
  public synchronized ArrayList<Obstacle> getObstacles() {
    return obstacles;
  }
}
