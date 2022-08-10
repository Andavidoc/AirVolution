public with sharing class ReverDescMartesBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id, UnitPrice FROM PricebookEntry WHERE Descuento_50__c = false AND Martes_de_descuento__c = true');
    }

    public void execute(Database.BatchableContext BC, List<PricebookEntry> prices){
        for(PricebookEntry p : prices){
            Decimal precio = p.UnitPrice;
            p.UnitPrice = precio / 0.65;
            p.Martes_de_descuento__c = false;
        }
        update prices;
    }

    public void finish(Database.BatchableContext BC){
        
    }
}