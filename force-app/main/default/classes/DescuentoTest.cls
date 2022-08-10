@isTest
public with sharing class DescuentoTest {
    @TestSetup
    static void makeData(){
        Contact clienteRecurrente = new Contact(LastName = 'Perez',
                                                Tipo_de_Identificaci_n__c = 'Cédula de ciudadanía',
                                                N_mero_de_Identificaci_n__c = '123456');
        insert clienteRecurrente;
    }

    @isTest
    static void dctoClienteRecurrente(){
    contact cliente = [SELECT id, Tipo_de_Identificaci_n__c, N_mero_de_Identificaci_n__c
                       FROM Contact LIMIT 1];
    Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.TC, 100);
    
    System.assert(respuesta.resultado);
    System.assertEquals(80, respuesta.valorConDcto);
    System.assert(respuesta.mensaje.contains(string.valueOf(descuento.metodo.TC)));

    }

    @isTest
    static void dctoClienteRecurrenteEf(){
    contact cliente = [SELECT id, Tipo_de_Identificaci_n__c, N_mero_de_Identificaci_n__c
                       FROM Contact LIMIT 1];
    Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.EFECTIVO, 100);
    
    System.assert(respuesta.resultado);
    System.assertEquals(70, respuesta.valorConDcto);
    System.assert(respuesta.mensaje.contains(string.valueOf(descuento.metodo.EFECTIVO)));
    
    }

    @isTest
    static void dctoClienteNuevoEf(){
    contact cliente = new Contact(LastName = 'Aguilar',Tipo_de_Identificaci_n__c = 'Cédula de ciudadanía',N_mero_de_Identificaci_n__c = '1234567');
    Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.EFECTIVO, 100);
    
    System.assert(respuesta.resultado);
    System.assertEquals(85, respuesta.valorConDcto);
    System.assert(respuesta.mensaje.contains(string.valueOf(descuento.metodo.EFECTIVO)));
    
    }

    @isTest
    static void dctoClienteNuevoTC(){
    contact cliente = new Contact(LastName = 'Aguilar',Tipo_de_Identificaci_n__c = 'Cédula de ciudadanía',N_mero_de_Identificaci_n__c = '1234567');
    Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.TC, 100);
    
    System.assert(respuesta.resultado);
    System.assertEquals(85, respuesta.valorConDcto);
    System.assert(respuesta.mensaje.contains(string.valueOf(descuento.metodo.TC)));
    
    }

    @isTest
    static void errorDML(){
    try {
        contact cliente = new Contact(LastName = 'Aguilar',Tipo_de_Identificaci_n__c = 'Cédula de ciudadaní',N_mero_de_Identificaci_n__c = '123456');
    Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.TC, 100);
     } catch (Exception e) {
    System.assertEquals('Ocurrio un error en la inserrción', e.getMessage());
     }   
    }

    @isTest
    static void erorTipoPago(){
        try {
        contact cliente = [SELECT id, Tipo_de_Identificaci_n__c, N_mero_de_Identificaci_n__c
                            FROM Contact LIMIT 1];
        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, null, 100);
        } catch (Exception e) {
            System.assertEquals('El método de pago no corresponde', e.getMessage());
        }
    }

    @isTest
    static void errorDeValor(){
        try {
        contact cliente = [SELECT id, Tipo_de_Identificaci_n__c, N_mero_de_Identificaci_n__c
                            FROM Contact LIMIT 1];
        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.TC, null);
        } catch (Exception e) {
            System.assertEquals('Ocurrio un error no esperado', e.getMessage());
        }
    }

    @isTest
    static void errorDeQuery(){
        try {
        contact cliente = [SELECT id, Tipo_de_Identificaci_n__c, N_mero_de_Identificaci_n__c
                            FROM Contact LIMIT 1];
        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, Descuento.metodo.TC, null);
        } catch (Exception e) {
            System.assertEquals('Ocurrio un error no esperado', e.getMessage());
        }
    }
        
                                        
}