public with sharing class StarsWarsAPIFlowREV2 {
    @InvocableMethod(label='Get Star Wars Records' description='HTTP request to SWAPI.com' category='Star Wars API')
    public static void StarWarsAPIFlowREV2(List<FlowInputs> request){
      
    List<Star_Wars_Person__c> peopleList = new List<Star_Wars_Person__c>();
      
      String planetURL = request[0].planetURL;
      GetPlanetsWrapperClass planetResponse = StarWarsAPIRequest.planetAPIRequest(planetURL);
      Star_Wars_Planet__c newPlanet = StarWarsCreateRecords.createPlanetRecord(planetResponse);

      List<String> residentURLList = planetResponse.residents;
      System.debug(residentURLList);

      if(residentURLList !=null){
        for(String residentURL: residentURLList){
            GetPeopleWrapperClass peopleResponse = StarWarsAPIRequest.peopleAPIrequest(residentURL);
            Star_Wars_Person__c newPerson = StarWarsCreateRecords.createPersonRecord(peopleResponse);
            peopleList.add(newPerson);
        }
      }
      insert newPlanet;
      insert peopleList;
  //******************************************************************************************************** */
      Id homeworldId = [SELECT Id, URL__c FROM Star_Wars_Planet__c WHERE URL__c = :newPlanet.URL__c].Id;
      List<Star_Wars_Person__c> updatedResidentList = new List<Star_Wars_Person__c>();
      
      for(Star_Wars_Person__c resident: peopleList){
        resident.Homeworld__c = homeworldId;
        updatedResidentList.add(resident);
      }
      update updatedResidentList;

    }

    public class FlowInputs{
        @InvocableVariable public String planetURL;
    }
}
