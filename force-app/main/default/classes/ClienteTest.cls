@isTest
public class ClienteTest {
    //Se insertan contactos, vuelos, reservas , aeropuertos, entradas de precio y aviones para un test más preciso 
    @TestSetup
    static void makeData(){
        List<Contact> contactos = new List<Contact>();
        for (Integer i = 0; i < 2 ; i++) {
            contact contacto = new contact(Tipo_de_Identificaci_n__c = 'Tarjeta de Identidad',
                                        N_mero_de_Identificaci_n__c = '1'+i,
                                        FirstName = 'Andrés', LastName = 'David');
            contactos.add(contacto);
        }
        insert contactos;
        string id = contactos[1].Id;

        avi_n__c avion = new avi_n__c(Tipo__c = 'Boening 770', Numero_de_pasajeros_clase_de_negocio__c = 32,N_mero_de_pasajeros_clase_turista__c = 200);
        insert avion;

        List<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>();
        for (Integer i = 0; i<2 ; i++) {
            Aeropuerto__c aeropuerto = new Aeropuerto__c(Name = 'Vuelo'+i );
            aeropuertos.add(aeropuerto);
        }
        insert aeropuertos;

        //Data para metodo obtenerVuelo        
        List<Product2> Vuelos = new List<Product2>();
        for(Integer i = 0; i < 2; i++){
            String estado;
            
            if(i == 0){
                estado = 'Check in';
            }
            else{
                estado = 'En venta';
            }

            Product2 vuelo = new Product2(Name = 'AE-00'+i, Fecha_y_hora_de_partida__c = System.today().addDays(i+1),Estado__c = estado,
                                            Fecha_y_hora_estimada_de_llegada__c = System.today().addDays(i+2),Aeropuerto_de_partida__c = aeropuertos[0].Id,
                                            Aeropuerto_de_llegada__c = aeropuertos[1].Id, avi_n__c = avion.Id, IsActive = true);
            Vuelos.add(vuelo);
            system.debug(System.today().addDays(i+1));

            system.debug(System.today().addDays(i+2));
        }

        insert Vuelos;
        String idV = Vuelos[1].Id;
        System.debug(idV);

        System.debug(Vuelos[1].Name);
        
        Id idEstandar = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = idEstandar, Product2Id = idV, UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 turista = new Pricebook2(Name = 'Tiquetes clase turista', IsActive = true);
        insert turista;
        Pricebook2 negocios = new Pricebook2(Name = 'Tiquetes Negocios', IsActive = true);  
        insert negocios;
        
        PricebookEntry entrada = new PricebookEntry(Pricebook2Id = turista.id, Product2Id = idV, UnitPrice = 20000, IsActive = true);
        insert entrada;
        
        Opportunity reserva = new Opportunity(Name = 'A', Titular_de_reserva__c = id, CloseDate = System.today(), StageName = 'Pre-venta', Pricebook2Id = turista.Id);
        insert reserva;
    }
    
    
    //Verifica que al ingresar un contacto sin reserva, el retorno de contacto sea diferente de nulo, y la reserva sea nula
    @isTest
    static void contactoSinReserva(){
        Cliente.CtoReserva test = Cliente.clienteReserva('10' , 'Tarjeta de Identidad');
        System.assert(test.contacto != null);
        System.assert(test.oportunidad == null);
    }
    
    //Verifica que al ingresar un contacto con reserva, el retorno de ambos objetos, sea diferente de nulo
    @isTest
    static void contactoConReserva(){
        Cliente.CtoReserva test = Cliente.clienteReserva('11' , 'Tarjeta de Identidad');
        System.assert(test.contacto != null);
        System.assert(test.oportunidad != null);
    }
    
    //Verifica que al ingresar un contacto inexistente, el retorno de ambos objetos, sea nulo
    @isTest
    static void busquedaFallida(){
        Cliente.CtoReserva test = Cliente.clienteReserva('1' , 'Tarjeta de Identidad');
        System.assert(test.contacto == null);
        System.assert(test.oportunidad == null);
    }

    //Verifica que de los dos vuelos existentes, solo traiga el que tiene en su lista de precios, tiquetes clase turista
    @isTest
    static void obtieneVuelos(){
        Pricebook2 listaPrecio = [SELECT id From Pricebook2 WHERE NAme = 'Tiquetes clase turista' LIMIT 1];
        string idlistaPrecio = listaPrecio.Id;

        List<Cliente.vueloWrapper> vuelos = Cliente.obtenerVuelos(idlistaPrecio);

        System.assertEquals(1, vuelos.size());

    }

    //verifica que Id obtenido por el metodo, sea igual al que se obtiene por una busqueda SOQL
    @isTest
     static void nombrePricebook(){
        Pricebook2 listaPrecio = [SELECT id,Name From Pricebook2 WHERE NAme = 'Tiquetes clase turista' LIMIT 1];
        string idAComparar = listaPrecio.Id;
        
        string id = Cliente.listaPrecios('Tiquetes clase turista');
        System.assertEquals(idAComparar, id);
    }

    // Verifica que la creación de tiquetes mediante el metodo, funcione correctamente
    @isTest
    static void crearTiquete(){
        Contact contacto = [SELECT Id From Contact WHERE N_mero_de_Identificaci_n__c = '11' LIMIT 1];
        string idContact = contacto.Id;

        system.debug(contacto);

        Opportunity reserva = [SELECT Id FROM Opportunity LIMIT 1];
        string idReserva = reserva.Id;

        system.debug(contacto +''+ reserva);

        Product2 vuelo = [SELECT Id FROM Product2 Where Estado__c = 'En venta' Limit 1];
        string idVuelo = vuelo.Id;

        system.debug(idReserva +' '+ idVuelo +' '+ idContact);

        Cliente.crearTiquete(idReserva, idVuelo, idContact);
        
        List<OpportunityLineItem> tiquetes = [Select Id FROM OpportunityLineItem LIMIT 10];
        
        System.assertEquals(1, tiquetes.size());
    }
}