@isTest
public with sharing class TripulacionRequeridaTest {
    
    
    @TestSetup
    static void makeData(){
        List<Contact> auxiliares = new List<Contact>();
        for(Integer i = 0; i < 3; i++){
        contact contacto = new contact(LastName = 'Facundo '+i, Tipo_de_Identificaci_n__c = 'Cédula de ciudadanía', 
                                        N_mero_de_Identificaci_n__c = '1255'+i, N_mero_de_pasaporte__c = '1020'+i, RecordTypeId = '0128a000000YVvvAAG',
                                        Tipo_de_contrato__c = 'Indefinido');
        auxiliares.add(contacto);
        }
        insert auxiliares; 

        Avi_n__c avion = new Avi_n__c(Numero_de_pasajeros_clase_de_negocio__c = 30, N_mero_de_pasajeros_clase_turista__c = 222);
        insert avion;

        List<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>();
        for (Integer i = 0; i<2 ; i++) {
            Aeropuerto__c aeropuerto = new Aeropuerto__c(Name = 'Vuelo'+i );
            aeropuertos.add(aeropuerto);
        }
        insert aeropuertos;

        Product2 vuelo = new Product2(Name = 'AE-0001',
                                 Avi_n__c = avion.Id,
                                 Fecha_y_hora_de_partida__c = datetime.now()+2,
                                 Fecha_y_hora_estimada_de_llegada__c = (datetime.now()+2).addHours(1),
                                 Aeropuerto_de_partida__c = aeropuertos[0].Id,
                                 Aeropuerto_de_llegada__c = aeropuertos[1].Id,
                                 IsActive = true,
                                 Estado__c = 'En venta');
        insert vuelo;

        List<Contact> obtConct = [SELECT Id FROM Contact WHERE LastName != 'Facundo 2'];
        Product2 vuelos = [SELECT Id FROM Product2 LIMIT 1];
        
        AuxiliaresxVuelos__c auxiliar  = new AuxiliaresxVuelos__c( Contacto__c = obtConct[0].Id, Vuelo__c = vuelos.Id);
        
        AuxiliaresxVuelos__c auxiliar2  = new AuxiliaresxVuelos__c( Contacto__c = obtConct[1].Id, Vuelo__c = vuelos.Id);
        insert auxiliar;
        insert auxiliar2;
    }

    //Se comprueba que el el metodo obtenga el vuelo dentro del rango de obtención
    @isTest
    private static void obtieneUnVuelo(){
            List<TripulacionRequerida.vuelo> vuelos = TripulacionRequerida.obternerVuelos();
            System.assertEquals(1, vuelos.size());
    }

    //
    @isTest
    private static void errorEnVuelo(){
        Avi_n__c avion = [SELECT Id FROM Avi_n__c LIMIT 1];
        delete avion;
        try{
            List<TripulacionRequerida.vuelo> vuelos = TripulacionRequerida.obternerVuelos();
        } catch (Exception e){
            List<Avi_n__c> listaAvion = [SELECT Id FROM Avi_n__c LIMIT 1];
            System.assertEquals(0, listaAvion.size());
        }
    }

    @isTest
    private static void obtieneAuxiliares(){
        Product2 vuelos = [SELECT Id FROM Product2 LIMIT 1];
        List<TripulacionRequerida.opcion> opciones = TripulacionRequerida.obtenerAuxiliares(vuelos.Id);

        System.assertEquals(5, opciones.size());

    }

    @isTest
    private static void guardaAuxiliares(){
        Product2 vuelo = [SELECT Id FROM Product2 LIMIT 1];
        List<Contact> auxiliares = [SELECT ID FROM Contact];
        List<String> listaAuxiliares = new List<String>();
        for (Contact c : auxiliares) {
            listaAuxiliares.add((string)c.Id);
        }
        TripulacionRequerida.saveAuxiliares(listaAuxiliares, vuelo.Id);
        Product2 vuelos = [SELECT Id FROM Product2 LIMIT 1];
        List<TripulacionRequerida.opcion> opciones = TripulacionRequerida.obtenerAuxiliares(vuelos.Id);
        System.assertEquals(5, opciones.size());
    }

}