@isTest public with sharing class ClimaTest {
    @TestSetup
    static void makeData(){
        Datetime tiempo = Datetime.now();
        List<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>();
        aeropuertos.add(new Aeropuerto__c(Name = 'Aeropuerto Medellín', Ciudad__c = 'Cali', posici_n__Latitude__s = 10,  posici_n__Longitude__s = 10));
        aeropuertos.add(new Aeropuerto__c(Name = 'Aeropuerto Bogotá', Ciudad__c = 'Bogotá', posici_n__Latitude__s = 10,  posici_n__Longitude__s = 10));
        insert aeropuertos;

        avi_n__c avion = new avi_n__c();
        insert avion;

        Product2 vuelo = new Product2(Name = 'vuelo Prueba',Aeropuerto_de_partida__c = aeropuertos[0].Id,
                                     Aeropuerto_de_llegada__c= aeropuertos[1].Id, Fecha_y_hora_de_partida__c = tiempo.addMinutes(30),
                                     Fecha_y_hora_estimada_de_llegada__c = tiempo.addHours(2), avi_n__c = avion.Id, IsActive = true);
        insert vuelo;
    }


    @isTest
    static void climaPArtida(){
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ClimaMock');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        // Call method to test
        
        Clima.climasPArtida();
        test.stopTest();

        List<Clima__c> clima = [SELECT Id FROM clima__c WHERE Temperatura__c = 30];

        System.assertEquals(1, clima.size());
    }

    @isTest
    static void climaLLegada(){
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ClimaMock');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        // Call method to test
        
        Clima.climasLlegada();
        test.stopTest();

        List<Clima__c> clima = [SELECT Id FROM clima__c WHERE Temperatura__c = 30];

        System.assertEquals(1, clima.size());
    }
}