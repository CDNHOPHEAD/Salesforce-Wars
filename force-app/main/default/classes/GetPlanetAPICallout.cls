public with sharing class GetPlanetAPICallout {
@future (callout=true)
    public static void getPlanets(){
        
        JiraUpdateWrapperClass requestBody = new JiraUpdateWrapperClass();

        JiraUpdateWrapperClass.Fields fields = new JiraUpdateWrapperClass.Fields();
        
        JiraUpdateWrapperClass.Content listContent = new JiraUpdateWrapperClass.Content();
        listContent.text = c_description;
        listContent.type = 'text';

        List<JiraUpdateWrapperClass.Content> descriptionContent = new List<JiraUpdateWrapperClass.Content>();
        descriptionContent.add(listContent);

        JiraUpdateWrapperClass.Content_Z content_z = new JiraUpdateWrapperClass.Content_Z();
        content_z.type = 'paragraph';
        content_z.content = descriptionContent;

        List<JiraUpdateWrapperClass.Content_Z> ls_z = new List<JiraUpdateWrapperClass.Content_Z>();
        ls_z.add(content_z);

        JiraUpdateWrapperClass.Description description = new JiraUpdateWrapperClass.Description();
        description.type = 'doc';
        description.version = 1;
        description.content = ls_z;

        fields.summary = c_summary;
        fields.description = description;
        requestBody.fields = fields;

        String formattedBody = JSON.serialize(requestBody);
        System.debug(formattedBody);
        

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('PUT');
        req.setEndpoint('https://cloudkettle.atlassian.net/rest/api/3/issue/'+jiraIssueKey);
        req.setHeader('Authorization','Basic YWRhbS5kYWx0b25AY2xvdWRrZXR0bGUuY29tOlFnWGk1YmVMMzQ1N0FUYjBoV3JlQkNFRg==');
        //req.setEndpoint('callout:JiraRestAPI');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setBody(formattedBody);
        

        try {
            HttpResponse response = http.send(req);
                if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    System.debug(response.getBody());
        }
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
        }

    }

}



