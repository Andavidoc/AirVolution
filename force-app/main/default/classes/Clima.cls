public with sharing class Clima {
    
    @future(callout=true)
    public static void crearClimas(string partida){
        List<Vuelo.VueloAeropuerto> aeropuertos;
        if(partida == 'Partida'){    //Enumerate    
            aeropuertos = Vuelo.vuelosPartida();
        }   
        else if( partida == 'Llegada'){
            aeropuertos = Vuelo.vuelosLlegada();
        }
    
        List<clima__c> climas = Temperatura.obtenerTemperaturas(aeropuertos);
        
            insert climas;
        
    }
   
}