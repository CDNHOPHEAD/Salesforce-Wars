/*******************************************************************************************
 * @Name         GetStarShipAPICallout
 * @Author       Adam Dalton
 * @Date         01/11/2023
 * @Group        Star Wars API Project
 * @Description  This class contains the HTTP 'GET' request that will grab the planet data from swapi.dev/api and populate the Star_Wars_Starship__c custom object in the Salesforce Org
 *******************************************************************************************/
/* MODIFICATION LOG
 * Version          Developer          Date               Description
 *-------------------------------------------------------------------------------------------
 *  1.0              Adam      01/09/2023          Initial Creation
 *  2.0              Adam      01/12/2023         Created a for loop so that the method iterates through all the endpoints in the API and create a new record
 *******************************************************************************************/
public with sharing class GetStarShipAPICallout {
  /**************************************************************************************
   * @Description  Future method to get Star Wars "Starship" data from Open API and then insert a new Star_Wars_Starship__c record with the related data
   * @Param		N/A
   * @Return       Void
   * @Example
   **************************************************************************************/
  @future(callout=true)
  public static void getStarships() {
    List<Star_Wars_Starship__c> starshipList = new List<Star_Wars_Starship__c>();
    for (Integer i = 2; i <= 29; i++) {
      Http http = new Http();
      HttpRequest req = new HttpRequest();
      req.setMethod('GET');
      req.setEndpoint('https://swapi.dev/api/starships/' + i);
      req.setHeader('Accept', 'application/json;charset=UTF-8');

      //Instantiating the wrapper class for the JSON response from the Star Wars API
      GetStarshipWrapperClass starshipResponse = new GetStarshipWrapperClass();

      try {
        HttpResponse response = http.send(req);
        if (
          response.getStatusCode() == 200 ||
          response.getStatusCode() == 201
        ) {
          System.debug(response.getBody());
          starshipResponse = (GetStarshipWrapperClass) (JSON.deserialize(
            response.getBody(),
            GetStarshipWrapperClass.class
          ));
        }
      } catch (System.CalloutException e) {
        System.debug('Callout error: ' + e);
      }
      System.debug(starshipResponse.pilots);
      //Creating new Salesforce record with the Starship data populated
      Star_Wars_Starship__c newStarship = new Star_Wars_Starship__c();
      newStarship.Name = starshipResponse.name;
      newStarship.Consumables__c = starshipResponse.consumables;
      newStarship.Manufacturer__c = starshipResponse.manufacturer;
      newStarship.Model__c = starshipResponse.model;
      newStarship.Starship_Class__c = starshipResponse.starship_class;
      newStarship.URL__c = starshipResponse.url;

      String cost = starshipResponse.cost_in_credits;
      if (cost.isNumeric() && cost != null) {
        newStarship.Cost_In_Credits__c = Integer.valueOf(cost);
      } else {
        newStarship.Cost_In_Credits__c = null;
      }

      String cargo = starshipResponse.cargo_capacity;
      if (cargo.isNumeric() && cargo != null) {
        newStarship.Cargo_Capacity__c = Integer.valueOf(cargo);
      } else {
        newStarship.Cargo_Capacity__c = null;
      }

      String crew = starshipResponse.crew;
      if (crew.isNumeric() && crew != null) {
        newStarship.Crew__c = Integer.valueOf(crew);
      } else {
        newStarship.Crew__c = null;
      }

      String hyperdrive = starshipResponse.hyperdrive_rating;
      if (hyperdrive.isNumeric() && hyperdrive != null) {
        newStarship.Hyperdrive_Rating__c = Double.valueOf(hyperdrive);
      } else {
        newStarship.Hyperdrive_Rating__c = null;
      }

      String mglt = starshipResponse.MGLT;
      if (mglt.isNumeric() && mglt != null) {
        newStarship.MGLT__c = Integer.valueOf(mglt);
      } else {
        newStarship.MGLT__c = null;
      }

      String length = starshipResponse.length;
      if (length.isNumeric() && length != null) {
        newStarship.Length__c = Double.valueOf(length);
      } else {
        newStarship.Length__c = null;
      }

      String passengers = starshipResponse.passengers;
      if (passengers.isNumeric() && passengers != null) {
        newStarship.Passengers__c = Integer.valueOf(passengers);
      } else {
        newStarship.Passengers__c = null;
      }

      String speed = starshipResponse.max_atmosphering_speed;
      if (speed.isNumeric() && speed != null) {
        newStarship.Max_Atmosphering_Speed__c = Integer.valueOf(speed);
      } else {
        newStarship.Max_Atmosphering_Speed__c = null;
      }

      String edited =
        starshipResponse.edited.substringBefore('T') +
        ' ' +
        starshipResponse.edited.substring(12, 19);
      newStarship.API_Data_Updated__c = Datetime.valueOf(edited);

      String created =
        starshipResponse.created.substringBefore('T') +
        ' ' +
        starshipResponse.created.substring(12, 19);
      newStarship.API_Data_Created__c = Datetime.valueOf(created);

      starshipList.add(newStarship);
    }
    insert starshipList;
  }
}
