@isTest
public with sharing class AccounTriggerHandlerTest {
    
    @isTest
    private static void casoCreado(){
        Account cuenta = new Account(Name = 'Cuenta de Test', CustomerPriority__c = 'High');
        insert cuenta;

        Case casoCreado = [SELECT Subject FROM Case Limit 1];
        Account cuentaobtenida = [SELECT Id, SLA__C FROM Account LIMIT 1];
        System.assertEquals('Dedupe this Account', casoCreado.Subject);
        System.assertEquals('Gold', cuentaobtenida.SLA__C);

        cuenta.CustomerPriority__c = 'Medium';
        Cuenta.SLA__C = null;
        update cuenta;
        
        cuentaobtenida = [SELECT Id, SLA__C FROM Account LIMIT 1];
        System.assertEquals('Silver', cuentaobtenida.SLA__C);
  
        cuenta.CustomerPriority__c = 'Low';
        Cuenta.SLA__C = null;
        update cuenta;

        
        cuentaobtenida = [SELECT Id, SLA__C FROM Account LIMIT 1];
        System.assertEquals('Bronze', cuentaobtenida.SLA__C);
       
        List<Case> casos = [SELECT Id From case];
        delete casos;

        delete cuenta;
        undelete cuenta;
      
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

    @isTest
    static void cuentaError(){
            Account cuenta = new Account(Name = 'Cuenta de Test', CustomerPriority__c = 'High', SLA__C = 'Silver');
        try {
            insert cuenta;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('La proridad no conincide con el SLA'));
        }
    }



}