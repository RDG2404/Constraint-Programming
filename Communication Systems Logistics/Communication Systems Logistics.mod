/*********************************************
 * OPL 22.1.0.0 Model
 * Author: Admin
 * Creation Date: 19-Sep-2022 at 8:51:02 PM
 *********************************************/
using CP;

int nbControlCenters = ...;
range ControlCenters = 0..nbControlCenters-1;
int nbLocations = ...;
range Locations = 0..nbLocations-1;
int nbTogether = ...;
range RTogether = 1..nbTogether;
{int} Together[RTogether] = ...;
int nbSeparated = ...;
range RSeparated = 1..nbSeparated;
{int} Separated[RSeparated] = ...;
int f[ControlCenters,ControlCenters] = ...;
int hop[Locations,Locations] = ...;

dvar int location[ControlCenters] in Locations;

minimize
  sum(i,j in ControlCenters)(f[i][j]*hop[location[i]][location[j]]); // minimize communications cost

constraints
{
forall(l in Locations)
  sum(c in ControlCenters)(location[c]==l)<=5; // at most 5 control centers per location
  
forall(t in RTogether)
  forall(ordered i,j in Together[t])
    location[i]==location[j]; // together constraint  
    
forall(s in RSeparated)
  forall(ordered i,j in Separated[s])
	location[i]!=location[j]; // separation constraint
}