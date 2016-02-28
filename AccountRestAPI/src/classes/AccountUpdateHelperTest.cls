/**
* @author Lavanya Tangati
* @date 02/26/2016
* @Object Accounts
* @group-content https://docs.google.com/document/d/1Sa_QoysOlyqaIsIjm1FnREjj1EUnzHzTEbyTa2_kjIY/edit
* @description Test class for AccountUpdateHelper 
*/
@isTest
public class AccountUpdateHelperTest 
{
	static testmethod void validateAccountUpdateHelper()
    {
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
        String responseString = AccountUpdateHelper.updateAccounts(body);
        
        Account resultAcc = [SELECT Id, Braintree_ID__c, ParentId FROM Account WHERE Id=:a.Id];
        System.assertEquals(resultAcc.ParentId, parentAcc.Id);
        
        /* with matching name*/
        Account a2 = new Account();
        a2.Name = 'test account123';
        a2.Braintree_ID__c = '654321';
        insert a2;
        
        String body1 = '{' + 
                            ' \"braintree_Id\" :\"'+324561+'\",' +
                            ' \"Name\" : \"'+a2.Name+'\"' + 
                      '}';
        
        String responseString1 = AccountUpdateHelper.updateAccounts(body1);
        Account newAcc = [SELECT Id, Name, ParentId FROM Account WHERE ParentId =: a2.Id];
        System.assert(responseString1.contains('true'));
        System.assertNotEquals(newAcc, null);
        
        //negative test
        
        Account aNeg = new Account();
        aNeg.Name = 'test account negative';
        aNeg.Braintree_ID__c = '543216';
        insert aNeg;
     	
        String body2 = '{' + 
                            ' \"braintree_Id\" :\"'+aNeg.Braintree_ID__c+'\",' +
                            ' \"Name\" : \"'+aNeg.Name+'\"' + 
                      '}';
        
        String responseString2 = AccountUpdateHelper.updateAccounts(body2);
        System.assert(responseString2.contains('false'));
        System.assert(responseString2.contains('Parent Account not found'));
    }
}