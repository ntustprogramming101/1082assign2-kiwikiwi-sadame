PImage life, bg, soil, soldier, cabbage;
PImage groundhogIdle, groundhogDown, groundhogLeft, groundhogRight;
PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;

final int LIFE_X       = 10;
final int LIFE_Y       = 10;
final int LIFE_SPACE   = 20;
final int LIFE_W       = 50;
final int LIFE_ST_N    = 2;
int lifeN              = LIFE_ST_N;

final float GRID_LENGTH  = 80;

final float SKY_H        = GRID_LENGTH*2;
final float SOIL_W       = GRID_LENGTH*8;
final float SOIL_H       = GRID_LENGTH*4;
final float GRASS_H      = 15;
final float SUN_X        = 640-50;        
final float SUN_Y        = 50;         
final float SUN_R        = 120;

final float GROUNDHOG_W  = 80;
final float GROUNDHOG_H  = 80;
final float GROUNDHOG_ST_X  = GRID_LENGTH*4;
final float GROUNDHOG_ST_Y  = SKY_H-GRID_LENGTH;
float groundhogX = GROUNDHOG_ST_X;
float groundhogY = GROUNDHOG_ST_Y;

int groundhogState = 0;
final int STAY     = 0;
final int GO_DOWN  = 1;
final int GO_LEFT  = 2;
final int GO_RIGHT = 3;

final float CABBAGE_W = 80;
final float CABBAGE_H = 80;
float cabbageX = (int)random(8)*GRID_LENGTH;
float cabbageY = (int)random(4)*GRID_LENGTH + SKY_H;
final boolean EATEN = false;
boolean cabbageState = true;

float soldierX = 0;
float soldierY = (int)random(4) * GRID_LENGTH + SKY_H;
final float soldierSpeed = 5;
final float SOLDIER_W    = 80;
final float SOLDIER_H    = 80;

final int BUTTON_X = 248;
final int BUTTON_Y = 360;
final int BUTTON_W = 144;
final int BUTTON_H = 60;

int gameState = 0;
final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_LOSE = 2;

boolean downPressed  = false;
boolean leftPressed  = false;
boolean rightPressed = false;

int frame = 0;

void setup() {
  size(640, 480, P2D);
  frameRate(60);
  //pictures
  bg             = loadImage("img/bg.jpg");
  soil           = loadImage("img/soil.png");
  life           = loadImage("img/life.png");
  soldier        = loadImage("img/soldier.png");
  cabbage        = loadImage("img/cabbage.png");
  groundhogIdle  = loadImage("img/groundhogIdle.png");
  groundhogDown  = loadImage("img/groundhogDown.png");
  groundhogLeft  = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  title          = loadImage("img/title.jpg");
  gameover       = loadImage("img/gameover.jpg");
  startNormal    = loadImage("img/startNormal.png");
  startHovered   = loadImage("img/startHovered.png");
  restartNormal  = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");

}

void draw() {

  // Switch Game State
  switch (gameState){
    // Game Start
    case GAME_START:
      image(title,0,0);
      if (mouseX>BUTTON_X && mouseX<BUTTON_X+BUTTON_W && mouseY>BUTTON_Y && mouseY<BUTTON_Y+BUTTON_H){
        image(startHovered, BUTTON_X, BUTTON_Y);
        if (mousePressed == true){
          gameState = GAME_RUN;
        }
      }
      else {
        image(startNormal, BUTTON_X, BUTTON_Y);
      }
      break;
    // Game Run
    case GAME_RUN:
      // background
      image(bg,0,0);
      
      // sun
      fill(253,184,19);
      stroke(255,255,0);
      strokeWeight(5);
      ellipse(SUN_X, SUN_Y, SUN_R, SUN_R);
      
      // grass
      fill(124,204,25);
      noStroke();
      rectMode(CORNER);
      rect(0, SKY_H-GRASS_H, width, GRASS_H);
      
      // soil
        image(soil, 0, SKY_H, SOIL_W, SOIL_H);

      // life
      for (int i=0; i<lifeN; i++){    
        image(life, LIFE_X+(LIFE_W+LIFE_SPACE)*i, LIFE_Y);
      }

      // groundhog motion
      switch (groundhogState){
        
        case STAY:  
          image(groundhogIdle, groundhogX, groundhogY);         
          if (downPressed)  groundhogState = GO_DOWN;          
          if (leftPressed)  groundhogState = GO_LEFT;          
          if (rightPressed) groundhogState = GO_RIGHT;
          
          // debug
          if (downPressed) println(groundhogY, soldierY);
          if (leftPressed) println(groundhogX);
          if (rightPressed) println(groundhogX);
          
          break;
          
        case GO_DOWN:
          image(groundhogDown, groundhogX, groundhogY);
          if (frame < 15 && groundhogY < height-GROUNDHOG_H){
            groundhogY += GRID_LENGTH/15; 
            frame ++;
          }
          else groundhogState = STAY;
          
          if (frame == 15){
            frame = 0;  // avoid frame hasn't become 15
            groundhogState = STAY;  
            groundhogY = round(groundhogY);  // avoid the problem of indivisible - GRID_LENGTH/15
          }               
          break;
          
        case GO_LEFT:
          image(groundhogLeft, groundhogX, groundhogY);
          if (frame < 15 && groundhogX > 0){
            groundhogX -= (float)GRID_LENGTH/15; 
            frame ++;
          }
          else groundhogState = STAY;
          
          if (frame == 15){
            frame = 0;
            groundhogState = STAY;
            groundhogX = round(groundhogX);
          }     
          break;
          
        case GO_RIGHT:
          image(groundhogRight, groundhogX, groundhogY);
          if (frame < 15 && groundhogX < width-GROUNDHOG_W){
            groundhogX += GRID_LENGTH/15; 
            frame ++;
          }
          else groundhogState = STAY;
          
          if (frame == 15){
            frame = 0;
            groundhogState = STAY;
            groundhogX = round(groundhogX);            
          }     
          break;
          
        default:
          println("error_groundhogState");
          break;      
      }

      // soldier
      soldierX += soldierSpeed;
      if (soldierX >= width) soldierX = -SOLDIER_W;
      image(soldier, soldierX, soldierY, SOLDIER_W, SOLDIER_H);
      
      // eat cabbage      
      if (groundhogX+GROUNDHOG_W>cabbageX && groundhogX<cabbageX+CABBAGE_W){
        if (groundhogY+GROUNDHOG_H>cabbageY && groundhogY<cabbageY+CABBAGE_H){
          if (cabbageState != EATEN){
            lifeN ++;
          }
          cabbageState = EATEN;
        }
      }
      if (cabbageState != EATEN){
        image(cabbage, cabbageX, cabbageY);   
      }
          
      // soilder attack groundhog
      if (groundhogX+GROUNDHOG_W>soldierX && groundhogX<soldierX+SOLDIER_W){
        if (groundhogY+GROUNDHOG_H>soldierY && groundhogY<soldierY+SOLDIER_H){
          groundhogX = GROUNDHOG_ST_X;  // back to the start XY
          groundhogY = GROUNDHOG_ST_Y;
          lifeN --;  
          
          frame = 0;  // avoid when attacked frame hasn't become 15 
          downPressed = false;  // avoid getting back it still in moving
          leftPressed = false;
          rightPressed = false;
           
          groundhogState = STAY;
        }     
      }
      
      // life become zero
      if (lifeN == 0){
        gameState = GAME_LOSE;
      }
    
      break;
      
      
    // Game Lose
    case GAME_LOSE:
      image(gameover, 0, 0);
      if (mouseX>BUTTON_X && mouseX<BUTTON_X+BUTTON_W && mouseY>BUTTON_Y && mouseY<BUTTON_Y+BUTTON_H){
        image(restartHovered, BUTTON_X, BUTTON_Y);
        if (mousePressed == true){         
          lifeN = LIFE_ST_N;
          groundhogX = GROUNDHOG_ST_X;
          groundhogY = GROUNDHOG_ST_Y;
          cabbageX = (int)random(8)*GRID_LENGTH;
          cabbageY = (int)random(4)*GRID_LENGTH + SKY_H;
          soldierY = (int)random(4) * GRID_LENGTH + SKY_H;  
          frame    = 0;  // same as above
          gameState = GAME_RUN;
        }
      }
      else {
        image(restartNormal, BUTTON_X, BUTTON_Y);
      }
      break;  
      
    default:
      println("error_gameState switch");
      break;     
  }
}

void keyPressed(){
  if (key == CODED){  
    switch (keyCode){
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
      default:
        println("error_keyPressed");
        break;
    }
  }
}

void keyReleased(){
  if (key == CODED){  
    switch (keyCode){
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
      default:
        println("error_keyReleased");
        break;
    }
  }
}
