public without sharing class AccounTriggerHandler implements TriggerHandler {
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public AccounTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }
    
    public void beforeInsert(List<Account> newAccounts) {
        sinfecha(newAccounts);
        numeroDeCuenta(newAccounts);
        prioridadDeCuenta(newAccounts);
    }
    public void beforeUpdate(List<Account> oldAccounts, List<Account> newAccounts, Map<ID, SObject> oldAccountMap, Map<ID, SObject> newAccountMap) {
        sinfecha(newAccounts);
        numeroDeCuenta(newAccounts);
        prioridadDeCuenta(newAccounts);
    }
    public void beforeDelete(List<Account> oldAccounts, Map<ID, SObject> oldAccountMap) {
        // helper.doTask5();
    }
    public void afterInsert(List<Account> newAccounts, Map<ID, SObject> newAccountMap) {
        DupeReminder(newAccounts);
    }
    public void afterUpdate(List<Account> oldAccounts, List<Account> newAccounts, Map<ID, SObject> oldAccountMap, Map<ID, SObject> newAccountMap) {
        // helper.doTask4();
    }
    public void afterDelete(List<Account> oldAccounts, Map<ID, SObject> oldAccountMap) {
        // helper.doTask3();
    }
    public void afterUndelete(List<Account> newAccounts, Map<ID, SObject> newAccountMap) {
        // helper.doTask4();
    }
    
    // Genera el año actual para las cuentas sin año de inicio
    public static void sinfecha(List<Account> cuenta){
        for(Account a: cuenta){
            if(a.YearStarted == null){
                a.YearStarted = String.ValueOf(Date.today().year());
            }
        }
    }
    
    //Genera un número de cuenta aleatorio
    public static void numeroDeCuenta(List<Account> cuenta){
        for(Account a: cuenta){
            if(a.AccountNumber == null){
                a.AccountNumber = String.valueOf((Integer.valueOf(Math.Random() * 10000000)));
            }
        }
    }
    
    //Verifica el estado de la prioridad para elegír el SLA Correspondiente
    public static void prioridadDeCuenta(List<Account> cuenta){
        for(Account a: cuenta){
            
            if(a.SLA__c == null){
                switch on a.CustomerPriority__c {
                    when  'High'{
                        a.SLA__c = 'Gold'; 
                    }
                    when  'Medium'{
                        a.SLA__c = 'Silver'; 
                    }
                    when  'Low'{
                        a.SLA__c = 'Bronze'; 
                    }
                    when else {
                        System.debug('');
                    }
                }
            }
            else if((a.CustomerPriority__c == 'High' && a.SLA__c != 'Gold') || (a.CustomerPriority__c == 'Medium' && a.SLA__c != 'Silver') || (a.CustomerPriority__c == 'Low' && a.SLA__c != 'Bronze')){  
                a.CustomerPriority__c.addError('La proridad no conincide con el SLA');
            }
        }
    }
    
    //Crea un caso para cada cuenta
    public static void DupeReminder(List<Account> cuenta){
        List<Case> casos = new List<Case>();
        for(Account acc: cuenta){
            Case c = new Case();
            c.subject = 'Dedupe this Account';
            c.OwnerId = acc.OwnerId;
            c.AccountId = acc.Id;
            casos.add(c);
        }
        insert casos;
    }
    
}