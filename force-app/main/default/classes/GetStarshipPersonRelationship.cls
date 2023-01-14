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
public with sharing class GetStarshipPersonRelationship {
    /**************************************************************************************
     * @Description  Future method to get Star Wars "Starship" data from Open API and then insert a new Star_Wars_Starship__c record with the related data
     * @Param		N/A
     * @Return       Void
     * @Example
     **************************************************************************************/
    @future(callout=true)
    public static void starshipPilotRelationship() {
      
    List<Starship_Person_Junction__c> junctionList = new List<Starship_Person_Junction__c>();
    //Map<String ,Star_Wars_Person__c> pilotMap = new Map<String ,Star_Wars_Person__c>();
    List<Star_Wars_Starship__c> starshipList = [SELECT Id,Name,URL__c FROM Star_Wars_Starship__c];
    Map<Id ,Star_Wars_Starship__c> starshipMap = new Map<Id, Star_Wars_Starship__c>(starshipList);
    //Create map of people with URL as the key
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
        
        List<String> pilotURLS = starshipResponse.pilots;
        Id starshipId = [SELECT Id From Star_Wars_Starship__c WHERE URL__c = :starshipResponse.url LIMIT 1].Id; 
        List<Star_Wars_Person__c> pilotList = [SELECT Id, URL__c FROM Star_Wars_Person__c WHERE URL__c IN :pilotURLS];

        for(Star_Wars_Person__c pilot: pilotList){
            Starship_Person_Junction__c newJunction = new Starship_Person_Junction__c();
            newJunction.Pilots__c = pilot.Id;
            newJunction.Starships__c = starshipId;
            junctionList.add(newJunction);
        }

      }
      insert junctionList;
    }
  }
  