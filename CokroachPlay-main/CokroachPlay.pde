import processing.sound.*;
ArrayList<Cokroach> coks;
PImage img;
PImage soapImg;
PImage woodBackground;
SoundFile hitSound;
SoundFile backSound; 
int lastSpawnTime = 0;
int score = 0;

PVector hitTextPos;  
int hitTextTimer = 0;  

void setup() { 
  size(800, 800);
  coks = new ArrayList<Cokroach>();
  img = loadImage("kecoa.png");
  soapImg = loadImage("pngwing.com (1).png");
  woodBackground = loadImage("fg.png"); 
  woodBackground.resize(width, height); 
  hitSound = new SoundFile(this, "Ceeeb! Sound Effect (1 second).mp3"); 
  backSound = new SoundFile(this, "Donkey Kong Country Music SNES - Jungle Groove.mp3"); 
  backSound.loop();  
}

void draw() {
  background(woodBackground);
  
  textAlign(CENTER);
  fill(0);  
  textSize(45); 
  text("Rahmanda Purnama", width / 2, height / 2 - 20); 
  textSize(40);  
  text("22.11.5070", width / 2, height / 2 + 20);  
  
  if (millis() - lastSpawnTime >= 3000) {
    float x = random(width);
    float y = random(height);
    coks.add(new Cokroach(img, x, y));
    lastSpawnTime = millis();
  }
  
  for (int i = coks.size() - 1; i >= 0; i--) {
    Cokroach c = coks.get(i);
    c.live();
  }
  
  image(soapImg, mouseX, mouseY, 45, 45); 
  fill(0);  
  textSize(24);  
  text("Score: " + score, 50, 50);  
  
  if (hitTextTimer > 0) {
    fill(255, 0, 0);
    textSize(30);
    text("hit +1", hitTextPos.x, hitTextPos.y);
    hitTextPos.y -= 1; 
    hitTextTimer--; 
  }
  
  fill(#FFFFFF);
  textSize(16);
  textAlign(LEFT);
  text("Kecoak: " + coks.size(), 50, 750);
}



void mouseClicked() {
  for (int i = coks.size() - 1; i >= 0; i--) {
    Cokroach c = coks.get(i);
    if (dist(mouseX, mouseY, c.pos.x, c.pos.y) < 20) { 
      coks.remove(i); 
      hitSound.play(); 
      score++;  

      hitTextPos = new PVector(mouseX, mouseY);
      hitTextTimer = 30; 
      break;
    }
  }
}
