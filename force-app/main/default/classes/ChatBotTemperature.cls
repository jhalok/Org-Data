public with Sharing Class ChatBotTemperature
{
    public class ChatBotTempOutput{
        @InvocableVariable(required= true)
        public String City ;

        @InvocableVariable(required= true)
        public Integer Temp ;
    }

    public class ChatBotTempInput{
        @InvocableVariable(required= true)
        public String City ;
    }

    @InvocableMethod(Label ='Get Temperature' description='return temp')
    public static List<ChatBotTempOutput> getTemperature(List<ChatBotTempInput> input)
    {
         List<ChatBotTempOutput> lstOutput = new List<ChatBotTempOutput>();
         for( ChatBotTempInput ChatBI : input){
             ChatBotTempOutput obj = new ChatBotTempOutput();
             obj.City = ChatBI.City;
             obj.Temp = 10; // You can make some callout to get real Tem
             lstOutput.add(obj);
         }
         return  lstOutput;     
    }
}