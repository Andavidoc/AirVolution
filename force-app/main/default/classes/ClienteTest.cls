@isTest
public with sharing class ClienteTest {

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

        Opportunity reserva = new Opportunity(Name = 'A', Titular_de_reserva__c = id, CloseDate = System.today(), StageName = 'Pre-venta');
        insert reserva;
    
        //Data para metodo obtenerVuelo        
        List<Product2> Vuelos = new List<Product2>();
        for(Integer i = 0; i < 2; i++){
            Product2 vuelo = new Product2(Name = 'AE-2552', Fecha_y_hora_de_partida__c = System.today().addDays(i));
            Vuelos.add(vuelo);
        }
        insert Vuelos;

        String idV = Vuelos[0].Id;
        Pricebook2 listP = new Pricebook2(Name = 'Tiquetes clase turista');

        insert listP;
        PricebookEntry entrada = new PricebookEntry(Pricebook2Id = listP.Id, Product2Id	= idV, UnitPrice = 10000);
        insert entrada;
    
    }
    
    @isTest
    static void contactoSinReserva(){
        Cliente.CtoReserva test = Cliente.clienteReserva('10' , 'Tarjeta de Identidad');
        System.assert(test.contacto != null);
        System.assert(test.oportunidad == null);
    }

    @isTest
    static void contactoConReserva(){
        Cliente.CtoReserva test = Cliente.clienteReserva('11' , 'Tarjeta de Identidad');
        System.assert(test.contacto != null);
        System.assert(test.oportunidad != null);
    }

    @isTest
    static void busquedaFallida(){
        Cliente.CtoReserva test = Cliente.clienteReserva('1' , 'Tarjeta de Identidad');
        System.assert(test.contacto == null);
        System.assert(test.oportunidad == null);
    }

    @isTest
    static void obtieneVuelos(){
        Pricebook2 listaPrecio = [SELECT id From Pricebook2 LIMIT 1];
        string idlistaPrecio = listaPrecio.Id;

        List<Cliente.vueloWrapper> vuelos = Cliente.obtenerVuelos(idlistaPrecio);

        System.assertEquals(1, vuelos.size());

    }

}