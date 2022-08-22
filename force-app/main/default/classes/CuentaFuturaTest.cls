@isTest
public with sharing class CuentaFuturaTest {
    
    @isTest
    public static void cuentafuruta(){
        
        Test.startTest();
        Cuenta.usaFuturo('Test');
        Test.stopTest();

        List<Account> diferente = [SELECT Id FROM Account WHERE SLASerialNumber__c != null];

        system.assertEquals(1, diferente.size());
    }

}