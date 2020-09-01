/**
* 
* Description   - This class is used as a controller to fetch the data Of Account & show records according to the user selected picklist 
* value on visulaforce page. 
* 
* Created By    - Alok kumar
* 
* Created Date  - 16/07/2018
* 
* Revision Logs - V_1.0 - Created
*      
* 
*/
public class PaginationController{
        
   //Initilization of accountList It will store the Record from database on the basis of query perfomed  
   public List<Account> accountList = new List<Account>();
    
    //Initilization Of accountOrderByList It will store the sorted Record  
    public List<Account>  accountOrderByList = new List<Account>();
   
    //Declaration of Size, it will by default show 10 records later on it will store the selected picklist value 
    //& display data according to that
    public Integer size{get;set;}
    
  	//Declaration of noOfRecords to store the no of records fetched from the database
    public Integer noOfRecords{get;set;}
    
    //Declaration of type List<SelectOption> to add picklist values to show record according to the selected value
    public List<SelectOption> listOption{get;set;}
    
    //Declaration & initilization of sortDirection
    public String sortDirection = 'ASC';
    
 	//Declaration & initilization of sortExp
    public String sortExp = 'name';
    
    
    //Constructor PaginationController to intilize the variables
    public PaginationController(){
        
        //Initilization of size variable by default it will show the 10 records
        size=10;
        
        //Intilization of List to store the the picklist values 
        listOption =  new List<SelectOption>();
        
        //Adding picklist values to show the record according to the the selected values
        listOption.add(new SelectOption('5','5'));
        listOption.add(new SelectOption('10','10'));
        listOption.add(new SelectOption('20','20'));
        listOption.add(new SelectOption('50','50'));
    }
    
    //Fetching data from database & storing it in to the setCon variable
    public ApexPages.StandardSetController setCon {
        //getter() to fetch record from the database
        get {
            //Condition to check if setCon is having null then storing the fetched record from the database into the accountList 
            if(setCon == null) {  
                //Storing the fetched record from the database into the accountList 
                accountList = Database.query('Select Id, Name, Phone, Website, AccountNumber from Account');
                //Initilization of setCon & assigning the Record stored in the accountList
                setCon = new ApexPages.StandardSetController(accountList);
                //set the default page size of 10
                setCon.setPageSize(size);  
                //ResultSize() fetching the total records stored in setCon & assigning it to the noOfRecords
                noOfRecords = setCon.getResultSize();
            }
            //Returning the Records stored in setCon
            return setCon;
        }
        set;
    }
    
    //refreshedPageSize() to display the no of records on page according to the user selected value
    public void refreshedPageSize(){
        
        //Set the size to show no of records according to the the selected picklist value page
        setCon.setPageSize(Size);
    }
    
    //getAccounts() is used to return the n      
    public List<Account> getAccounts() {
        //returns the records stored in the setCon
        return setCon.getRecords();   
    }
    
    //sortExpression() is used to perform the sorting operation
     public String sortExpression {
        //getter() to return the sortExp value
         get {
            return sortExp;
        }
         //setter() to set the value in sortDirection when column is switched between Ascending and Descending modes
        set {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
            sortExp = value;
        }
    }

	//getSortDirection() method is used to get the value that its either Asc or Desc and it's used in dynamic query to fetch sorted data  
    public String getSortDirection(){
        //Returning the value stored in sortDirection
        return sortDirection;
    }
    
    //setSortDirection() is used to set the value
    public void setSortDirection(String value) {  
        //Assigning the value stored in sortDirection
        sortDirection = value;
    }
    
    //ViewData() method is used to show the shorted data in Asscending or descending order
    public void ViewData() {
        
        //build the full sort expression to use it in fetching data dynamically
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        
        //query the database based on the sortFullexpression
        accountOrderByList = Database.query('Select id,Name,Phone,website,AccountNumber from Account order by   ' + sortFullExp + ' limit 500');
        //Initilization of setCon & assigning the shorted Record stored in the accountOrderByList
        setCon = new ApexPages.StandardSetController(accountOrderByList);
        //Calling refreshedPageSize() to get the pageSize
        refreshedPageSize();
    } 
}