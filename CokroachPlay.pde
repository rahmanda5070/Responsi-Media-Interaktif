import processing.sound.*;
ArrayList<Cokroach> coks;
PImage img;
PImage soapImg;
PImage hammerImg; // Gambar palu
PImage woodBackground;
SoundFile hitSound;
SoundFile backSound;
int lastSpawnTime = 0;
int score = 0;

PVector hitTextPos;
int hitTextTimer = 0;

// Variabel untuk memilih senjata
boolean useHammer = false;

// Variabel animasi palu
float hammerAngle = 0;      // Sudut rotasi palu
boolean hammerSwing = false; // Apakah palu sedang diayunkan
int hammerSwingTimer = 0;    // Timer untuk mengatur animasi ayunan palu

void setup() {
  size(800, 800);
  coks = new ArrayList<Cokroach>();
  img = loadImage("kecoa.png");
  soapImg = loadImage("pngwing.com (1).png");
  hammerImg = loadImage("pngwing.com (2).png"); // Load gambar palu
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
  
  // Spawning kecoak setiap 3 detik
  if (millis() - lastSpawnTime >= 3000) {
    float x = random(width);
    float y = random(height);
    coks.add(new Cokroach(img, x, y));
    lastSpawnTime = millis();
  }
  
  // Menggerakkan dan menggambar kecoak
  for (int i = coks.size() - 1; i >= 0; i--) {
    Cokroach c = coks.get(i);
    c.live();
  }

  // Menampilkan senjata saat ini (sabun atau palu) dengan animasi
  if (useHammer) {
    pushMatrix();
    translate(mouseX, mouseY);

    if (hammerSwing) {
      rotate(radians(hammerAngle)); // Rotasi palu saat sedang diayunkan
      hammerAngle += 10; // Menambah sudut rotasi

      // Jika sudah mencapai sudut tertentu, hentikan ayunan
      if (hammerAngle > 45) {
        hammerSwing = false;
        hammerAngle = 0; // Reset sudut rotasi
      }
    }

    imageMode(CENTER);
    image(hammerImg, 0, 0, 80, 80); // Gambar palu
    popMatrix();
  } else {
    image(soapImg, mouseX, mouseY, 45, 45); // Gambar sabun
  }

  // Menampilkan skor
  fill(0);
  textSize(24);
  text("Score: " + score, 50, 50);

  // Menampilkan teks "hit +1" saat kecoa ditekan
  if (hitTextTimer > 0) {
    fill(255, 0, 0);
    textSize(30);
    text("hit +1", hitTextPos.x, hitTextPos.y);
    hitTextPos.y -= 1;
    hitTextTimer--;
  }

  // Menampilkan jumlah kecoak di layar
  fill(#FFFFFF);
  textSize(16);
  textAlign(LEFT);
  text("Kecoak: " + coks.size(), 50, 750);

  // Menampilkan tombol pilihan senjata di bawah layar
  drawWeaponSwitch();
}

// Fungsi untuk menggambar tombol pilihan senjata
void drawWeaponSwitch() {
  int buttonWidth = 50;
  int buttonHeight = 50;
  int soapButtonX = width - 180;
  int soapButtonY = height - buttonHeight - 20;
  int hammerButtonX = width - 80;
  int hammerButtonY = height - buttonHeight - 20;
  
  // Menggambar tombol Sabun
  fill(useHammer ? 200 : 255);
  rect(soapButtonX, soapButtonY, buttonWidth, buttonHeight, 10);
  image(soapImg, soapButtonX + (buttonWidth / 2) - 22.5, soapButtonY + 20, 45, 45);
  fill(0);
  text("Sabun", soapButtonX + buttonWidth / 2, soapButtonY + buttonHeight - 5);
  
  // Menggambar tombol Palu
  fill(useHammer ? 255 : 200);
  rect(hammerButtonX, hammerButtonY, buttonWidth, buttonHeight, 10);
  image(hammerImg, hammerButtonX + (buttonWidth / 1.2) - 40, hammerButtonY + 10, 80, 80);
  fill(0);
  text("Palu", hammerButtonX + buttonWidth / 2, hammerButtonY + buttonHeight - 5);
}

// Fungsi untuk beralih senjata saat tombol dipilih
void mousePressed() {
  int buttonWidth = 100;
  int buttonHeight = 100;
  int soapButtonX = width - 180;
  int soapButtonY = height - buttonHeight - 20;
  int hammerButtonX = width - 80;
  int hammerButtonY = height - buttonHeight - 20;

  // Deteksi klik pada tombol sabun
  if (mouseX > soapButtonX && mouseX < soapButtonX + buttonWidth &&
      mouseY > soapButtonY && mouseY < soapButtonY + buttonHeight) {
    useHammer = false;
  }

  // Deteksi klik pada tombol palu
  if (mouseX > hammerButtonX && mouseX < hammerButtonX + buttonWidth &&
      mouseY > hammerButtonY && mouseY < hammerButtonY + buttonHeight) {
    useHammer = true;
  }
}

// Fungsi mouseClicked untuk menghitung skor saat kecoa ditekan
void mouseClicked() {
  if (useHammer) {
    hammerSwing = true; // Aktifkan animasi ayunan palu
    hammerAngle = -30;  // Mulai dengan sudut mundur
  }

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
