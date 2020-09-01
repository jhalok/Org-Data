public class ShouldIRun{
    Public Static boolean allow = true;
    public static void stopTrigger(){
        allow = false;
    }
    public static boolean canIRun(){
        return allow;
    }
}