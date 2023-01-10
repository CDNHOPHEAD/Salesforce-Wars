public with sharing class GetPeopleAPICallout {
    @future (callout=true)
    public static void getPeople(){
        
        //Integer i       = Integer.valueof((Math.random() * 82));
        Http http       = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('https://swapi.dev/api/people/3');
        req.setHeader('Accept', 'application/json;charset=UTF-8');

        GetPeopleWrapperClass peopleResponse = new GetPeopleWrapperClass();

        try {
            HttpResponse response = http.send(req);
                if(response.getStatusCode() == 200){
                    System.debug(response.getBody());
                    peopleResponse = (GetPeopleWrapperClass)(JSON.deserialize(response.getBody(), GetPeopleWrapperClass.class));

                }
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
        }
            Star_Wars_Planet__c homeworld = [SELECT Id FROM Star_Wars_Planet__c WHERE Url__c = :peopleResponse.homeworld LIMIT 1];

            Star_Wars_Person__c newPerson = new Star_Wars_Person__c ();
                newPerson.Name          = peopleResponse.name;
                newPerson.Birth_Year__c = peopleResponse.birth_year;
                newPerson.Eye_Color__c  = peopleResponse.eye_color.capitalize();
                newPerson.Gender__c     = peopleResponse.gender.capitalize();
                newPerson.Hair_Color__c = peopleResponse.hair_color.capitalize();
                newPerson.Height_cm__c  = double.valueOf(peopleResponse.height);
                newPerson.Homeworld__c  = homeworld.Id;
                newPerson.Mass_kg__c    = double.valueOf(peopleResponse.mass);
                newPerson.URL__c        = peopleResponse.url;
  
                insert newPerson;

    }

}