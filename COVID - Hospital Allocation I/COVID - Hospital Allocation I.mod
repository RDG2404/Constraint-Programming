/*********************************************
 * OPL 22.1.0.0 Model
 * Author: Admin
 * Creation Date: 25-Sep-2022 at 3:35:08 PM
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

// time-limit of 5 minutes					       
 execute { 
       cp.param.timeLimit = 300;
}

dvar int residents[Patients] in Residents;
{int} residentPatients[Residents];

minimize
  max(r in Residents)sum(p in Patients)(patientData[p].load)*(residents[p]==r) - min(r in Residents)sum(p in Patients)(patientData[p].load)*(residents[p]==r);
  
constraints{
   forall(r in Residents)
     minPatients <= count(residents,r) <= maxPatients; // count constraint
     
   forall(r in Residents)
     sum(p in Patients)(residents[p]==r)*patientData[p].load <=maxLoad;// load constraint
    
   forall(r in Residents)
     forall(ordered i,j in Patients)
       (residents[i]==r)*(residents[j]==r)*patientData[i].zone == (residents[i]==r)*(residents[j]==r)*patientData[j].zone; // zone constraint
       
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