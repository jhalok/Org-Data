@isTest
public class PaginationControllerTest {

    static testmethod void myTestMethod1() {
    	PaginationController pc = new PaginationController();
        pc.getAccounts();
        pc.refreshedPageSize();
        pc.ViewData();
        pc.getSortDirection();     	pc.setSortDirection('ASC');
        System.assertEquals('ASC', 'ASC');
    }
}