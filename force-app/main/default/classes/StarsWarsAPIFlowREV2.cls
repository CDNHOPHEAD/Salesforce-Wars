/*******************************************************************************************
 * @Name         StarsWarsAPIFlowREV2
 * @Author       Adam Dalton
 * @Date         01/19/2023
 * @Group        Star Wars API Project
 * @Description  This class contains all of the logic that calls on two other classes that make the HTTP callouts and create the SF records
 *******************************************************************************************/
/* MODIFICATION LOG
 * Version          Developer          Date               Description
 *-------------------------------------------------------------------------------------------
 *  1.0              Adam      01/08/2023          Initial Creation
 *******************************************************************************************/
public with sharing class StarsWarsAPIFlowREV2 {
  /**************************************************************************************
   * @Description  Invocable method that is being used in a screen flow that allows a user to select a planet from a list of mdt records.It sends a GET request to the API and creates the Starw Wars records in Salesforce.
   * @Param		 List<FlowInputs> request - Wrapper class for Screen Flow input from the user which inclues the URL for the API
   * @Return       Void
   * @Example
   **************************************************************************************/
  @InvocableMethod(
    label='Get Star Wars Records'
    description='HTTP request to SWAPI.com'
    category='Star Wars API'
  )
  public static void StarWarsAPIFlowREV2(List<FlowInputs> request) {
    List<Star_Wars_Person__c> peopleList = new List<Star_Wars_Person__c>();
    //Calling the StarWarsAPIRequest class to handle the HTTP request to the API and putting the response in the GetPlanetsWrapperClass
    String planetURL = request[0].planetURL;
    GetPlanetsWrapperClass planetResponse = StarWarsAPIRequest.planetAPIRequest(
      planetURL
    );
    //Calling the StarWarsCreateRecords to create a Star Wars Planet custom record in Salesforce
    Star_Wars_Planet__c newPlanet = StarWarsCreateRecords.createPlanetRecord(
      planetResponse
    );
    //Storing the "residents" of the planet in a list
    List<String> residentURLList = planetResponse.residents;
    System.debug(residentURLList);
    //Calling the StarWarsAPIRequest class to handle the HTTP request to the API and putting the response in the GetPeopleWrapperClass
    if (residentURLList != null) {
      for (String residentURL : residentURLList) {
        GetPeopleWrapperClass peopleResponse = StarWarsAPIRequest.peopleAPIrequest(
          residentURL
        );
        //Calling the StarWarsCreateRecords to create a Star Wars Planet custom record in Salesforce
        Star_Wars_Person__c newPerson = StarWarsCreateRecords.createPersonRecord(
          peopleResponse
        );
        peopleList.add(newPerson);
      }
    }
    insert newPlanet;
    insert peopleList;
    //After the records have been inserted now I can reference the record IDs. I query for the planet we just inserted using the URL because it is a unique
    Id homeworldId = [
      SELECT Id, URL__c
      FROM Star_Wars_Planet__c
      WHERE URL__c = :newPlanet.URL__c
    ]
    .Id;
    List<Star_Wars_Person__c> updatedResidentList = new List<Star_Wars_Person__c>();
    // Loop through the list of residents and update the Homeworld field on each record which is a master-detail relationship
    for (Star_Wars_Person__c resident : peopleList) {
      resident.Homeworld__c = homeworldId;
      updatedResidentList.add(resident);
    }
    update updatedResidentList;
  }
  //Wrapper class to handle screen flow input because Invocable methods can only accept a list
  public class FlowInputs {
    @InvocableVariable
    public String planetURL;
  }
}
