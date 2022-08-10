@isTest
public with sharing class CuentaFuturaTest {
    @isTest
    public static void metodoFuturo(){
        Account cuenta = new Account(Name = 'Test',SLASerialNumber__c = '0' );
        insert cuenta;
        Test.startTest();
        CuentaFutura.agregarNumero(cuenta.Id);
        Test.stopTest();

        List<Account> diferente = [SELECT Id FROM Account WHERE SLASerialNumber__c != '0'];

        system.assertEquals(1, diferente.size());
        
    }

}