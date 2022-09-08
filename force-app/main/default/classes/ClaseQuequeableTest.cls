@isTest
public with sharing class ClaseQuequeableTest {

    //Inserta 50 cuentas  
    @TestSetup
    static void makeData(){
        List<Account> accts = new List<Account>();
        for(integer i = 0; i < 50; i++){
            accts.add(new Account(name = 'test'+i));
        }

        insert accts;
    }

    //Verifica que se hayan creado 50 cuentas con un Serial diferente de null
    @IsTest
    static void methodName(){        

        ClaseQuequeable actualizar = new ClaseQuequeable();

        Test.startTest();
        System.enqueueJob(actualizar);
        Test.stopTest();
        List<Account> accts = [SELECT Id 
                                FROM Account 
                                WHERE SLASerialNumber__c != null
                               ];
        
        System.assertEquals(50,accts.size());
    }
}