/**
* @author Lavanya Tangati
* @date 02/26/2016
* @Object Accounts
* @group-content https://docs.google.com/document/d/1Sa_QoysOlyqaIsIjm1FnREjj1EUnzHzTEbyTa2_kjIY/edit
* @description Rest class that sends the request to the Helper class and handles the status code of the response
*/

@RestResource(urlMapping='/v1.0/account-updates')

global class RestAccountUpdate 
{
	/*
	 Below is the sample JSON string that I used for testing purpose
    '{' + 
        ' \"braintree_Id\" :\"123456\",' +
        ' \"Name\" : \"AccountForDemo\"' + 
        '}';
	*/
    
    @HttpPUT
    global static void updateAccounts()
    {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String body = (req.requestBody).toString(); 
        String responseString;
        try
          {
            responseString = AccountUpdateHelper.updateAccounts(body); //call helper class to execute the logic
            if(responseString.contains('true'))
            {
              res.statusCode = 200;
            }
            else
            {
              res.statusCode = 400;
            }
          }
          catch(Exception e)
          {
            res.statusCode = 500;
          }
        
        //send Json response 
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(responseString);
    }
}