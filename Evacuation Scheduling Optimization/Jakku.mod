using CP;

int nbNodes = ...;
int nbPaths = ...;

int startEvacuationNodes = ...;
int endEvacuationNodes = ...;

// Evacuation nodes cannot be evacuated after this deadline

int deadline = ...;

range RPaths = 1..nbPaths;

// These are types for the nodes to evacuate

tuple EvacuationNode {
	key int id;
	int demand;
};

{EvacuationNode} EvacuationData = ...;

int demand[n in EvacuationData] = n.demand;

// these are the types for the elements of a path

tuple PathNode {
 	key int id;
 	int tail; 
 	int head;
};

// These are paths for each evacuation nodes
 
{PathNode} Paths[RPaths] = ...;
 
 tuple Edge {
  	key int tail; 
 	key int head;
	int capacity;
 };
 
{Edge} Edges = ...;


tuple PE {
	key int path;
	key int edge;
	int tail;
	int head;
};

{PE} pes; 


execute {
	for(var p in RPaths)
		for(var e in Paths[p])
		    pes.add(p,e.id,e.tail,e.head);	
}
{PE} startNodes = { e | e in pes : e.edge == 0 };

//Output variables
dvar int start[p in pes];
dvar int end[p in pes];
dvar int sizeof[p in pes];
dvar int flow[p in pes];
dvar int evacuees[startNodes];

// dvars 
int max_flow = max(e in Edges: e.tail >= startEvacuationNodes && e.tail <= endEvacuationNodes) e.capacity;
dvar interval evac[p in pes];
cumulFunction func[e in Edges] = sum(p in pes: p.head==e.head && p.tail==e.tail) pulse(evac[p], 0, max_flow);

// objective function 
dexpr int total_evacs = sum(s in startNodes) evacuees[s];
maximize total_evacs;

constraints {  
  
  forall(ordered p1, p2 in pes: p1.path==p2.path)
    flow[p1] == flow[p2];
  forall(ordered p1, p2 in pes: p1.path==p2.path)
    sizeOf(evac[p1]) == sizeOf(evac[p2]);
  forall(ordered p1, p2 in pes: p1.path==p2.path && p2.edge==p1.edge+1)
    {
      start[p2] == start[p1] + 1;
      startAtStart(evac[p1], evac[p2], 1);
    }
  forall(e in Edges)
    func[e]<=e.capacity;     
  forall(p in pes)
    flow[p] == heightAtStart(evac[p], func[<p.tail, p.head>]);       
  forall(s in startNodes)
    evacuees[s]==sizeOf(evac[s])*flow[s];
  forall(s in startNodes)
    evacuees[s]<=demand[<s.path-1>];
        
  forall(s in startNodes)
    endOf(evac[s])<=deadline;
    
  //Output assignments
    forall(p in pes)
    {
    start[p]==startOf(evac[p]);
    end[p]==endOf(evac[p]);
    sizeof[p]==sizeOf(evac[p]);
	}      
}