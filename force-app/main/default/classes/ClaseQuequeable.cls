public with sharing class ClaseQuequeable implements Queueable{
    
    
    public void execute(QueueableContext context){
        List<Account> accts = [SELECT ID FROM Account WHERE SLASerialNumber__c = null];

        for(account c : accts){
            c.SLASerialNumber__c = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 10);
        }
        update accts;
    }
}