class Obstacle {
  private PImage image;
  private float x;
  private float y;
  public int vitesse;
  /* A la création, l'obstacle n'est pas sensible à la gravité et au vent */
  private boolean isUnderGravity;
  
  public Obstacle(PImage img, int x, int y) {
    this.image = img;
    this.x = x;
    this.y = y;
    this.isUnderGravity = false;
  }
  
  public PImage getImage() {
   return image; 
  }
  
  public float getX() {
   return x; 
  }
  
  public float getY() {
   return y; 
  }
  
  public boolean isUnderGravity() {
   return isUnderGravity; 
  }
  
  public void setX(float x) {
   this.x = x;
  }
  
  public void setY(float y) {
   this.y = y;
  }
  
  public void setGravity(boolean isUnderGravity) {
   this.isUnderGravity = isUnderGravity;
  }
}
