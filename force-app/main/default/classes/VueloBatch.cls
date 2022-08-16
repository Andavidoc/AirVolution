public with sharing class VueloBatch implements Database.Batchable<sObject> {
    Datetime ahora = Datetime.now();
    Datetime ventiCuatro = Datetime.now().addHours(24);
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id, Fecha_y_hora_de_partida__c FROM Product2');
    }

    public void execute(Database.BatchableContext BC, List<Product2> vuelos){
        List<String> entradaPrecios = new List<String>();
        for (Product2 vuelo : vuelos) {
            if (vuelo.Fecha_y_hora_de_partida__c >= ahora && vuelo.Fecha_y_hora_de_partida__c <= ventiCuatro ) {
            entradaPrecios.add(vuelo.Id);
            }
        }
        if (entradaPrecios.size() > 0) {
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


    }

    public void finish(Database.BatchableContext BC){
        
    }
}
