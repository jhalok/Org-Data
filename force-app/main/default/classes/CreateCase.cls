global class CreateCase {
	
    @invocableMethod(label='Create Case')
    global static List<Case> CreateCaseMakePayment(List<inputForm> Input){
        
        List<Account> AccountsList = [SELECT Id, Name
                                     FROM Account
                                     WHERE Name =: Input[0].AccName];
        List<Case> responseData = new List<Case>();
        Case ca = new Case();
        ca.Subject = 'Problema';
        ca.Origin = 'Bot';
        ca.AccountId = AccountsList[0].id;
        ca.Status = 'New';
        ca.Description = input[0].description;
        
        insert ca;
        
        case CaseNr = new Case();
        CaseNr = [SELECT subject,Origin,AccountId,Status, CaseNumber
                 FROM Case
                 WHERE id=:ca.id];
        responseData.add(CaseNr);
        return responseData;
    }
    
    global class inputform {
        
        @invocableVariable
        global string AccName;
        
        @invocableVariable
        global string Description;
    }
}