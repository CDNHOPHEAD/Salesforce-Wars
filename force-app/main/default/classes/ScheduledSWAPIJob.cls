/*******************************************************************************************
 * @Name         ScheduledSWAPIJob
 * @Author       Adam Dalton
 * @Date         01/25/2023
 * @Group        Star Wars API Project
 * @Description  This scheduled apex class contains all of the logic that calls on two other classes that make the HTTP callouts and create the SF records
 *******************************************************************************************/
/* MODIFICATION LOG
 * Version          Developer          Date               Description
 *-------------------------------------------------------------------------------------------
 *  1.0              Adam      01/25/2023          Initial Creation
 *******************************************************************************************/
global class ScheduledSWAPIJob implements Schedulable {
  global void execute(SchedulableContext sc) {
    ScheduledPlanetAPI();
    ScheduledPersonAPI();
    ScheduledStarshipAPI();
  }
  /**************************************************************************************
   * @Description  Method that is being used to make the GET request to SWAPI and create the assocaited Star Wars Planet record in Salesforce
   * @Param		     N/A
   * @Return       Void
   * @Example
   **************************************************************************************/
  @future(callout=true)
  public static void ScheduledPlanetAPI() {
    List<Star_Wars_Planet__c> planetRecords = new List<Star_Wars_Planet__c>();
    String planetURL = 'https://swapi.dev/api/planets/?page=1';

    while (planetURL != null) {
      PlanetWrapperv2 planetResponse = StarWarsAPIRequest.planetAPIrequest(
        planetURL
      );
      List<PlanetWrapperv2.Results> planetList = planetResponse.results;
      planetURL = planetResponse.next;

      for (PlanetWrapperv2.Results planet : planetList) {
        Star_Wars_Planet__c newPlanet = StarWarsCreateRecords.createPlanetRecord(
          planet
        );
        planetRecords.add(newPlanet);
      }
    }

    Database.UpsertResult[] results = Database.upsert(
      planetRecords,
      Star_Wars_Planet__c.URL__c.getDescribe().getSObjectField(),
      false
    );

    for (Integer i = 0; i < results.size(); i++) {
      if (!results.get(i).isSuccess()) {
        Database.Error err = results.get(i).getErrors().get(0);
        System.debug(
          'Error - ' +
            err.getMessage() +
            '\nStatus Code : ' +
            err.getStatusCode() +
            '\n Fields : ' +
            err.getFields()
        );
      }
    }
  }
  /**************************************************************************************
   * @Description  Method that is being used to make the GET request to SWAPI and create the assocaited Star Wars Person record in Salesforce while creating the relationship field "Homeworld" between this record and the associated planet record
   * @Param		     N/A
   * @Return       Void
   * @Example
   **************************************************************************************/
  @future(callout=true)
  public static void ScheduledPersonAPI() {
    List<Star_Wars_Person__c> personRecords = new List<Star_Wars_Person__c>();
    Map<String, Star_Wars_Planet__c> planetMap = new Map<String, Star_Wars_Planet__c>();
    for (Star_Wars_Planet__c planet : [
      SELECT Id, Name, URL__c
      FROM Star_Wars_Planet__c
      LIMIT 100
    ]) {
      planetMap.put(planet.URL__c, planet);
    }
    String personURL = 'https://swapi.dev/api/people/?page=1';

    while (personURL != null) {
      PeopleWrapperv2 peopleResponse = StarWarsAPIRequest.peopleAPIrequest(
        personURL
      );
      List<PeopleWrapperv2.Results> personList = peopleResponse.results;
      personURL = peopleResponse.next;

      for (PeopleWrapperv2.Results person : personList) {
        Star_Wars_Person__c newPerson = StarWarsCreateRecords.createPersonRecord(
          person
        );
        String homeWorldURL = person.homeworld;
        Star_Wars_Planet__c homeWorld = planetMap.get(homeWorldURL);
        newPerson.Homeworld__c = homeWorld.Id;

        personRecords.add(newPerson);
      }
    }

    Database.UpsertResult[] results = Database.upsert(
      personRecords,
      Star_Wars_Person__c.URL__c.getDescribe().getSObjectField(),
      false
    );

    for (Integer i = 0; i < results.size(); i++) {
      if (!results.get(i).isSuccess()) {
        Database.Error err = results.get(i).getErrors().get(0);
        System.debug(
          'Error - ' +
            err.getMessage() +
            '\nStatus Code : ' +
            err.getStatusCode() +
            '\n Fields : ' +
            err.getFields()
        );
      }
    }
  }
  /**************************************************************************************
   * @Description  Method that is being used to make the GET request to SWAPI and create the assocaited Star Wars Starship record in Salesforce
   * @Param		     N/A
   * @Return       Void
   * @Example
   **************************************************************************************/
  @future(callout=true)
  public static void ScheduledStarshipAPI() {
    List<Star_Wars_Starship__c> starshipRecords = new List<Star_Wars_Starship__c>();
    String starshipURL = 'https://swapi.dev/api/starships/?page=1';

    while (starshipURL != null) {
      StarshipWrapperv2 starshipResponse = StarWarsAPIRequest.starshipAPIrequest(
        starshipURL
      );
      List<StarshipWrapperv2.Results> starshipList = starshipResponse.results;
      starshipURL = starshipResponse.next;

      for (StarshipWrapperv2.Results starship : starshipList) {
        Star_Wars_Starship__c newStarship = StarWarsCreateRecords.createStarshipRecord(
          starship
        );
        starshipRecords.add(newStarship);
      }
    }

    Database.UpsertResult[] results = Database.upsert(
      starshipRecords,
      Star_Wars_Starship__c.URL__c.getDescribe().getSObjectField(),
      false
    );

    for (Integer i = 0; i < results.size(); i++) {
      if (!results.get(i).isSuccess()) {
        Database.Error err = results.get(i).getErrors().get(0);
        System.debug(
          'Error - ' +
            err.getMessage() +
            '\nStatus Code : ' +
            err.getStatusCode() +
            '\n Fields : ' +
            err.getFields()
        );
      }
    }
  }
}
