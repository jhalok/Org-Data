public class CustomLoginController {
    
    public String username{get; set;}
    public String password {get; set;}
    
    public pageReference doLogin()
    {  
        return Site.login(username,password,null);
    }
}