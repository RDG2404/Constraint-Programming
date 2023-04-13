/*********************************************
 * OPL 22.1.0.0 Model
 * Author: Admin
 * Creation Date: 05-Sep-2022 at 10:44:47 PM
 *********************************************/
using CP;


// given variables
{string} Jobs = { "painter", "diplomat", "violinist", "doctor", "sculptor" };
{string} Animals = {"dog", "zebra", "fox", "snail", "horse" };
{string} Drinks = { "juice", "water", "tea", "coffee", "milk" };
{string} Nationality = {"English", "Spaniard", "Japanese", "Italian", "Norwegian"};
{string} Colors = {"red", "green", "white", "yellow", "blue"};

// initializing arrays

range D=0..4; // Given number of houses
dvar int nationality[Nationality] in D;
dvar int color[Colors] in D;
dvar int job[Jobs] in D; // equivalent to jobHouse[Jobs] as given in question, shortened for simplicity
dvar int animal[Animals] in D;
dvar int drink[Drinks] in D;

/* op arrays
int jobHouse[Jobs];
int animalHouse[Animals];
int drinkHouse[Drinks];*/

// applying constraints
constraints{
  
forall (ordered i, j in Nationality) // So that house numbers don't repeat within attributes
  nationality[i]!=nationality[j];
forall (ordered i, j in Colors)
  color[i]!=color[j];
forall (ordered i, j in Jobs)
  job[i]!=job[j];
forall (ordered i, j in Animals)
  animal[i]!=animal[j];
forall (ordered i, j in Drinks)
  drink[i]!=drink[j];
  
	  nationality["English"]==color["red"]; // fact 1
	  nationality["Spaniard"]==animal["dog"]; // fact 2
	  nationality["Japanese"]==job["painter"]; // fact 3
	  nationality["Italian"]==drink["tea"]; // fact 4
	  nationality["Norwegian"]==0; // fact 5
	  color["green"]==drink["coffee"]; // fact 6
	  color["green"]==color["white"]+1; // fact 7
	  job["sculptor"]==animal["snail"]; // fact 8
	  job["diplomat"]==color["yellow"]; // fact 9
	  drink["milk"]==2; // fact 10
	  nationality["Norwegian"]+color["blue"]>=1; // fact 11
	  job["violinist"]==drink["juice"]; // fact 12
	  animal["fox"]+job["doctor"]>=1; // fact 13
	  animal["horse"]+job["diplomat"]>=1; // fact 14 
}
