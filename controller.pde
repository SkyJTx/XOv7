class Controller{
    int xcoor;
    int ycoor;
    int i;
    int j;
    int ngrid;
    float gridscale;
    float scale;
    Model m;
    Controller(Model m,float screen_width){
        this.m = m;
        this.ngrid = m.ngrid;
        this.gridscale = screen_width/m.ngrid;
        this.scale = screen_width/3;
    }
    
    int calJ(){
        this.j = floor(this.xcoor/this.gridscale);
        return this.j;
    }
    
    int calI(){
        this.i = floor((this.ycoor-this.scale/2)/this.gridscale);
        return this.i;
    }
    
    boolean isOccupied(){
        if (m.getPos(this.i,this.j) != 0){ //no occupation at i,j
            return true;
        }
        else{
            return false;
        }
    }
    
    boolean inGrid(){ // mouse position in grid checking method
        if ((calJ() >= 0 && calJ() <= this.ngrid-1) && (calI() >= 0 && calI() <= this.ngrid-1)){
            return true;
        }
        else{
            return false;
        }
    }
    
    boolean inBox(float x,float y,float sizeX,float sizeY){ // mouse position in assigned box checking method
        if ((this.xcoor > x && this.xcoor < x+sizeX) && (this.ycoor > y && this.ycoor < y+sizeY)){
            return true;
        }
        else{
            return false;
        }
    }
    
    boolean inSave_endLoad_inGame(){ // check if mouse position is in button "Save"(inGame) or "Load"(GameEnd)
        return inBox(this.scale*0.25,3*this.scale+2*this.scale/3,this.scale/2,this.scale/4);
    }

    boolean inLoad_inGame(){ // check if mouse position is in button "Load"(inGame)
        return inBox(this.scale*1.25,3*this.scale+2*this.scale/3,this.scale/2,this.scale/4);
    }

    boolean inReset_inGame(){ // check if mouse position is in button "Reset"(inGame) or "Start"(GameEnd)
        return inBox(this.scale*2.25,3*this.scale+2*this.scale/3,this.scale/2,this.scale/4);
    }
    
    void press(int posX,int posY){
        this.xcoor = posX;
        this.ycoor = posY;
        this.i = calI();
        this.j = calJ();
        if ( !( m.checkwin() || m.checktie() ) ){
            if ( inGrid() ){
                if ( m.turn == 1 && !isOccupied() ){
                    m.move = m.move + 1;
                    m.storegrid(i,j);
                    m.changeturn();
                }
                else{
                    if ( m.turn == -1 && !isOccupied() ){
                        m.move = m.move + 1;
                        m.storegrid(i,j);
                        m.changeturn();
                    }
                }
            }
            if ( inSave_endLoad_inGame() ){
                m.savegame();
            }
            if ( inLoad_inGame() ){
                m.loadgame();
            }
            if ( inReset_inGame() ){
                m.reset();
                
            }
        }
        if ( m.checkwin() || m.checktie() ){
            if ( inSave_endLoad_inGame() ){
                m.loadgame();
            }
            if ( inReset_inGame() ){
                m.reset();
                
            }
        }
    }
    
}
