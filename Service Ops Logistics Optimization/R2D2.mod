/*********************************************
 * OPL 22.1.0.0 Model
 * Author: Admin
 * Creation Date: 07-Nov-2022 at 4:53:32 PM
 *********************************************/
using CP;
int nbStations = ...;
range Stations = 1..nbStations;
tuple stationData {
int service;
int start;
int end;
};
stationData data[Stations] = ...;
int time[Stations,Stations] = ...;

dvar int nextStation[Stations];							//output 1
dvar int serviceTime[Stations];							//output 2

dvar interval service[s in Stations] in data[s].start..(data[s].end+data[s].service) size data[s].service;
dvar sequence droid in service types all(s in Stations)s;

tuple stationJumpTime {int loc1; int loc2; int dist;};
{stationJumpTime} jumpTime={<i, j, time[i,j]> | i in Stations, j in Stations};
 
minimize sum(s in Stations) time[s, nextStation[s]];

constraints{
  
  forall(s in Stations)
    serviceTime[s]==startOf(service[s]); 				//collects start of service times per station
  
  forall(s in Stations)
    nextStation[s]==typeOfNext(droid, service[s], 1); 	//collects next station serviced by the bot
    
  forall(s in Stations)
    data[s].start<=startOf(service[s])<=data[s].end; 	//service has to start within the service start window
  
  noOverlap(droid, jumpTime); 							// no overlap declaration
  	
  typeOfNext(droid, service[10], 1)!=11; 				//droid cannot travel from station 10 - station 11
  
  first(droid, service[1]); 							//droid services station 1 first
  

  
   

}