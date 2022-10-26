Controller c;
Model m;
View v;

void setup(){
    size(600,800);
    m = new Model(c,3);
    c = new Controller(m,600);
    v = new View(m,c);
}

void mousePressed(){
    c.press(mouseX,mouseY);
    m.process();
}

void draw(){
    v.show();
}
