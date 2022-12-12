/*********************************************
 * OPL 22.1.0.0 Model
 * Author: Admin
 * Creation Date: 16-Nov-2022 at 4:58:03 PM
 *********************************************/
using CP;
int nbPlanets = ...;
range Planets = 0..nbPlanets-1;
int nbFighters = ...;
range Fighters = 1..nbFighters;
int capacity = ...;
int nbReliefPlanets = nbPlanets-1;
range ReliefPlanets = 1..nbReliefPlanets;
range fighter_loads=0..capacity;
tuple Site {
int demand;
int x;
int y;
};
Site siteData[Planets] = ...;

int distance[i in Planets, j in Planets] = ftoi(round(sqrt((siteData[i].x-siteData[j].x)^2 + (siteData[i].y - siteData[j].y)^2)));
int demand[r in ReliefPlanets] = siteData[r].demand;
dvar interval path_visits[Planets, Fighters] optional size 0;
dvar interval loc[r in ReliefPlanets] size 0;
dvar sequence fighterSeq[f in Fighters] in all(p in Planets) path_visits[p,f] types all(p in Planets)p;
dvar int planet_fighter[ReliefPlanets, Fighters] in 0..1;
dvar int assign[ReliefPlanets] in Fighters;
dvar int load[Fighters] in fighter_loads;
cumulFunction fighter_demand[f in Fighters] = sum(p in Planets) stepAtStart(path_visits[p,f], siteData[p].demand);

tuple tuple_1{int loc1; int loc2; int dist;};
{tuple_1} travTime ={<i,j, distance[i,j]>| i in Planets, j in Planets};

dexpr int total_dist = sum(f in Fighters, p in Planets) distance[p, typeOfNext(fighterSeq[f], path_visits[p,f], 0, p)];
dexpr int max_dist = max(f in Fighters, p in Planets) endOf(path_visits[p,f]);

execute{
  cp.param.AllDiffInferenceLevel = "Extended";
  cp.param.ElementInferenceLevel = "Extended";
  cp.param.IntervalSequenceInferenceLevel = "Extended";
  cp.param.NoOverlapInferenceLevel = "Extended";
  cp.param.PrecedenceInferenceLevel = "Extended";
  cp.param.CumulFunctionInferenceLevel = "Extended";
  cp.param.SearchType = 25;
  var f = cp.factory;
  cp.setSearchPhases(f.searchPhase(load, f.selectLargest(f.domainSize()), f.selectSmallest(f.valueImpact())), f.searchPhase(fighterSeq));
}

// Lexicographical Objective Function
minimize staticLex(max_dist, total_dist);

constraints{
  
  pack(load, assign, demand);
  
  forall(f in Fighters)
  {
    first(fighterSeq[f], path_visits[0,f]);
    fighter_demand[f]<=capacity;
    noOverlap(fighterSeq[f], travTime);
    noOverlap(all(r in ReliefPlanets) path_visits[r,f]);
    presenceOf(path_visits[0,f])==1;
  }    
  
   forall(f in Fighters, r in ReliefPlanets)
  {
    planet_fighter[r,f]==(assign[r]==f);
  	presenceOf(path_visits[r,f]) ==1 => assign[r]==f;
  }  
  
  forall(r in ReliefPlanets)
    alternative(loc[r], all(f in Fighters) path_visits[r,f]); 
  
  forall(f in Fighters, p in Planets)
    typeOfNext(fighterSeq[f], path_visits[p,f], 0)!=p;
        
  forall(f in 1..nbFighters-1)
    lex(all(r in ReliefPlanets) planet_fighter[r,f], all(r in ReliefPlanets) planet_fighter [r, f+1]);
    
}

tuple Task{
  int reliefPlanet;
  key int distance;
}
sorted {Task} vt[f in Fighters] = {<p, endOf(path_visits[p,f])> | p in Planets: presenceOf(path_visits[p,f])==1};

execute{
  for (var f in Fighters){
    writeln("Solution for Fighter ",f,":", vt[f]);
  }
}