using CP;

int nbPeriods= ...;
int minCourses= ...; /* minimum amount of courses necessary per period */
int maxCourses= ...; /* maximum amount of courses allowed per period */
int minUnit= ...; /* minimum number of units units necessary per period */
int maxUnit= ...; /* maximum number of units allowed per period */

{string} Courses = ...;

int unit[Courses] = ...;

tuple prec {
  string before;
  string after;
}

{prec} Prerequisites = ...;
range Periods = 1..nbPeriods;

dvar int period[Courses] in Periods; // decision variable - periods to be assigned to every course

/*minimize
  sum(c in Courses)or(p in Periods)(period[c]==p); // objective function: minimize the maximum number of courses taken during each period
*/
minimize
  max(p in Periods)sum(c in Courses)(period[c]==p);
constraints{
  
  forall(p in Prerequisites){ //pre-requisites need to be done earlier
    period[p.before]<period[p.after]; 
  }
  
  forall(p in Periods){ // course constraint
    (sum(c in Courses)(period[c] == p))>=minCourses;
    (sum(c in Courses)(period[c] == p))<=maxCourses;
  }    
  
  forall(p in Periods){ // unit constraint
      (sum(c in Courses) unit[c]*(period[c]==p))>=minUnit;
      (sum(c in Courses) unit[c]*(period[c]==p))<=maxUnit;
    }
   
}
/*********************************************
 * OPL 22.1.0.0 Model
 * Author: Admin
 * Creation Date: 14-Sep-2022 at 9:12:27 PM
 *********************************************/
