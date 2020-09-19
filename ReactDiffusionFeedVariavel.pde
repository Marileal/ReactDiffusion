// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for this video: https://youtu.be/BV9ny785UNc

// Written entirely based on
// http://www.karlsims.com/rd.html

// Also, for reference
// http://hg.postspectacular.com/toxiclibs/src/44d9932dbc9f9c69a170643e2d459f449562b750/src.sim/toxi/sim/grayscott/GrayScott.java?at=default

Cell[][] grid;
Cell[][] prev;
PImage imagem;

void setup() {
  size(800, 428);
  grid = new Cell[width][height];
  prev = new Cell[width][height];

  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j ++) {
      float a = 1;
      float b = 0;
      grid[i][j] = new Cell(a, b);
      prev[i][j] = new Cell(a, b);
    }
  }
  
   imagem = loadImage("canvasPletoraWhite.png");
  //onde se faz os pontos de reação aparecerem
  
  for (int i = 0; i < imagem.width; i++){
    for (int j = 0; j < imagem.height; j++) {
      color c = imagem.pixels[i + j * width];
          if(brightness(c) < 128 ){
            float a = 0;
            float b = 1;
            grid[i][j] = new Cell(a, b);
            prev[i][j] = new Cell(a, b);
          }
       }
    }
  }

float dA = 1.0;
float dB = .4;
float feed;
float k;
//float feed = 0.04;
//float k = 0.061;
float addFeed;

//color azul = color(20, 87, 255);
//color semiCyan = color(202, 218, 189);
//color cyan = color(112, 247, 251);
//color amarelinho = color(235, 255, 166);
//color salmon = color(255, 111, 144);
//color amarelo = color(250, 178, 60);
//color vermelho = color(255, 41, 106);
//color salmon2 = color (246, 93, 150);
//color azul2 = color(199, 1, 200);

class Cell {
  float a;
  float b;

  Cell(float a_, float b_) {
    a = a_;
    b = b_;
  }
}


void update() {
  for (int i = 1; i < width-1; i++) {
    for (int j = 1; j < height-1; j ++) {
      Cell spot = prev[i][j];
      Cell newspot = grid[i][j];

      float a = spot.a;
      float b = spot.b;

      float laplaceA = 0;
      laplaceA += a*-1;
      laplaceA += prev[i+1][j].a*0.2;
      laplaceA += prev[i-1][j].a*0.2;
      laplaceA += prev[i][j+1].a*0.2;
      laplaceA += prev[i][j-1].a*0.2;
      laplaceA += prev[i-1][j-1].a*0.05;
      laplaceA += prev[i+1][j-1].a*0.05;
      laplaceA += prev[i-1][j+1].a*0.05;
      laplaceA += prev[i+1][j+1].a*0.05;

      float laplaceB = 0;
      laplaceB += b*-1;
      laplaceB += prev[i+1][j].b*0.2;
      laplaceB += prev[i-1][j].b*0.2;
      laplaceB += prev[i][j+1].b*0.2;
      laplaceB += prev[i][j-1].b*0.2;
      laplaceB += prev[i-1][j-1].b*0.05;
      laplaceB += prev[i+1][j-1].b*0.05;
      laplaceB += prev[i-1][j+1].b*0.05;
      laplaceB += prev[i+1][j+1].b*0.05;
      
      //talvez inserir aqui o momento em que feed e kill mudam de valor 
      //baseado nas cores dos pixels?
      //color c = imagem.pixels[i + j * width];
      //if(i <= width / 2){
      //feed = 0.078;
      //k = 0.061;
      //}
      
      //if(width / 2 < i){
      //feed = 0.047;
      //k = 0.065;
      //}
      
      //if( width * 2 / 5 < i <= width * 3 / 5){
      //feed = 0.078;
      //k = 0.061;
      //}
      
      //if(width * 3 / 5 < i <= width * 4 / 5){
      //feed = 0.029;
      //k = 0.057;
      //}
      
      //if(width * 4 / 5 < i < width){
      //feed = 0.014;
      //k = 0.045;
      //}
      
      
      feed = map(mouseX, 0, width, 0.037, 0.08);
      k = map (mouseY, 0, height, 0.05, 0.068);
      //if (feed >= 0.08) feed = 0.04;
      
      newspot.a = a + (dA*laplaceA - a*b*b + feed*(1-a))*1;
      newspot.b = b + (dB*laplaceB + a*b*b - (k+feed)*b)*1;

      //println("este é o feed " + feed);
      newspot.a = constrain(newspot.a, 0, 1);
      newspot.b = constrain(newspot.b, 0, 1);
    }
  }
}

void swap() {
  Cell[][] temp = prev;
  prev = grid;
  grid = temp;
}

void draw() {
  //println(frameRate);

  for (int i = 0; i < 1; i++) {
    update();
    swap();
  }

  loadPixels();
  for (int i = 1; i < width-1; i++) {
    for (int j = 1; j < height-1; j ++) {
      Cell spot = grid[i][j];
      float a = spot.a;
      float b = spot.b;
      int pos = i + j * width;
      pixels[pos] = color((1.5*a-b)*255);
    }
  }
  updatePixels();
  if (frameCount % 20 == 0) saveFrame("RDfeedVariavel######.png");
}

//void keyPressed() {
//  if(key == 's') saveFrame("RD######.png");
//}
