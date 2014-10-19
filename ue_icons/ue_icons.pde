// Unconquered Earth
// svg shapes for data
// 18 Oct. 2014

PShape dead, homeless, injured, date, magnitude;
int w = width;
int h = height;
void setup() {
  size(800, 800);

  dead = loadShape("dead.svg");
  homeless = loadShape("homeless.svg");
  injured = loadShape("injured.svg");
  date = loadShape("date.svg");
  magnitude = loadShape("magnitude.svg");
}

void draw() {
shapeMode(CENTER);
  int index = key;
  background(0);
  switch (index) {
  case '1':
    shape(dead, mouseX, mouseY, mouseY, mouseY);
    break;
  case '2':
    shape(homeless, mouseX, mouseY, mouseY, mouseY);
    break;
  case '3':
    shape(injured, mouseX, mouseY, mouseY, mouseY);
    break;
  case '4':
    shape(date, mouseX, mouseY, mouseY, mouseY);
    break;
  case '5':
    shape(magnitude, mouseX, mouseY, mouseY, mouseY);
    break;
  }
}

