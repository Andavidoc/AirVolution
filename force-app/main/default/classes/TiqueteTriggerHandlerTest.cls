@isTest
public with sharing class TiqueteTriggerHandlerTest {
    
@TestSetup
static void makeData(){
    List<Contact> lista = new List<Contact>();
    for(Integer i = 0; i < 20; i++){
        Contact cto = new Contact(FirstName = 'Andrés '+i, LastName = 'David', 
                                Tipo_de_Identificaci_n__c = 'Cedula de Extranjería',
                                N_mero_de_Identificaci_n__c = String.valueof(i));
        lista.add(cto);
    }
    insert lista;
    String id = lista[0].Id;
    //Insertar avion 
    avi_n__c avion = new avi_n__c(Tipo__c  = 'Airbus A330', Numero_de_pasajeros_clase_de_negocio__c = 1, 
    N_mero_de_pasajeros_clase_turista__c = 0);
    insert avion;
    //Inserta Aeropuertos
    List<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>();
    for (Integer i = 0; i<2 ; i++) {
        Aeropuerto__c aeropuerto = new Aeropuerto__c(Name = 'Vuelo'+i );
        aeropuertos.add(aeropuerto);
    }
    insert aeropuertos;

    String idAvion = avion.Id;
    List<Product2> Vuelos = new List<Product2>();
    for(Integer i = 0; i < 2; i++){
        Product2 vuelo = new Product2(Name = 'AE-2552', 
                                    Fecha_y_hora_de_partida__c = Datetime.now().addHours(10), Fecha_y_hora_estimada_de_llegada__c = Datetime.now().addHours(12),
                                    avi_n__c = idAvion, Aeropuerto_de_partida__c = aeropuertos[0].Id,
                                    Aeropuerto_de_llegada__c = aeropuertos[1].Id );
        Vuelos.add(vuelo);
    }
    insert Vuelos;
    String idV = Vuelos[0].Id;
    Id idEstandar = Test.getStandardPricebookId();
    //Insertar entrada de precios estandar
    PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = idEstandar, Product2Id = idV,
                                                      UnitPrice = 10000, IsActive = true,
                                                      Martes_de_descuento__c =  true,
                                                      Descuento_50__c = false);
    insert standardPrice;
    
    Pricebook2 negocios = new Pricebook2(Name = 'Tiquetes Negocios', IsActive = true);
    insert negocios;

    
    Pricebook2 turista = new Pricebook2(Name = 'Tiquetes clase turista', IsActive = true);
    insert turista;
    
    PricebookEntry entrada = new PricebookEntry(Pricebook2Id = negocios.id, Product2Id = idV, 
                                                UnitPrice = 20000, isActive = true,
                                                Martes_de_descuento__c =  true,
                                                Descuento_50__c = false);
    insert entrada;
    
    
    Opportunity res = new Opportunity(Name = 'A', Titular_de_reserva__c = id, 
                                    CloseDate = System.today(), StageName = 'Pre-venta', 
                                    Pricebook2Id = negocios.Id);
    Insert res;
    
}

@isTest
static void sobreventa(){
    try {
        List<Contact> pasajeros = [SELECT Id FROM Contact];
        Opportunity reserva = [SELECT Id FROM Opportunity LIMIT 1];
        Product2 vuelo = [SELECT Id FROM Product2 LIMIT 1];

        List<OpportunityLineItem> tiquetes = new List<OpportunityLineItem>();
        for (Integer i = 0; i < 5;  i++) {
            tiquetes.add(new OpportunityLineItem(OpportunityId = reserva.Id, Product2Id = vuelo.Id, Pasajero__c = pasajeros[i].Id));
        }
        insert tiquetes;
        
        OpportunityLineItem sobreventa = new OpportunityLineItem(OpportunityId = reserva.Id, Product2Id = vuelo.Id, Pasajero__c = pasajeros[5].Id);
        insert sobreventa;

    } catch (Exception e) {
        system.assert(e.getMessage().contains('No es posible sobrevender los tiquetes'));
        
    }
}

@isTest
static void PasajeroYEquipaje(){
    Contact pasajero = [SELECT Id FROM Contact LIMIT 1];
    Opportunity reserva = [SELECT Id FROM Opportunity LIMIT 1];
    Product2 vuelo = [SELECT Id FROM Product2 LIMIT 1];

    OpportunityLineItem equipaje = new OpportunityLineItem(OpportunityId = reserva.Id, Product2Id = vuelo.Id);
    insert equipaje;

    OpportunityLineItem resultado = [SELECT Id, Equipaje_permitido__c,Pasajero__c FROM OpportunityLineItem LIMIT 1];
    System.assertEquals('Personal;Maleta de cabina;Maleta de bodega', resultado.Equipaje_permitido__c);
    System.assert(resultado.Pasajero__c != null);

}



}
