public class NewCaseListController {
	
    public static List<Case> getNewCases(){
        List<Case> caseData = [Select Id, CaseNumber From Case Where Status = 'NEW'];
        System.debug('caseData-----'+caseData);
        return caseData;
    }
}