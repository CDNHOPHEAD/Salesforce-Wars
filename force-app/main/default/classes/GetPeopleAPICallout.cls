/*******************************************************************************************
 * @Name         GetPeopleAPICallout
 * @Author       Adam Dalton
 * @Date         01/11/2023
 * @Group        Star Wars API Project
 * @Description  This class contains the HTTP 'GET' request that will grab the person data from swapi.dev/api and populate the Star_Wars_Person__c custom object in the Salesforce Org
 *******************************************************************************************/
/* MODIFICATION LOG
 * Version          Developer          Date               Description
 *-------------------------------------------------------------------------------------------
 *  1.0              Adam      01/09/2023          Initial Creation
 *  2.0              Adam      01/12/2023         Created a for loop so that the method iterates through all the endpoints in the API and create a new record
 *******************************************************************************************/
public with sharing class GetPeopleAPICallout {
  /**************************************************************************************
   * @Description  Future method to get Star Wars "Person" data from Open API and then insert a new Star_Wars_Person__c record with the related data
   * @Param		N/A
   * @Return       Void
   * @Example
   **************************************************************************************/
  @future(callout=true)
  public static void getPeople() {
    List<Star_Wars_Planet__c> planetList = [
      SELECT Id, URL__c
      FROM Star_Wars_Planet__c
      WHERE URL__c != NULL
    ];
    List<Star_Wars_Person__c> peopleList = new List<Star_Wars_Person__c>();
    for (Integer i = 1; i <= 83; i++) {
      Http http = new Http();
      HttpRequest req = new HttpRequest();
      req.setMethod('GET');
      req.setEndpoint('https://swapi.dev/api/people/' + i);
      req.setHeader('Accept', 'application/json;charset=UTF-8');

      //Instantiating the wrapper class for the JSON response from the Star Wars API
      GetPeopleWrapperClass peopleResponse = new GetPeopleWrapperClass();

      try {
        HttpResponse response = http.send(req);
        if (response.getStatusCode() == 200) {
          System.debug(response.getBody());
          peopleResponse = (GetPeopleWrapperClass) (JSON.deserialize(
            response.getBody(),
            GetPeopleWrapperClass.class
          ));
        }
      } catch (System.CalloutException e) {
        System.debug('Callout error: ' + e);
      }
      
      Star_Wars_Person__c newPerson = new Star_Wars_Person__c();
      if (peopleResponse.name == null) {
        newPerson.Name = 'No Data in the API';
        peopleList.add(newPerson);
      }else{
        //Creating new Salesforce record with the data populated
        newPerson.Name = peopleResponse.name;
        newPerson.Birth_Year__c = peopleResponse.birth_year;
        newPerson.Eye_Color__c = peopleResponse.eye_color;
        newPerson.Gender__c = peopleResponse.gender;
        newPerson.Hair_Color__c = peopleResponse.hair_color;
        newPerson.Height_cm__c = peopleResponse.height;
        newPerson.Mass_kg__c = peopleResponse.mass;
        newPerson.URL__c = peopleResponse.url;

        for (Star_Wars_Planet__c homePlanet : planetList) {
          if (homePlanet.URL__c == peopleResponse.homeworld) {
            System.debug(homePlanet.Id);
            newPerson.Homeworld__c = homePlanet.Id;
          } 
        }
        peopleList.add(newPerson);

      }
    }
    insert peopleList;
  }
}
