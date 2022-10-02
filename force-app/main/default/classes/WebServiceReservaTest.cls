@isTest
public with sharing class WebServiceReservaTest {
    
    @TestSetup
    static void makeData(){
        contact pasajero = new Contact(FirstName = 'Andrés', LastName = 'David', Tipo_de_Identificaci_n__c = 'Cédula de ciudadanía', N_mero_de_Identificaci_n__c = '1017', Email = 'andresarca65@gmail.com');
        insert pasajero;
        Datetime tiempo = Datetime.now();
        List<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>();
        aeropuertos.add(new Aeropuerto__c(Name = 'Aeropuerto Medellín', Ciudad__c = 'Cali'));
        aeropuertos.add(new Aeropuerto__c(Name = 'Aeropuerto Bogotá', Ciudad__c = 'Bogotá'));
        insert aeropuertos;

        avi_n__c avion = new avi_n__c();
        insert avion;

        Product2 vuelo = new Product2(Name = 'vuelo Prueba',Aeropuerto_de_partida__c = aeropuertos[0].Id,
                                     Aeropuerto_de_llegada__c= aeropuertos[1].Id, Fecha_y_hora_de_partida__c = tiempo,
                                     Fecha_y_hora_estimada_de_llegada__c = tiempo.addHours(1), avi_n__c = avion.Id, IsActive = true);
        insert vuelo;

        Id idEstandar = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = idEstandar, Product2Id = vuelo.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 turista = new Pricebook2(Name = 'Tiquetes clase turista', IsActive = true);
        insert turista;
        Pricebook2 negocios = new Pricebook2(Name = 'Tiquetes Negocios', IsActive = true);  
        insert negocios;
        
        PricebookEntry entrada = new PricebookEntry(Pricebook2Id = turista.id, Product2Id = vuelo.Id, UnitPrice = 20000, IsActive = true);
        insert entrada;
    }

    @isTest
     static void reservaClienteViejo(){
        Product2 vuelo = [SELECT Id FROM Product2 LIMIT 1];

        WebServiceReserva.ReservaHttp respuesta = WebServiceReserva.crearReserva('Andrés', 'David', 'Cédula de ciudadanía', '1017', 'andresarca65@gmail.com', Cliente.listaPrecios('Tiquetes clase turista'), vuelo.Id);
        System.assertEquals('Reserva creada exitosamente', respuesta.mensaje);
        System.assert(respuesta.oportunidad != null);
     }

     @isTest
     static void reservaClienteNuevo(){
        Product2 vuelo = [SELECT Id FROM Product2 LIMIT 1];

        WebServiceReserva.ReservaHttp respuesta = WebServiceReserva.crearReserva('Sebas', 'Morales', 'Cédula de ciudadanía', '2030', 'sebastiancho@gmail.com', Cliente.listaPrecios('Tiquetes clase turista'), vuelo.Id);
        System.assertEquals('Reserva creada exitosamente', respuesta.mensaje);
        System.assert(respuesta.oportunidad != null);
     }

     @isTest
     static void reservaExistente(){
        Product2 vuelo = [SELECT Id FROM Product2 LIMIT 1];

        WebServiceReserva.ReservaHttp respuesta = WebServiceReserva.crearReserva('Sebas', 'Morales', 'Cédula de ciudadanía', '2030', 'sebastiancho@gmail.com', Cliente.listaPrecios('Tiquetes clase turista'), vuelo.Id);
        respuesta = WebServiceReserva.crearReserva('Sebas', 'Morales', 'Cédula de ciudadanía', '2030', 'sebastiancho@gmail.com', Cliente.listaPrecios('Tiquetes clase turista'), vuelo.Id);
        System.assertEquals('El pasajero ya cuenta con la siguiente reserva', respuesta.mensaje);
        System.assert(respuesta.oportunidad != null);
     }

     @isTest
     static void reservaPaga(){
        Product2 vuelo = [SELECT Id FROM Product2 LIMIT 1];

        WebServiceReserva.ReservaHttp respuesta = WebServiceReserva.crearReserva('Sebas', 'Morales', 'Cédula de ciudadanía', '2030', 'sebastiancho@gmail.com', Cliente.listaPrecios('Tiquetes clase turista'), vuelo.Id);
        WebServiceReserva.pagarReserva(respuesta.oportunidad.Id, 100000, 'Visa');

        List<Opportunity> oportunidad = [SELECT Id, StageName FROM Opportunity];
        System.assertEquals('Pagado', oportunidad[0].StageName);

     }

     @isTest
     static void reservaNoPagada(){
        Product2 vuelo = [SELECT Id FROM Product2 LIMIT 1];

        WebServiceReserva.ReservaHttp respuesta = WebServiceReserva.crearReserva('Sebas', 'Morales', 'Cédula de ciudadanía', '2030', 'sebastiancho@gmail.com', Cliente.listaPrecios('Tiquetes clase turista'), vuelo.Id);
        string cupo = WebServiceReserva.pagarReserva(respuesta.oportunidad.Id, 10, 'Visa');

        
        System.assertEquals('El cupo de su tarjeta es insuficiente.', cupo);

     }

}
