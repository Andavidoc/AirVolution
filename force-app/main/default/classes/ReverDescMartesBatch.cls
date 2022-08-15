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

        Profile ventas = [SELECT Id, Name From PRofile Where Name = 'Grupo de ventas' LIMIT 1];

        List<User> usuarios = [SELECT id FROM User WHere ProfileId =: ventas.id AND isActive = true ];
        Set<String> listaUsuarios = new Set<String>();
        if(usuarios.size() > 0){
            for (User u : usuarios) {
                listaUsuarios.add(u.Id);
            }
            CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName='cierre_descuento'];
        
            // Create a new custom notification
            Messaging.CustomNotification notification = new Messaging.CustomNotification();

            // Set the contents for the notification
            notification.setTitle('Cierre de descuento');
            notification.setBody('El horario de descuento ha finalizado');

            // Set the notification type and target
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(prices[0].Id);
        
            // Actually send the notification
        
            notification.send(listaUsuarios);
        
        }
    }

    public void finish(Database.BatchableContext BC){
        
    }
}