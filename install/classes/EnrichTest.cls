@isTest
public class EnrichTest {
    
    static testMethod void test1() {
        Account account = new account (name='TEST');
        insert account;
        Enrich.Param p = new Enrich.Param();
        p.accountId = account.id;
        p.apiKey = 'test';
        
        //mock
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('enrichTestResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/xml');
        Test.setMock(HttpCalloutMock.class, mock);       

        Test.startTest();
        Enrich.enrichBillingAddress(new list<Enrich.Param>{p});
        Test.stopTest();
    } 
    
}