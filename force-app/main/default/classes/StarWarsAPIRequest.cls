/*******************************************************************************************
 * @Name         StarWarsAPIRequest
 * @Author       Adam Dalton
 * @Date         01/19/2023
 * @Group        Star Wars API Project
 * @Description  This class handles the HTTP callouts for the SWAPI.
 *******************************************************************************************/
/* MODIFICATION LOG
 * Version          Developer          Date               Description
 *-------------------------------------------------------------------------------------------
 *  1.0              Adam      01/18/2023          Initial Creation
 *******************************************************************************************/
public with sharing class StarWarsAPIRequest {
  /**************************************************************************************
   * @Description  Method that sends an HTTP GET request to SWAPI for the planet data
   * @Param		     String planetURL - passing in the endpoint for the HTTP request
   * @Return       Void
   * @Example
   **************************************************************************************/
  public static GetPlanetsWrapperClass planetAPIRequest(String planetURL) {
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    req.setMethod('GET');
    req.setEndpoint(planetURL);
    req.setHeader('Accept', 'application/json;charset=UTF-8');

    //Instantiating the wrapper class for the JSON response from the Star Wars API
    HttpResponse res = http.send(req);
    if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
        GetPlanetsWrapperClass planetResponse = (GetPlanetsWrapperClass) (JSON.deserialize(
        res.getBody(),
        GetPlanetsWrapperClass.class
      ));
      return planetResponse;
    }

    throw new CalloutException(
      'Did not get a success response from the SW Planet callout. Details, Status Code: ' +
        res.getStatusCode() +
        ' status message: ' +
        res.getStatus()
    );
  }
  /**************************************************************************************
   * @Description  Method that sends an HTTP GET request to SWAPI for the people data
   * @Param		     String residentURL - passing in the endpoint for the HTTP request
   * @Return       Void
   * @Example
   **************************************************************************************/
  public static GetPeopleWrapperClass peopleAPIrequest(String residentURL) {
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    req.setMethod('GET');
    req.setEndpoint(residentURL);
    req.setHeader('Accept', 'application/json;charset=UTF-8');

    //Instantiating the wrapper class for the JSON response from the Star Wars API
    HttpResponse res = http.send(req);
    if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
        GetPeopleWrapperClass peopleResponse = (GetPeopleWrapperClass) (JSON.deserialize(
            res.getBody(),
            GetPeopleWrapperClass.class
          ));
      return peopleResponse;
    }

    throw new CalloutException(
      'Did not get a success response from the SW People callout. Details, Status Code: ' +
        res.getStatusCode() +
        ' status message: ' +
        res.getStatus()
    );
  }
    /**************************************************************************************
   * @Description  Method that sends an HTTP GET request to SWAPI for the starship data
   * @Param		     String starshipURL - passing in the endpoint for the HTTP request
   * @Return       Void
   * @Example
   **************************************************************************************/

  public static GetStarshipWrapperClass starshipAPIrequest(String starshipURL) {
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    req.setMethod('GET');
    req.setEndpoint(starshipURL);
    req.setHeader('Accept', 'application/json;charset=UTF-8');

    //Instantiating the wrapper class for the JSON response from the Star Wars API
    HttpResponse res = http.send(req);
    if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
        GetStarshipWrapperClass starshipResponse = (GetStarshipWrapperClass) (JSON.deserialize(
            res.getBody(),
            GetStarshipWrapperClass.class
          ));
      return starshipResponse;
    }

    throw new CalloutException(
      'Did not get a success response from the SW Starship callout. Details, Status Code: ' +
        res.getStatusCode() +
        ' status message: ' +
        res.getStatus()
    );
  }

  public class CalloutException extends Exception {
  }
}
