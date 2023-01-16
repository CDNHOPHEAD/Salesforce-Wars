public class  StarWarsAPIFlow {
    @InvocableMethod(label='Get Star Wars Records' description='HTTP request to SWAPI.com' category='StarWars')
    public static void StarWarsAPIFlow(List<FlowInputs> request){
      List<Star_Wars_Person__c> peopleList = new List<Star_Wars_Person__c>();
      String planetURL = request[0].planetURL;
      Http http = new Http();
      HttpRequest req = new HttpRequest();
      req.setMethod('GET');
      req.setEndpoint(planetURL);
      System.debug('request: '+request);
      req.setHeader('Accept', 'application/json;charset=UTF-8');
        
      
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
      
      
      List<String> residentURLList = planetResponse.residents;
      System.debug(residentURLList);
      
      Star_Wars_Planet__c newPlanet = new Star_Wars_Planet__c();
      if (planetResponse.name == null) {
        newPlanet.Name = 'No Data in the API';
      } else {
        //Creating new Salesforce record with the data populated
        newPlanet.Name = planetResponse.name;
        newPlanet.Climate__c = planetResponse.climate;
        newPlanet.Gravity__c = planetResponse.gravity;
        newPlanet.Terrain__c = planetResponse.terrain;
        newPlanet.URL__c = planetResponse.url;
        
        String edited = planetResponse.edited.substringBefore('T')+' '+planetResponse.edited.substring(12, 19);
        newPlanet.API_Data_Updated__c = Datetime.valueOf(edited);
        System.debug(newPlanet.API_Data_Updated__c);
        
        String created = planetResponse.created.substringBefore('T')+' '+planetResponse.created.substring(12, 19);
        newPlanet.API_Data_Created__c = Datetime.valueOf(created);
        
        String rotationPeriod = planetResponse.rotation_period;
        if(rotationPeriod.isNumeric() && rotationPeriod !=null){
          newPlanet.Rotation_period__c = Integer.valueOf(rotationPeriod);
        }else{
          newPlanet.Rotation_period__c = null;
        }

        String orbitalPeriod = planetResponse.orbital_period;
        if(orbitalPeriod.isNumeric() && orbitalPeriod !=null){
          newPlanet.Orbital_Period__c = Integer.valueOf(orbitalPeriod);
        }else{
          newPlanet.Orbital_Period__c = null;
        }
        
        String diameter = planetResponse.diameter;
        if(diameter.isNumeric() && diameter !=null){
          newPlanet.Diameter__c = Integer.valueOf(diameter);
        }else{
          newPlanet.Diameter__c = null;
        }

        String surfaceWater = planetResponse.surface_water;
        if(surfaceWater.isNumeric() && surfaceWater !=null){
          newPlanet.Surface_Water__c = Integer.valueOf(surfaceWater);
        }else{
          newPlanet.Surface_Water__c = null;
        }

        String population = planetResponse.population;
        if(population.isNumeric() && population !=null){
          newPlanet.Population__c = long.valueOf(population);
        }else{
          newPlanet.Population__c = null;
        }
      //************************************************************************************ */
      //GET REALATED PEOPLE ON PLANET >> "RESIDENTS"
      
      
      if(residentURLList.size()!=0){
      for(String residentURL : residentURLList){
      
      Http http2 = new Http();
      HttpRequest req2 = new HttpRequest();
      req2.setMethod('GET');
      req2.setEndpoint(residentURL);
      req2.setHeader('Accept', 'application/json;charset=UTF-8');

      //Instantiating the wrapper class for the JSON response from the Star Wars API
      GetPeopleWrapperClass peopleResponse = new GetPeopleWrapperClass();

      try {
        HttpResponse response = http.send(req2);
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
        newPerson.URL__c = peopleResponse.url;
        
        
        String mass = peopleResponse.mass;
         if(mass.isNumeric() && mass !=null){
          newPerson.Mass_kg__c = Integer.valueOf(mass);
        }else{
          newPerson.Mass_kg__c = 0;
        }

       String height = peopleResponse.height;
        if(height.isNumeric() && height !=null){
          newPerson.Height_cm__c = Integer.valueOf(height);
        }else{
          newPerson.Height_cm__c = null;
        }

        String peopleEdited = peopleResponse.edited.substringBefore('T')+' '+peopleResponse.edited.substring(12, 19);
        newPerson.API_Data_Updated__c = Datetime.valueOf(edited);
        
        String peopleCreated = peopleResponse.created.substringBefore('T')+' '+peopleResponse.created.substring(12, 19);
        newPerson.API_Data_Created__c = Datetime.valueOf(created);

        }
        peopleList.add(newPerson);

      }
    }
  }
    insert newPlanet;
    insert peopleList;

    Id homeworldId = [SELECT Id, URL__c FROM Star_Wars_Planet__c WHERE URL__c = :newPlanet.URL__c].Id;
    List<Star_Wars_Person__c> updatedResidentList = new List<Star_Wars_Person__c>();
    
    for(Star_Wars_Person__c resident: peopleList){
      resident.Homeworld__c = homeworldId;
      updatedResidentList.add(resident);
    }

    update updatedResidentList;
  }
      
        //input details that comes to apex from flow
        public class FlowInputs{
            @InvocableVariable public String planetURL;
            
        }
}