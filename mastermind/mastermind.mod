/*********************************************
 * OPL 22.1.0.0 Model
 * Author: Admin
 * Creation Date: 21-Oct-2022 at 2:51:02 AM
 *********************************************/
using CP;

int nbColors = 6;
range Colors = 1..nbColors;
int nbPositions = 4;
range Positions = 1..nbPositions;
int nbGuesses = ...;
range GuessRange = 1..nbGuesses;
 
int guess[GuessRange,Positions] = ...;
 
int nbCorrectAwards[GuessRange] = ...;
int nbIncorrectAwards[GuessRange] = ...;
 
dvar int code[Positions] in Colors;
dvar int ntimes_col[GuessRange, Colors] in Positions; // number of times each color appears in each guess

constraints{
  // constraint 1: collects number of times each color appears in guess
 forall(g in GuessRange, c in Colors)
   ntimes_col[g,c]==sum(p in Positions)(guess[g,p]==c);
   
  // constraint 2: correct awards constraint
  forall(g in GuessRange)
    sum(p in Positions)(code[p]==guess[g,p])==nbCorrectAwards[g];
    
  // constraint 3: incorrect awards constraints
  forall(g in GuessRange)
    forall(i in Positions, j in Positions)
      (i!=j) => sum(p in Positions)(code[i]==guess[g,j])-(ntimes_col[g,code[i]]-1)==nbIncorrectAwards[g];
      
   
}