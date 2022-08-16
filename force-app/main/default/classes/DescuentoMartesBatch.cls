public with sharing class DescuentoMartesBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id, UnitPrice FROM PricebookEntry WHERE Descuento_50__c = false AND Martes_de_descuento__c = false');
    }

    public void execute(Database.BatchableContext BC, List<PricebookEntry> prices){
        for(PricebookEntry p : prices){
            Decimal precio = p.UnitPrice;
            p.UnitPrice = precio * 0.65;
            p.Martes_de_descuento__c = true;
        }
        update prices; 

        Profile ventas = [SELECT Id, Name From PRofile Where Name = 'Grupo de ventas' LIMIT 1];

        List<User> usuarios = [SELECT id FROM User WHere ProfileId =: ventas.id AND isActive = true ];
        List<Event> eventos = new List<Event>();
        if(usuarios.size() > 0){
            for (User u : usuarios) {
                eventos.add(new Event(OwnerId = u.Id, StartDateTime = Datetime.now(), EndDateTime = Datetime.now().addHours(15),
                            Subject = 'Martes de descuento '));
            }
            insert eventos;
        }

    }

    public void finish(Database.BatchableContext BC){
        
    }
}