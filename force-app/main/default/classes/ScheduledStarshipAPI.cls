global class ScheduledStarshipAPI Implements Schedulable {
    global void execute(SchedulableContext sc)
    {
        ScheduledStarshipAPI();
    }
    
    @future(callout=true)
    public static void ScheduledStarshipAPI() {
        List<Star_Wars_Starship__c> starshipList = new List<Star_Wars_Starship__c>();
        
        for (Integer i = 2; i <= 29; i++) {
          String starshipURL = 'https://swapi.dev/api/starships/' + i;
          GetStarshipWrapperClass starshipResponse = StarWarsAPIRequest.starshipAPIrequest(starshipURL);
          Star_Wars_Starship__c newStarship = StarWarsCreateRecords.createStarshipRecord(starshipResponse);
          starshipList.add(newStarship);

      }
        upsert starshipList;

     /*   List<String> pilotURLS = starshipResponse.pilots;
        Id starshipId = [SELECT Id From Star_Wars_Starship__c WHERE URL__c = :starshipResponse.url LIMIT 1].Id; 
        List<Star_Wars_Person__c> pilotList = [SELECT Id,Name, URL__c FROM Star_Wars_Person__c WHERE URL__c IN :pilotURLS];

        for(Star_Wars_Person__c pilot: pilotList){
            Starship_Person_Junction__c newJunction = new Starship_Person_Junction__c();
            newJunction.Name = pilot.Name+' Starship relationship';
            newJunction.Pilots__c = pilot.Id;
            newJunction.Starships__c = starshipId;
            System.debug(newJunction);
            junctionList.add(newJunction);
        }

      }
      insert junctionList;*/
      }
    
}


