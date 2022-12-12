/*********************************************
 * OPL 22.1.0.0 Model
 * Author: Admin
 * Creation Date: 23-Oct-2022 at 3:46:33 PM
 *********************************************/
using CP;

int nbResidents = ...;
int minPatients = ...;
int maxPatients = ...;
int maxLoad = ...;
range Residents = 1..nbResidents;
int nbPatients = ...;
range Patients = 1..nbPatients;

tuple PatientData {
  int load;
  int zone;
}

PatientData patientData[Patients] = ...;

// time-limit of 5 minutes + inference level extensions					       
 execute { 
       cp.param.timeLimit = 300;
       cp.param.ElementInferenceLevel="Extended";
       cp.param.CountInferenceLevel="Extended";
}

int load_residents[p in Patients]=patientData[p].load;
dvar int residents[Patients] in Residents;
dvar int exists[Residents][Patients] in 0..1; // Following lex approach, will create required 0..1 matrix to show assignments
dvar int load[Residents] in min(p in Patients)load_residents[p]..maxLoad;
{int} residentPatients[Residents];


minimize 
max(r in Residents)load[r] - min(r in Residents)load[r];

constraints{

   pack(load, residents, load_residents);
  
   forall(r in Residents)
     minPatients <= count(residents,r) <= maxPatients; // count constraint
     
    forall(ordered i,j in Patients: patientData[i].zone!=patientData[j].zone)
      residents[i]!=residents[j]; // zone constraint
    
   forall(r in Residents, p in Patients)
	exists[r][p]==(residents[p]==r); // fills in the matrix
   
   forall(r in 1..nbResidents-1)
     lex(all(p in Patients) exists[r][p], all(p in Patients)exists[r+1][p]); // lexicographical constraint
   
}
 
 execute{
   for(var r in Residents){
     for (var p in Patients){
       if (residents[p]==r)
       residentPatients[r].add(p);
     }
   }
   writeln(residentPatients);
 }