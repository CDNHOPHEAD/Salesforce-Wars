public class OpportunityToGoogleSheets {
    @InvocableMethod
    public static void createNewSheet(List<Opportunity> opportunities) {
        for (Opportunity opp : opportunities) {
            // Set up the request body
            String jsonBody = '{"properties": {"title": "' + opp.Name + '"}}';
            // Set up the request headers
            Map<String, String> headers = new Map<String, String>();
            headers.put('Content-Type', 'application/json');
            headers.put('Authorization', 'Bearer ' + GoogleSheetsAPIKey);
            // Send the request to create a new spreadsheet based on the template
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://sheets.googleapis.com/v4/spreadsheets');
            request.setMethod('POST');
            request.setHeaders(headers);
            request.setBody(jsonBody);
            HttpResponse response = http.send(request);
            // Parse the response to get the new spreadsheet ID
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            String spreadsheetId = (String) responseMap.get('spreadsheetId');
            // Send a request to copy the template sheet to the new spreadsheet
            jsonBody = '{"spreadsheetId": "' + spreadsheetId + '"}';
            headers.put('Authorization', 'Bearer ' + GoogleDriveAPIKey);
            request.setEndpoint('https://www.googleapis.com/drive/v3/files/' + templateFileId + '/copy');
            request.setBody(jsonBody);
            response = http.send(request);
            // Parse the response to get the new sheet ID
            responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            String sheetId = (String) responseMap.get('id');
            // Update the sheet name
            jsonBody = '{"requests": [{"updateSheetProperties": {"properties": {"sheetId": "' + sheetId + '", "title": "' + opp.Name + '"}}}]}';
            request.setEndpoint('https://sheets.googleapis.com/v4/spreadsheets/' + spreadsheetId + ':batchUpdate');
            request.setBody(jsonBody);
            response = http.send(request);
        }
    }
}
