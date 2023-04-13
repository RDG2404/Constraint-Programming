/*********************************************
 * OPL 22.1.0.0 Model
 * Author: Admin
 * Creation Date: 31-Aug-2022 at 8:23:34 PM
 *********************************************/
using CP;
{string} Letters = {"D", "O", "N", "A", "L", "G", "E", "R", "B","T"};
dvar int value[Letters] in 0..9;
dvar int carry[1..5] in 0..1;

constraints{
  forall (ordered i, j in Letters)
    value[i]!=value[j];
  value["D"]!=0;
  value["G"]!=0;
  value["R"]!=0;
  
  carry[5] + value["D"] + value["G"] == value["R"]; 
  carry[4] + value["O"] + value["E"] == value["O"] + 10*carry[5];
  carry[3] + value["N"] + value["R"] == value["B"] + 10*carry[4];
  carry[2] + value["A"] + value["A"] == value["E"] + 10*carry[3];
  carry[1] + value["L"] + value["L"] == value["R"] + 10*carry[2];
             value["D"] + value["D"] == value["T"] + 10*carry[1];
}