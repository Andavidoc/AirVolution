@isTest
public with sharing class CuentaScheduledTest {
    
    string sch = '0 0 1 1/1 * ? *';

    @TestSetup
    static void makeData(){
        List<Account> accts = new List<Account>();
        for(integer i = 0; i < 50; i++){
            accts.add(new Account(name = 'test'+i));
        }

        insert accts;
    }

    @IsTest
    static void methodName(){        
        CuentaScheduled diariamente = new CuentaScheduled();
        
        Test.startTest();

            string sch = '0 0 1 1/1 * ? *'; 
            string jobID = System.schedule('llamada Batch', sch, new CuentaScheduled());
        Test.stopTest();
        List<Account> accts = [SELECT Id 
                                FROM Account 
                                WHERE SLASerialNumber__c != null
                               ];
        
        System.assertEquals(50,accts.size());
    }
    
}