/*********************************************
 * OPL 22.1.0.0 Model
 * Author: Admin
 * Creation Date: 21-Oct-2022 at 8:54:44 PM
 *********************************************/
using CP;

int nbSites = ...;
int nbVehicles = ...;
int capacity = ...;
//
range Sites = 0..nbSites-1;
tuple Site {
   int demand;
   int x;
   int y;
};
Site siteData[Sites] = ...;

 execute { 
       cp.param.timeLimit = 300;
}


int nbLocations = nbVehicles + nbSites - 1;
range Locations = 1..nbLocations;
range Depots = 1..nbVehicles;
range Customers = (nbVehicles + 1)..nbLocations;
Site data[l in Locations] = (l <= nbVehicles) ? siteData[0] : siteData[l-nbVehicles];

int dist[i in Locations,j in Locations] = 
   ftoi(round(sqrt((data[i].x - data[j].x)^2 + (data[i].y - data[j].y)^2)));
  
int maxDistance=sum(ordered i,j in Locations)dist[i,j];
int minDistance=min(ordered i,j in Locations)dist[i,j];
int demand_o[i in 1..nbSites-1]=siteData[i].demand;
int demand[Customers]=all[Customers](i in 1..nbSites-1)demand_o[i]; //repack 

dvar int pred[Locations] in Locations; //predecessor visits
dvar int next[Locations] in Locations; //successor visits
dvar int vehicle[Customers] in Depots; //vehicles visiting customers
dvar int arrival_time[Locations] in minDistance..maxDistance; //arrival time for each location
dvar int seq[Locations] in Locations; //sequence for circuit
dvar int load[Depots] in 0..capacity; //load of vehicles 


dexpr int f1=max(l in Locations)arrival_time[l];
dexpr int f2=sum(l in Locations)dist[l,next[l]];

minimize staticLex(f1,f2);


constraints{
  pack(load,vehicle,demand);
  
  //constraint 1: vehicle constraint
  forall(c in Customers)
    vehicle[pred[c]]==vehicle[c];
    
  //constraint 2: vehicle start constraint
  forall(d in Depots)
    arrival_time[d]==0;
    
  //constraint 3: time constraint
  forall(c in Customers)
    arrival_time[c]==arrival_time[pred[c]]+dist[pred[c],c];
    
  //constraint 4: pred[c], succ[c] linkage
  forall(c in Customers)
  	pred[next[c]]==c;  
  	
  //constraint 5: circuit constraint
  seq[1]==next[1];
  seq[nbLocations]==1;
  forall(c in 2..nbLocations)
    seq[c]==next[seq[c-1]];
  
  allDifferent(next);
  allDifferent(seq);
}