/*********************************************
 * OPL 22.1.0.0 Model
 * Author: Admin
 * Creation Date: 05-Oct-2022 at 1:24:32 PM
 *********************************************/
using CP;

int nbCompetitors = 14;

range FS = 0..1;

range Days = 1..nbCompetitors-1;

range Tracks = 1..ftoi(nbCompetitors/2);

range Competitors = 1..nbCompetitors;

// time-limit of 10 minutes					       
 execute { 
       cp.param.timeLimit = 600;
}

// decision variable "competitors" has indices - Days, Track Number and Starting Position (left-0/Right-1)
dvar int competitors[Days,Tracks,FS] in Competitors; 
dvar int track[Competitors, Days] in Tracks;
  
constraints{
  
competitors[1,1,0]==1;
competitors[1,1,1]==2;

// constraint 1: Competitors race once a day
forall(d in Days)
  allDifferent(all(t in Tracks, pos in FS)competitors[d,t,pos]);
  
// constraint 2: Competitor can race on same track at most 2 times
forall(c in Competitors)
	forall(t in Tracks)
 	 count(all(d in Days, pos in FS)competitors[d,t,pos],c)<=2;
 	 
// constraint 3: Competitors cannot start at either positions more than the specified number of times
forall(c in Competitors)
	forall(pos in FS)
  	 count(all(d in Days, t in Tracks)competitors[d,t,pos],c)<=(nbCompetitors-1)/2+1;

// constraint 4: competitors should be competing with all other competitors
forall(ordered c1,c2 in Competitors)
   sum(d in Days)(track[c1,d]==track[c2,d])<=1;
   
forall(c in Competitors, d in Days, t in Tracks, pos in FS)
 competitors[d,t,pos]==c=>track[c,d]==t;
 }


