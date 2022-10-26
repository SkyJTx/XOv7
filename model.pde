class Model{
    int[][] grid = new int[3][3];
    int turn = 1;
    int move = 0;
    int ngrid = 3;
    float scale;
    float gridscale;
    boolean win = false;
    boolean hint = false;
    boolean tie = false;
    Table save;
    Controller c;
    Model(Controller c,int n){
        this.ngrid = n;
        this.c = c;
        this.grid = new int[n][n];
        
    }
       
    int getTurn(){ // send turn value
        return this.turn;
    }
    
    int getMove(){ // send move value
        return this.move;
    }
    
    int getPos(int i,int j){ // send xo identification value at grid[i][j]
        return grid[i][j];
    }
    
    int horizontalchk(int i){ // send i-th horizontal sum of identification value
        int j = 0;
        int sum = 0;
        while (j < this.ngrid){
            sum = sum + grid[i][j];
            j = j + 1;
        }
        return sum;
    }
    
    int verticalchk(int j){ // send i-th vertical sum of identification value
        int i = 0;
        int sum = 0;
        while (i < this.ngrid){
           sum = sum + grid[i][j];
           i = i + 1;
        }
        return sum;
    }
    
    int upcrosschk(){ // send upper cross sum of identification value
        int i = 0;
        int sum = 0;
        while (i < this.ngrid){
           sum = sum + grid[i][i];
            i = i + 1;
        }
        return sum;
    }
    
    int downcrosschk(){ // send lower cross sum of identification value
        int i = 0;
        int sum = 0;
        while (i < this.ngrid){
           sum = sum + grid[i][this.ngrid-1-i];
            i = i + 1;
        }
        return sum;
    }
    
    boolean checkwin(){ // win condition check
        int i = 0;
        int score = this.ngrid; // score is needed to be ngrid to win (X or O is occupying ngrid continuous grid)
        while (i < this.ngrid){
            if (abs(horizontalchk(i)) == score || abs(verticalchk(i)) == score || abs(upcrosschk()) == score || abs(downcrosschk()) == score){
                return true;
            }
            i = i + 1;
        }
        return false;
    }
    
    void updatewin(){
        this.win = checkwin();
    }
    
    boolean checkhint(){ // hint condition check
        int i = 0;
        int score = this.ngrid-1; // score is needed to be ngrid-1 to give a hint (X or O is occupying ngrid-1 continuous grid)
        while (i < this.ngrid){
            if (abs(horizontalchk(i)) == score || abs(verticalchk(i)) == score || abs(upcrosschk()) == score || abs(downcrosschk()) == score){
                return true;
            }
            i = i + 1;
        }
        return false;
    }
    
    void updatehint(){
        this.hint = checkhint();
    }
    
    boolean checktie(){ // tie condition check
        if (this.move == this.ngrid*this.ngrid && !this.win){ // move is needed to be ngrid^2 (X or O is fully occupying all grid) and still not win
            return true;
        }
        return false;
    }
    
    void updatetie(){
        this.tie = checktie();
    }
    
    void storegrid(int i,int j){
        grid[i][j] = this.turn;
    }
    
    void changeturn(){
        this.turn = -this.turn;
    }
    
    void reset(){
        this.grid = new int[this.ngrid][this.ngrid];
        this.turn = 1;
        this.move = 0;
        this.win = false;
        this.hint = false;
        this.tie = false;
        setup();
    }
    
    void savegame(){
        this.save = new Table(); //create new table for saving
        this.save.addColumn("XO Position"); //for array grid
        this.save.addColumn("Turn"); //for integer turn
        this.save.addColumn("Move"); // for integer move
        TableRow addRow = this.save.addRow(); //create row for saving
        addRow.setInt("Turn",this.turn); // add turn to column "Turn"
        addRow.setInt("Move",this.move); // add move to column "Move"
        int i = 0; 
        int j = 0;
        while (i < this.ngrid){
            j = 0;
            while (j < this.ngrid){
                addRow.setInt("XO Position",this.grid[i][j]); // add grid at [i][j] to column "XO Position"
                addRow = this.save.addRow(); // New Row
                j = j + 1;
            }
            i = i + 1;
        }
        saveTable(this.save,"save.csv"); //save as a "save.csv" file to game dir
    }
    
    void loadgame(){
        this.save = loadTable("save.csv","header"); //select "save.csv" as a load file
        int i = 0;
        int j = 0;
        int rowpos = 0;
        for (TableRow row : this.save.rows()){ //  start/next row
            if (rowpos == 0){
                this.turn = row.getInt("Turn"); // load turn
                this.move = row.getInt("Move"); // load move
            }
            if (i > this.ngrid-1){
                i = 0;
                j = j + 1;
                if (j > this.ngrid-1){
                    break;
                }
            }
            this.grid[j][i] = row.getInt("XO Position"); // load XO Position to array grid
            i = i + 1;
            rowpos = rowpos + 1;
        }
    }
    
    void process(){
        updatewin();
        updatetie();
        updatehint(); 
    }
}
