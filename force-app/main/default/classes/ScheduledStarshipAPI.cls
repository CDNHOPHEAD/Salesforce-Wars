global class ScheduledStarshipAPI Implements Schedulable {
    global void execute(SchedulableContext sc)
    {
        ScheduledStarshipAPI();
    }
    
    @future(callout=true)
    public static void ScheduledStarshipAPI() {
        List<Star_Wars_Starship__c> starshipRecords = new List<Star_Wars_Starship__c>();
        
        Integer pageNumber = 1;
        String nextPage = ' ';

        do{
            String starshipURL = 'https://swapi.dev/api/starships/?page=' + String.valueOf(pageNumber);
            StarshipWrapperv2 starshipResponse = StarWarsAPIRequest.starshipAPIrequest(starshipURL);
            List<StarshipWrapperv2.Results> starshipList = starshipResponse.results;
            nextPage = starshipResponse.next;

            for(StarshipWrapperv2.Results starship:starshipList){
                Star_Wars_Starship__c newStarship = StarWarsCreateRecords.createStarshipRecord(starship);
                starshipRecords.add(newStarship);
            }
            pageNumber++;
        }while(nextPage !=null);
        upsert starshipRecords URL__c;
      }
        

     

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


