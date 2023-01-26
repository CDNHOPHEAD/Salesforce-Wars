global class ScheduledSWAPIJob implements Schedulable {
  global void execute(SchedulableContext sc) {
    ScheduledPlanetAPI();
    //ScheduledPeopleAPI();
    ScheduledStarshipAPI();
  }
  //******************************************************************************************** */
  @future(callout=true)
  public static void ScheduledPlanetAPI() {
    List<Star_Wars_Planet__c> planetRecords = new List<Star_Wars_Planet__c>();

    Integer pageNumber = 1;
    String nextPage;

    do {
      String planetURL =
        'https://swapi.dev/api/planets/?page=' + String.valueOf(pageNumber);
      PlanetWrapperv2 planetResponse = StarWarsAPIRequest.planetAPIrequest(
        planetURL
      );
      List<PlanetWrapperv2.Results> planetList = planetResponse.results;
      nextPage = planetResponse.next;

      for (PlanetWrapperv2.Results planet : planetList) {
        Star_Wars_Planet__c newPlanet = StarWarsCreateRecords.createPlanetRecord(
          planet
        );
        planetRecords.add(newPlanet);
      }
      pageNumber++;
    } while (nextPage != null);

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
  //******************************************************************************************** */
  @future(callout=true)
  public static void ScheduledStarshipAPI() {
    List<Star_Wars_Starship__c> starshipRecords = new List<Star_Wars_Starship__c>();

    Integer pageNumber = 1;
    String nextPage = ' ';

    do {
      String starshipURL =
        'https://swapi.dev/api/starships/?page=' + String.valueOf(pageNumber);
      StarshipWrapperv2 starshipResponse = StarWarsAPIRequest.starshipAPIrequest(
        starshipURL
      );
      List<StarshipWrapperv2.Results> starshipList = starshipResponse.results;
      nextPage = starshipResponse.next;

      for (StarshipWrapperv2.Results starship : starshipList) {
        Star_Wars_Starship__c newStarship = StarWarsCreateRecords.createStarshipRecord(
          starship
        );
        starshipRecords.add(newStarship);
      }
      pageNumber++;
    } while (nextPage != null);

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
