/**
* @author Lavanya Tangati
* @date 02/26/2016
* @Object Accounts
* @group-content https://docs.google.com/document/d/1Sa_QoysOlyqaIsIjm1FnREjj1EUnzHzTEbyTa2_kjIY/edit
* @description Rest Helper class that handles the logic to verify if a matching Braintree Account exists 
* and sends back the response
*/

public class AccountUpdateHelper 
{
    /*
     This method is called from the RestAccountUpdate class. It handles the logic and sends back the response string
	*/
    public static String updateAccounts(String reqString) 
    {	
        /* Variable declarations */
        List<AccountResponse> accResponse = new List<AccountResponse>();
        Account accWithBTId, accWithName, parentAccount, insertAcc;
        AccountResponse aResp = new AccountResponse();
        Map<String, Object> jsonData = (Map<String,Object>)JSON.deserializeUntyped(reqString);
        String braintreeId = (String)jsonData.get('braintree_Id');
        String accName = (String)jsonData.get('Name');
        
        /* Checks if braintreeId or name in the request is null */
        if(String.isBlank(braintreeId) || String.isBlank('Name'))
        {
            aResp.error_log = 'braintree_Id is empty. Please provide a valid Id.';
        }
        else
        {
            try
            {
                /* queries the accounts based on the conditions. This is the only query in the class */
                Account[] accounts = [SELECT Id, Braintree_ID__c, Name, ParentId  
                                       FROM Account 
                                       WHERE Braintree_ID__c =: braintreeId 
                                       OR Name =: accName
                                       OR (Name =: accName 
                                           AND Braintree_ID__c !=: braintreeId
                                           AND ParentId = null)];
                      
                if(accounts.size() >0)
                {
                    /* Loops over the accounts and assign to respective variables based on the condition */
                    for(Account a : accounts)
                    {
                    	if(a.Braintree_ID__c == braintreeId)
                    	{
                        	accWithBTId =  a; //account with braintree id 
                        }
                        else if(a.Name == accName)
                        {
                            accWithName = a; //account with name
                        }
                        if(a.Name == accName && a.Braintree_ID__c != braintreeId && a.ParentId == null)
                        {
                            parentAccount =  a; //parent account
                        }
                    }
                }
                        
                /* if account with matching braintreeId exists*/
                if(accWithBTId != null)
                {
                   if(parentAccount != null)
                   {
                       accWithBTId.ParentId =  parentAccount.Id;
                       update accWithBTId; // update the account with matching parent account
                       aResp.account = accWithBTId;
                       aResp.success = 'true';
                   }
                   else
                   {
                       aResp.success = 'false';
                       aResp.error_log = 'Parent Account not found';
                    }
                }/* else if account with matching name exists*/
				else if(accWithName != null)
                {
                    insertAcc = new Account(Name = accName,  ParentId = accWithName.Id);
                }/* if both doesn't match, then create a new account with name */
                else
                {
                    insertAcc = new Account(Name = accName);              
                }
                    
                if(insertAcc != null)
                {
                    insert insertAcc; //insert a new account with matching name
                    aResp.account = insertAcc;
                    aResp.success = 'true';
                }  
            }
            catch(exception e)
            {
                aResp.success = 'false';
                aResp.error_log = e.getMessage();
            }
        }
        /* send back the response with success, error_log and respective account that is updated/inserted */
        accResponse.add(aResp);
        return JSON.serialize(accResponse);
    }
    
    /* wrapper clas to send the response*/
    public class AccountResponse
    {
        public String success;
        public String error_log;
        public Account account;
        public AccountResponse(){}
    }
}