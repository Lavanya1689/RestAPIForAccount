# RestAPIForAccount

Introduction:

This project is about creating a Rest API end point in Salesforce that updates the Account object. A BrainTreeId and Name is given in the request body. When a request is received, the account object is queried with matching BrainTreeId on the Account. 
(i) If it does exist then we need to query the accounts again to see if there is parent account with the name matching from the request body and update the previously matched account's parent id with the lateral one. 
(ii) If it doesn't exist then query the Accounts with matching Name, if there is a match create a new Account with that name and assign parentId to the matching account, if there is no match then just create a new account with that name

Following are the points which explains about the classes, my assumptions and ideas 

1. Firstly, I have created a field called BraintreeId on Account object, which is an external Id custom field
2. I created a Rest class named 'RestAccountUpdate' which grabs the endpoint and pass the request body to a helper class. It also handles the responseString, the status code of the response and finally returns the responseString to the external system.
3. The actual logic is handled in the Helper class named AccountUpdateHelper. This class takes the request body from the Rest class, deserializes and converts it into a map from String to object. A query is issued on Account based on the conditions given above in the project introduction. Based on each criteria the account is either updated or inserted (You can refer to the class for further details). I have also created wrapper class that helps in sending back the response to the external system. The wrapper class contains 3 parameters a) success b) errorlog c) account object. The success is a Boolean string, which passes either true/false into the response string based on the output of the helper class, The error_log contains the error string that is captured across the class if there is any error. The Account object is passed when there is an update or insert on that respective account.
4. Here is the JSON string I have used across the classes for my internal testing as well as in my test classes.

          /*
            '{' + 
                ' \"braintree_Id\" :\"123456\",' +
                ' \"Name\" : \"AccountForDemo\"' + 
                '}';
        	*/
5. There are two test classes one for the Rest class called RestAccountUpdateTest and the other one is for helper class called AccountUpdateHelperTest. Both have tets coverage of 90% and 89% respectively.
6. I have added comments all through the classes for better understanding.
