//left off at step 14
import de.bezier.guido.*;
private static final int NUM_COLS = 20;
private static final int NUM_ROWS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    //System.out.println(buttons[1][1]);
    for(int r = 0; r < NUM_ROWS; r++)
      for(int c = 0; c < NUM_COLS; c++)
        buttons[r][c] = new MSButton(r, c);
    
    for(int i = 0; i < NUM_ROWS*NUM_COLS/10; i++)
      setMines();
}
public void setMines()
{  
  int row = (int)(Math.random()*NUM_ROWS);
  int col = (int)(Math.random()*NUM_COLS);
  for(int i = 0; i < 5; i++){
    if(!mines.contains(buttons[row][col]))
      mines.add(buttons[row][col]);
  }
  
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    int isWinning = NUM_ROWS *NUM_COLS - mines.size(); //number of buttons that aren't mines
    int count = 0;
    for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++){
          if(!mines.contains(buttons[r][c]) && buttons[r][c].clicked == true){
            count++;
          }
        }
    }
    
    if(count == isWinning){
      return true;
    }else{
      return false;
    }
}
public void displayLosingMessage()
{
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        if(mines.contains(buttons[r][c])){
          buttons[r][c].clicked = true;
        }
      }
    }
    buttons[9][6].setLabel("Y");
    buttons[9][7].setLabel("O");
    buttons[9][8].setLabel("U");
    buttons[9][11].setLabel("L");
    buttons[9][12].setLabel("O");
    buttons[9][13].setLabel("S");
    buttons[9][14].setLabel("E");
    buttons[9][15].setLabel("!");
}
public void displayWinningMessage()
{
    buttons[9][6].setLabel("Y");
    buttons[9][7].setLabel("O");
    buttons[9][8].setLabel("U");
    buttons[9][11].setLabel("W");
    buttons[9][12].setLabel("I");
    buttons[9][13].setLabel("N");
    buttons[9][14].setLabel("!");
    buttons[9][15].setLabel("!");
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        if(mines.contains(buttons[r][c])){
          buttons[r][c].clicked = true;
        }
      }
    }
    noLoop();
}
public boolean isValid(int r, int c)
{
    if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS){
      return true;
    } return false;
}
public int countMines(int row, int col) //step 12
{
    int numMines = 0;
    for(int r = row-1;r<=row+1;r++){
      for(int c = col-1; c<=col+1;c++){
        if(isValid(r,c) && mines.contains(buttons[r][c])){
          numMines++;
        }
      }
    } return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
      clicked = true;  
      if(mouseButton == RIGHT){
          flagged = !flagged;
          if(flagged == false){
             clicked = false;
          }
        }
        else if(mines.contains(this)){
          clicked = true;
          displayLosingMessage();
        } 
        else if(countMines(myRow, myCol) > 0){
          clicked = true;
          myLabel = countMines(myRow, myCol) + "";
        } else {
          clicked = true;
          for(int r = myRow-1;r<=myRow+1;r++){
            for(int c = myCol-1; c<=myCol+1;c++){
              if(isValid(r, c) && buttons[r][c].clicked == false){
                buttons[r][c].mousePressed();
              }
            }
          }
        }
              
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = "" + newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
