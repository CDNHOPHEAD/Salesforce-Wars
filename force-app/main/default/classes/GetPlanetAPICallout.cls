/*******************************************************************************************
 * @Name         GetPlanetAPICallout
 * @Author       Adam Dalton
 * @Date         01/10/2023
 * @Group        Star Wars API Project
 * @Description  This class contains the HTTP 'GET' Request that will grab the planet data from swapi.dev/api and populate the Star_Wars_Planet__c custom object in the Salesforce Org
 *******************************************************************************************/
/* MODIFICATION LOG
 * Version          Developer          Date               Description
 *-------------------------------------------------------------------------------------------
 *  1.0              Adam      01/09/2023          Initial Creation
 *  2.0              Adam      01/12/2023         Created a for loop so that the method iterates through all the endpoints in the API and create a new record
 *******************************************************************************************/
public with sharing class GetPlanetAPICallout {
  /**************************************************************************************
   * @Description  Future method to get Star Wars "Planet" data from Open API and then insert a new Star_Wars_Planet__c record with the related data
   * @Param		N/A
   * @Return       Void
   * @Example
   **************************************************************************************/
  @future(callout=true)
  public static void getPlanets() {
    List<Star_Wars_Planet__c> planetList = new List<Star_Wars_Planet__c>();
    for (Integer i = 1; i <= 60; i++) {
      Http http = new Http();
      HttpRequest req = new HttpRequest();
      req.setMethod('GET');
      req.setEndpoint('https://swapi.dev/api/planets/' + i);
      req.setHeader('Accept', 'application/json;charset=UTF-8');

      //Instantiating the wrapper class for the JSON response from the Star Wars API
      GetPlanetsWrapperClass planetResponse = new GetPlanetsWrapperClass();

      try {
        HttpResponse response = http.send(req);
        if (
          response.getStatusCode() == 200 ||
          response.getStatusCode() == 201
        ) {
          System.debug(response.getBody());
          planetResponse = (GetPlanetsWrapperClass) (JSON.deserialize(
            response.getBody(),
            GetPlanetsWrapperClass.class
          ));
        }
      } catch (System.CalloutException e) {
        System.debug('Callout error: ' + e);
      }

      Star_Wars_Planet__c newPlanet = new Star_Wars_Planet__c();
      if (planetResponse.name == null) {
        newPlanet.Name = 'No Data in the API';
        planetList.add(newPlanet);
      } else {
        //Creating new Salesforce record with the data populated
        newPlanet.Name = planetResponse.name;
        newPlanet.Climate__c = planetResponse.climate;
        newPlanet.Diameter__c = planetResponse.diameter;
        newPlanet.Gravity__c = planetResponse.gravity;
        newPlanet.Orbital_Period__c = planetResponse.orbital_period;
        newPlanet.Population__c = planetResponse.population;
        newPlanet.Rotation_period__c = planetResponse.surface_water;
        newPlanet.Terrain__c = planetResponse.terrain;
        newPlanet.Surface_Water__c = planetResponse.surface_water;
        newPlanet.URL__c = planetResponse.url;

        planetList.add(newPlanet);
      }
      insert planetList;
    }
  }
}
