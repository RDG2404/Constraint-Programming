/*********************************************
 * OPL 22.1.0.0 Model
 * Author: Admin
 * Creation Date: 28-Aug-2022 at 10:52:17 PM
 *********************************************/
using CP;
range Colors = 0..3;
{string} Planets = ...;
dvar int color[Planets] in Colors;
constraints {
  color["Dagobah"] != color["Geonosis"];
  color["Dagobah"] != color["Kamino"];
  color["Dagobah"] != color["Adleraan"];
  color["Dagobah"] != color["Dantooine"];
  color["Dagobah"] != color["Coruscant"];
  color["Dagobah"] != color["Endor"];
  color["Dagobah"] != color["Nur"];
  color["Naboo"] != color["Kamino"];
  color["Naboo"] != color["Takodana"];
  color["Naboo"] != color["Onderon"];
  color["Naboo"] != color["Cantonica"];
  color["Naboo"] != color["Coruscant"];
  color["Geonosis"] != color["Kamino"];
  color["Geonosis"] != color["Onderon"];
  color["Geonosis"] != color["Endor"];
  color["Geonosis"] != color["Nur"];
  color["Geonosis"] != color["Takodana"];
  color["Geonosis"] != color["Dantooine"];
  color["Kamino"] != color["Dantooine"];
  color["Kamino"] != color["Takodana"];
  color["Kamino"] != color["Onderon"];
  color["Kamino"] != color["Endor"];
  color["Kamino"] != color["Cantonica"];
  color["Kamino"] != color["Adleraan"];
  color["Coruscant"] != color["Cantonica"];
  color["Coruscant"] != color["Endor"];
  color["Coruscant"] != color["Nur"];
  color["Coruscant"] != color["Takodana"];
  color["Endor"] != color["Nur"];
  color["Endor"] != color["Takodana"];
  color["Nur"] != color["Onderon"];
  color["Nur"] != color["Takodana"]	;
}