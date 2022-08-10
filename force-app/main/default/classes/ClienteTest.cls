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

}
