/**
* @author Lavanya Tangati
* @date 02/26/2016
* @Object Accounts
* @group-content https://docs.google.com/document/d/1Sa_QoysOlyqaIsIjm1FnREjj1EUnzHzTEbyTa2_kjIY/edit
* @description Test class for RestAccountUpdate 
*/
@isTest
public class RestAccountUpdateTest 
{
	static testmethod void validateRestAccountUpdate()
    {   
        //positive test
        
        /* with matching braintreeId */
        Account a = new Account();
        a.Name = 'test account';
        a.Braintree_ID__c = '123456';
        insert a;
		
		Account parentAcc = new Account();
		parentAcc.Name = 'Parent Account';
        insert parentAcc;
   
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        String body = '{' + 
                            ' \"braintree_Id\" :\"'+a.Braintree_ID__c+'\",' +
                            ' \"Name\" : \"'+parentAcc.Name+'\"' + 
                      '}';
        req.requestBody = blob.valueof(body);
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        RestAccountUpdate.updateAccounts();
        System.assertEquals(200, res.statusCode);   
        
        /* with matching name*/
        Account a2 = new Account();
        a2.Name = 'test account123';
        a2.Braintree_ID__c = '654321';
        insert a2;
        
        String body1 = '{' + 
                            ' \"braintree_Id\" :\"'+324561+'\",' +
                            ' \"Name\" : \"'+a2.Name+'\"' + 
                      '}';
        req.requestBody = blob.valueof(body1);
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        RestAccountUpdate.updateAccounts();
        System.assertEquals(200, res.statusCode);  
        
        //negative test
        
        Account aNeg = new Account();
        aNeg.Name = 'test account negative';
        aNeg.Braintree_ID__c = '543216';
        insert aNeg;
     	
        String body2 = '{' + 
                            ' \"braintree_Id\" :\"'+aNeg.Braintree_ID__c+'\",' +
                            ' \"Name\" : \"'+aNeg.Name+'\"' + 
                      '}';
        req.requestBody = blob.valueof(body2);
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        RestAccountUpdate.updateAccounts();
        System.assertEquals(400, res.statusCode); 
    }
   
}