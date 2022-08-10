@isTest
public with sharing class VueloTriggerHandlerTest {

    @TestSetup
    static void makeData(){
        Product2 vuelo = new Product2(isactive = true, estado__c = 'En venta', name = 'Vuelo de prueba', Aeropuerto_de_llegada__c = 'a018a00000zWkK2AAK', Aeropuerto_de_partida__c = 'a018a00000zWPl8AAG',
                                    Fecha_y_hora_de_partida__c = (date.today()+1) , Fecha_y_hora_estimada_de_llegada__c = Date.today()+2);
        insert vuelo;
    }

    @isTest
    static void estadoTerminado(){
    Product2 vuelo = [SELECT id, estado__c , name
                        FROM Product2 LIMIT 1];  
        vuelo.estado__c = 'Terminado';
        update vuelo;

        vuelo = [SELECT id, estado__c , name
                        FROM Product2 LIMIT 1];  
        System.assertEquals('Terminado', vuelo.estado__c);
    }

    @isTest
    static void estadoCancelado(){
    Product2 vuelo = [SELECT id, estado__c , name
                        FROM Product2 LIMIT 1];  
        vuelo.estado__c = 'Cancelado';
        vuelo.Motivo_de_cancelaci_n__c = 'aeronaves';
        update vuelo;

        vuelo = [SELECT id, estado__c , name
                        FROM Product2 LIMIT 1];  
        System.assertEquals('Cancelado', vuelo.estado__c);
    }

    @isTest
    static void cancelSinMotivo(){
        Product2 vuelo = [SELECT id, estado__c , name
                        FROM Product2 LIMIT 1];  
        vuelo.estado__c = 'Cancelado';
        try {
            update vuelo;
        } catch (Exception e) {
            system.assert(e.getMessage().contains('Debe agregar un motivo de cancelación'));
        }
       
    }
    
}