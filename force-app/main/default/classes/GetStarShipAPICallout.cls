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
*******************************************************************************************/
public with sharing class GetStarShipAPICallout {
/**************************************************************************************
* @Description  Future method to get Star Wars "Starship" data from Open API and then insert a new Star_Wars_Starship__c record with the related data
* @Param		N/A
* @Return       Void 
* @Example     
**************************************************************************************/     
    @future (callout=true)
    public static void getStarships(){
        
        Integer i = Integer.valueof((Math.random() * 28)+1);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('https://swapi.dev/api/starships/'+i);
        req.setHeader('Accept', 'application/json;charset=UTF-8');

        //Instantiating the wrapper class for the JSON response from the Star Wars API
        GetStarshipWrapperClass starshipResponse = new GetStarshipWrapperClass();

        try {
            HttpResponse response = http.send(req);
                if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    System.debug(response.getBody());
                    starshipResponse = (GetStarshipWrapperClass)(JSON.deserialize(response.getBody(), GetStarshipWrapperClass.class));
            }
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
        }

        //Creating new Salesforce record with the Starship data populated
        Star_Wars_Starship__c newStarship = new Star_Wars_Starship__c ();
            newStarship.Name                      = starshipResponse.name;
            newStarship.Cargo_Capacity__c         = double.valueOf(starshipResponse.cargo_capacity);
            newStarship.Consumables__c            = starshipResponse.consumables;
            newStarship.Crew__c                   = starshipResponse.crew;
            newStarship.Hyperdrive_Rating__c      = double.valueOf(starshipResponse.hyperdrive_rating);
            newStarship.Length__c                 = double.valueOf(starshipResponse.length);
            newStarship.Manufacturer__c           = starshipResponse.manufacturer;
            newStarship.Max_Atmosphering_Speed__c = starshipResponse.max_atmosphering_speed;
            newStarship.Model__c                  = starshipResponse.model;
            newStarship.Passengers__c             = starshipResponse.passengers;
            //newStarship.Pilots__c = starshipResponse
            newStarship.Starship_Class__c          = starshipResponse.starship_class;
            newStarship.URL__c                    = starshipResponse.url;
        insert newStarship;

    }

}

