public with sharing class GetStarShipAPICallout {
    @future (callout=true)
    public static void getStarships(){
        
        Integer i = Integer.valueof((Math.random() * 28)+1);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('https://swapi.dev/api/starships/'+i);
        req.setHeader('Accept', 'application/json;charset=UTF-8');

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

