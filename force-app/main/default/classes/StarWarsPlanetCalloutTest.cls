@isTest
private class StarWarsPlanetCalloutTest {
  @isTest
  static void testPlanetCallout() {
    
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
  }
  //********************** */
  @isTest
  static void testPlanetCalloutNeg() {
        // Dummy invalid planet URL
        String planetURL = 'https://invalid.api/planets/1';
        Boolean exceptionThrown = false;
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('NullCallout');
        mock.setStatusCode(400);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);

        try {
            // Call the method to get planet response
            PlanetWrapperv2 planetResponse = StarWarsAPIRequest.planetAPIRequest(planetURL);
        } catch (CalloutException e) {
            exceptionThrown = true;
            System.assertEquals('Did not get a success response from the SW Planet callout. Details, Status Code: 400 status message: OK', e.getMessage());
        }
        // Assert that exception is thrown
        //System.assertEquals(true, exceptionThrown, 'CalloutException should be thrown');
    }
    //**** */
    @isTest
  static void testPeopleCallout() {
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource('SWPersonResponse');
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
    Test.setMock(HttpCalloutMock.class, mock);
    // Call method to test
    PeopleWrapperv2 peopleResponse = StarWarsAPIRequest.peopleAPIrequest(
      'https://swapi.dev/api/people/?page=1'
    );
    List<PeopleWrapperv2.Results> peopleList = peopleResponse.results;
    System.assertEquals(10, peopleList.size(), 'The array should only contain 10 items.');
  }

//*********** */
@isTest
static void testStarshipCallout() {
  StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
  mock.setStaticResource('SWStarshipResponse');
  mock.setStatusCode(200);
  mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
  Test.setMock(HttpCalloutMock.class, mock);
  // Call method to test
  StarshipWrapperv2 starshipResponse = StarWarsAPIRequest.starshipAPIrequest(
    'https://swapi.dev/api/starships/?page=1'
  );
  List<StarshipWrapperv2.Results> starshipList = starshipResponse.results;
  System.assertEquals(10, starshipList.size(), 'The array should only contain 10 items.');
}
}
