@isTest
public with sharing class ControladorTiqueteTest {

    @TestSetup
    static void makeData(){
        List<Contact> lista = new List<Contact>();
    for(Integer i = 0; i < 2; i++){
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
    List<OpportunityLineItem> tiquetes = new List<OpportunityLineItem>();
    
    for(Integer i = 0; i < 2; i++){
        OpportunityLineItem tiquete = new OpportunityLineItem(OpportunityId = res.Id, Product2Id = idV, Pasajero__c = lista[i].Id);
        tiquetes.add(tiquete);
    }
    insert tiquetes;
    }

    @isTest
    public static void prueba() {
        Opportunity reserva = [SELECT id FROM Opportunity LIMIT 1];
        PageReference pageRef = Page.ReservaPDF;
        pageRef.getparameters().put('recordId', reserva.id);  
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController sc = new Apexpages.StandardController(reserva);
        ControladorTiquete ext = new  ControladorTiquete(sc);
        List<Object> tiq = ext.tiquetes;
        
        System.assertEquals(2, tiq.size());

    }
}