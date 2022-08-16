@isTest
public with sharing class ReservaTriggerHandlerTest {
    
    @TestSetup
    static void makeData(){
        Contact contacto = new contact(FirstName = 'Rodrigo', LastName='Castaño');
        insert contacto;
    }

    @isTest
    private static void creaNombreReserva(){
        contact contacto = [SELECT Name FROM Contact Limit 1];

        Opportunity reserva = new Opportunity(Name='Reserva de prueba', CloseDate= date.today(), StageName='Pre-venta', Titular_de_reserva__c = contacto.Id);
        insert reserva;

        reserva = [SELECT Name FROM Opportunity LIMIT 1] ;
        update reserva;
        System.assert(reserva.Name.contains('RodrigoCastaño'));

        delete reserva;
        undelete reserva;
    }

    @isTest
    private static void creaReservaCompletada(){
        contact contacto = [SELECT Name FROM Contact Limit 1];

        Opportunity reserva = new Opportunity(Name='Reserva de prueba', CloseDate= date.today(), StageName='Completado', Titular_de_reserva__c = contacto.Id);
        try {
            insert reserva;

            reserva = [SELECT Name FROM Opportunity LIMIT 1] ;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Para completar o pagar una reserva, esta debe tener por lo menos un vuelo asignado.'));
        }
    }

    @isTest
    private static void creaReservapagada(){
        contact contacto = [SELECT Name FROM Contact Limit 1];

        Opportunity reserva = new Opportunity(Name='Reserva de prueba', CloseDate= date.today(), StageName='Pagado', Titular_de_reserva__c = contacto.Id);
        try {
            insert reserva;
            reserva = [SELECT Name FROM Opportunity LIMIT 1] ;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Para completar o pagar una reserva, esta debe tener por lo menos un vuelo asignado.'));
        }
    }

    @isTest
    private static void actualizaEstadoFallido(){
        contact contacto = [SELECT Name FROM Contact Limit 1];

        Opportunity reserva = new Opportunity(Name='Reserva de prueba', CloseDate= date.today(), StageName='Pre-venta', Titular_de_reserva__c = contacto.Id);
        insert reserva;

        reserva = [SELECT Name FROM Opportunity LIMIT 1] ;
        reserva.StageName = 'Completado';

        try {
            update reserva;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Para completar o pagar una reserva, esta debe tener por lo menos un vuelo asignado.'));
        }
        
    }
}