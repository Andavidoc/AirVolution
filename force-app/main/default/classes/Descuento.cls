public with sharing class Descuento {
    public enum metodo {TC, EFECTIVO}
    public static respuestaDcto aplicarDescuento(contact cliente, metodo metodoPago, decimal valor){
        respuestaDcto respuesta = new respuestaDcto();
        try{
            contact[] recurrente = [SELECT id 
                                FROM contact 
                                WHERE Tipo_de_Identificaci_n__c =: cliente.Tipo_de_Identificaci_n__c 
                                AND N_mero_de_Identificaci_n__c =: cliente.N_mero_de_Identificaci_n__c
                                LIMIT 1];
        if(recurrente.size()>0){
            switch on metodoPago {
                when TC {
                    respuesta.valorConDcto = valor * 0.8;
                    respuesta.resultado = true;
                    respuesta.mensaje = 'Se aplicó el descuento de cliente recurrente con '+metodoPago+' de 20%';
                    System.debug(respuesta.mensaje);
                }
                when EFECTIVO {
                    respuesta.valorConDcto = valor * 0.7;
                    respuesta.resultado = true;
                    respuesta.mensaje = 'Se aplicó el descuento de cliente recurrente con '+metodoPago+' de 30%';
                    System.debug(respuesta.mensaje);
                }
                when else {
                    throw new descuentoException();
                }
            }
        } else {
            respuesta.valorConDcto = valor * 0.85;
            respuesta.resultado = true;
            respuesta.mensaje = 'Se aplicó el descuento de cliente nuevo con '+metodoPago+' de 15%';
            System.debug(respuesta.mensaje);
            insert cliente;
        }
        }catch(QueryException qe){
            System.debug('Ocurrio un error en la consulta: '+qe.getMessage());
            throw new descuentoException('Ocurrio un error en la consulta',qe);
        }catch(DMLException dmle){
            System.debug('Ocurrio un error en la inserrción: '+dmle.getMessage());
            throw new descuentoException('Ocurrio un error en la inserrción',dmle);
        }catch(descuentoException de){
            System.debug('El método de pago no corresponde');
            throw new descuentoException('El método de pago no corresponde');
        }catch (Exception e){
            System.debug('Ocurrio un error no esperado: '+e.getMessage());
            throw new descuentoException('Ocurrio un error no esperado',e);
        }
        
        return respuesta;
    }
    
    public class respuestaDcto{
        public boolean resultado;
        public string mensaje;
        public decimal valorConDcto;
    }
    
    public class descuentoException extends Exception {}
    }

/*    
Contact frecuenteTc = new contact(Tipo_de_Identificaci_n__c='Cédula de extranjería',N_mero_de_Identificaci_n__c='516515');
Contact frecuenteEfectivo = new contact(Tipo_de_Identificaci_n__c='Cédula de ciudadanía',N_mero_de_Identificaci_n__c='6856414919');
Contact nuevoTc = new contact(LastName='Creacion de prueba',Tipo_de_Identificaci_n__c='Cédula de ciudadanía',N_mero_de_Identificaci_n__c='68564119');

Descuento.aplicarDescuento(frecuenteTc,Descuento.metodo.TC, 10000);
Descuento.aplicarDescuento(frecuenteEfectivo,Descuento.metodo.EFECTIVO, 10000);
Descuento.aplicarDescuento(nuevoTc,Descuento.metodo.TC, 10000);

*/