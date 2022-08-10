@isTest
public with sharing class AccounTriggerHandlerTest {
    
    @isTest
    private static void casoCreado(){
        Account cuenta = new Account(Name = 'Cuenta de Test');
        insert cuenta;

        Case casoCreado = [SELECT Subject FROM Case Limit 1];

        System.assertEquals('Dedupe this Account', casoCreado.Subject);

    }

    @isTest
    private static void casosMasivos(){
    List<Account> cuentas = new List<Account>();
    for(Integer i = 0; i < 200; i++){
        Account cuenta = new Account(Name = 'Cuenta de Test '+ i) ;
        cuentas.add(cuenta);
    }
    insert cuentas;

    List<Case> casos = new List<Case>();
    casos = [SELECT Id FROM Case];

    System.assertEquals(200, casos.size());
}

}