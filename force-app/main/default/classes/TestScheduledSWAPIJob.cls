//1.Need to test the wrapper class - create json and confirm values after deserializing
//2. Test for the HTTP callout - create mock that has a fake JSON and have a sucessfull callout and one that throws an exception
//3. Test the create records class with the response from the mock callout 
//4. Query for the records and System assert the values that are expected
//5. Need to test the Scheduled Class as a whole ?


@isTest
private class TestScheduledSWAPIJob {
  static testMethod void testScheduledPlanetAPI() {
    
    
    // Test the PlanetWrapperv2 class
    String planetJson = '{"count": 1,"next": null,"previous": null,"results": [{"name": "Test Planet","rotation_period": "24","orbital_period": "365","diameter": "12500","climate": "temperate","gravity": "1 standard","terrain": "grasslands, mountains","surface_water": "40","population": "200000","residents": [],"created": "2014-12-09T13:50:49.641000Z","edited": "2014-12-20T21:17:56.891000Z","url": "https://swapi.dev/api/planets/1"}]}';
    PlanetWrapperv2 planetWrapper = (PlanetWrapperv2) JSON.deserialize(planetJson, PlanetWrapperv2.class);
    System.assertEquals(1, planetWrapper.count);
    System.assertEquals(null, planetWrapper.next);
    System.assertEquals(null, planetWrapper.previous);
    System.assertEquals(1, planetWrapper.results.size());
    System.assertEquals('Test Planet', planetWrapper.results[0].name);
    
    // Test the StarWarsAPIRequest class
    Test.startTest();
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource('SWPlanetResponse');
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
    Test.setMock(HttpCalloutMock.class, mock);
    // Call method to test
    PlanetWrapperv2 planetResponse = StarWarsAPIRequest.planetAPIRequest(
      'https://swapi.dev/api/planets/?page=1'
    );
    List<PlanetWrapperv2.Results> planetList = planetResponse.results;
    System.assertEquals(10, planetList.size(), 'The array should only contain 10 items.');
    System.assertEquals(60, planetResponse.count);
    System.assertEquals('https://swapi.dev/api/planets/?page=2', planetResponse.next);
    System.assertEquals(null, planetResponse.previous);
    System.assertEquals(10, planetResponse.results.size());
    System.assertEquals('Tatooine', planetResponse.results[0].name);

    List<Star_Wars_Planet__c> planetRecords = new List<Star_Wars_Planet__c> ();
    for(PlanetWrapperv2.Results planet : planetList) {
      Star_Wars_Planet__c newPlanet = StarWarsCreateRecords.createPlanetRecord(
        planet
      );
      planetRecords.add(newPlanet);
    }
    insert planetRecords;
       Test.stopTest();     
                       //query the records to check if they were created
            Star_Wars_Planet__c planetRecord = [SELECT Id, Name, URL__c, Climate__c, Diameter__c, Gravity__c, Orbital_Period__c, Population__c, Rotation_Period__c, Surface_Water__c, Terrain__c
                                                FROM Star_Wars_Planet__c 
                                                WHERE Name = 'Tatooine' LIMIT 1];
            System.assertEquals(planetRecord.Name, 'Tatooine');
            System.assertEquals(planetRecord.URL__c, 'https://swapi.dev/api/planets/1/');
            System.assertEquals(planetRecord.Climate__c, 'arid');
            System.assertEquals(planetRecord.Diameter__c, 10465);
            System.assertEquals(planetRecord.Gravity__c, '1 standard');
            System.assertEquals(planetRecord.Orbital_Period__c, 304);
            System.assertEquals(planetRecord.Population__c, 200000);
            System.assertEquals(planetRecord.Rotation_Period__c, 23);
            System.assertEquals(planetRecord.Surface_Water__c, 1);
            System.assertEquals(planetRecord.Terrain__c, 'desert');
    
  }
}