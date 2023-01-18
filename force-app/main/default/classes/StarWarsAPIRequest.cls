public with sharing class StarWarsAPIRequest {
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
//*********************************************************************************************** */
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
  //*********************************************************************************************** */

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
