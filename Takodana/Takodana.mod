/*********************************************
 * OPL 22.1.0.0 Model
 * Author: Admin
 * Creation Date: 31-Oct-2022 at 6:41:02 PM
 *********************************************/

/*
Problem Description:

The resistance is building houses on Takodana. Each house has a number
of tasks linked by precedence constraints and a release date dictated
by when the material arrives. There are earliness and tardiness costs
associated with some tasks of each house. Each task has a fixed
duration. The goal is to minimize the sum of the tardiness costs,
while making sure that the earliness costs do not exceed the value
maxEarlinessCost. Can you help the resistance?
*/

 using CP;

{string} Tasks = ...;
int nbHouses  = ...;
range Houses = 1..nbHouses;
int duration[Tasks] =  ...;
int releaseDate[Houses] = ...;
tuple Prec { string before; string after; };

{Prec} Precedences = ...;

tuple Deadline { string t; int date; float cost; };
{Deadline} Earliness = ...;
{Deadline} Tardiness = ...;
int maxEarlinessCost = ...;
//{int} startDate[Houses, Tasks]; //required output

dvar interval task[h in Houses, t in Tasks] size duration[t];
dvar int startDate[Houses, Tasks];

minimize sum(h in Houses, d in Tardiness)d.cost*maxl(0, endOf(task[h,d.t])-d.date);

constraints{
  forall(h in Houses, t in Tasks)
    startDate[h,t]==startOf(task[h,t]);
    
  forall(h in Houses, t in Tasks)
    startOf(task[h,t])>=releaseDate[h]; //tasks can only be started once material arrives for each house
    
  forall(h in Houses, p in Precedences)
    endBeforeStart(task[h,p.before], task[h,p.after]); //precceding tasks must be completed first
  
  sum(h in Houses, d in Earliness)d.cost*maxl(0, d.date-startOf(task[h,d.t]))<=maxEarlinessCost; //earliness costs must be less than threshold
}

//execute{
//  for(var h in Houses){
//    for(var t in Tasks){
//      startDate[h,t].add[startOf(task[h,t])]
//    }
//  }
//  writeln(startDate)
//}