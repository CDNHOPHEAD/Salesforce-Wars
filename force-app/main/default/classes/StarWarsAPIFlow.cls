public class  StarWarsAPIFlow {
    @InvocableMethod(label='Get Star Wars Records' description='HTTP request to SWAPI.com' category='StarWars')
    public static List<Star_Wars_Planet__c> StarWarsAPIFlow(List<FlowInputs> request){
     Http http = new Http();
      HttpRequest req = new HttpRequest();
      req.setMethod('GET');
      req.setEndpoint('https://swapi.dev/api/planets/' + request[0].planetNumber);
      System.debug('request: '+request);
      req.setHeader('Accept', 'application/json;charset=UTF-8');
        
      List<Star_Wars_Planet__c> planetList = new List<Star_Wars_Planet__c>();
      //Instantiating the wrapper class for the JSON response from the Star Wars API
      GetPlanetsWrapperClass planetResponse = new GetPlanetsWrapperClass();

      try {
        HttpResponse response = http.send(req);
        if (
          response.getStatusCode() >= 200 &&  
          response.getStatusCode() <= 300
        ) {
          System.debug(response.getBody());
          planetResponse = (GetPlanetsWrapperClass) (JSON.deserialize(
            response.getBody(),
            GetPlanetsWrapperClass.class
          ));
        }
      } catch (System.CalloutException e) {
        System.debug('Callout error: ' + e);
      }

      Star_Wars_Planet__c newPlanet = new Star_Wars_Planet__c();
      if (planetResponse.name == null) {
        newPlanet.Name = 'No Data in the API';
        planetList.add(newPlanet);
      } else {
        //Creating new Salesforce record with the data populated
        newPlanet.Name = planetResponse.name;
        newPlanet.Climate__c = planetResponse.climate;
        newPlanet.Diameter__c = planetResponse.diameter;
        newPlanet.Gravity__c = planetResponse.gravity;
        newPlanet.Orbital_Period__c = planetResponse.orbital_period;
        newPlanet.Population__c = planetResponse.population;
        newPlanet.Rotation_period__c = planetResponse.surface_water;
        newPlanet.Terrain__c = planetResponse.terrain;
        newPlanet.Surface_Water__c = planetResponse.surface_water;
        newPlanet.URL__c = planetResponse.url;
        
        planetList.add(newPlanet);
      }
      insert planetList;
      return planetList;
    }
        //input details that comes to apex from flow
        public class FlowInputs{
    
            //@InvocableVariable
            //public Account accountSobj;
            
            @InvocableVariable
            public Integer planetNumber;
            
        }
}