public with sharing class VueloBatch implements Database.Batchable<sObject> {
    Datetime ahora = Datetime.now();
    Datetime ventiCuatro = Datetime.now().addHours(24);
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id, Fecha_y_hora_de_partida__c FROM Product2');
    }

    public void execute(Database.BatchableContext BC, List<Product2> vuelos){
        List<OpportunityLineItem> tiquetes = new List<OpportunityLineItem>();
        List<String> entradaPrecios = new List<String>();
        for (Product2 vuelo : vuelos) {
            if (vuelo.Fecha_y_hora_de_partida__c >= ahora && vuelo.Fecha_y_hora_de_partida__c <= ventiCuatro ) {
                entradaPrecios.add(vuelo.Id);
            }
        }
        if (entradaPrecios.size() > 0) {
            tiquetes = [SELECT Id, Pasajero__r.Name, Pasajero__r.Email, Asiento__c FROM OpportunityLineItem WHERE Product2Id IN : entradaPrecios];
            List<PricebookEntry>  precios = [SELECT Id, UnitPrice, Martes_de_descuento__c, Descuento_50__c FROM PricebookEntry WHERE Descuento_50__c = false AND Product2Id IN : entradaPrecios];
            for (PricebookEntry precio : precios) {
                Decimal valor = precio.UnitPrice;
                if(precio.Martes_de_descuento__c == true){
                    precio.Martes_de_descuento__c = false;
                    precio.Descuento_50__c = true;
                    valor = valor / 0.65;
                    precio.UnitPrice = valor * 0.5;
                } else {
                    precio.Martes_de_descuento__c = false;
                    precio.Descuento_50__c = true;
                    precio.UnitPrice = valor * 0.5;
                }
            }
            update precios;
        }

        if (tiquetes.size() > 0 ) {
            for (Integer i = 0; i < tiquetes.Size(); i++) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                // ! Very importante
                String[] toAddresses = new String[] {tiquetes[i].Pasajero__r.Email};
                mail.setToAddresses(toAddresses);
 
                mail.setReplyTo('Andavidoc@salesforce.com');
                mail.setSenderDisplayName('Air-Volution Support');
                mail.setSubject('Confirmación de Check-In');
                mail.setPlainTextBody('Señor/a ' + tiquetes[i].Pasajero__r.Name + '. Le Informamos que su vuelo despegua en menos de 24 horas. ' +
                                    'Le recordamos que por favor realice su Check-In. Su número de Asiento es : ' + Tiquetes[i].Asiento__c );

                mail.setUseSignature(false);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }


    }

    public void finish(Database.BatchableContext BC){
        
    }
}