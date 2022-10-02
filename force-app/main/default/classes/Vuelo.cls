public with sharing class Vuelo {

    public static List<VueloAeropuerto> vuelosPartida(){
        Datetime hoy = Datetime.now();
        List<VueloAeropuerto> aeropuertos = new List<VueloAeropuerto>();
        List<Product2> vuelos = [SELECT Id, Name, Aeropuerto_de_partida__r.Id, Aeropuerto_de_partida__r.posici_n__Latitude__s,
                                Aeropuerto_de_partida__r.posici_n__Longitude__s FROM Product2 
                                WHERE Fecha_y_hora_de_partida__c >=: hoy
                                AND Fecha_y_hora_de_partida__c <=: hoy.addHours(24)];
        for (Product2 aeropuerto : vuelos) {
            aeropuertos.add(new VueloAeropuerto((string)aeropuerto.Aeropuerto_de_partida__r.Id, String.valueOf(aeropuerto.Aeropuerto_de_partida__r.posici_n__Latitude__s),
                            String.valueOf(aeropuerto.Aeropuerto_de_partida__r.posici_n__Longitude__s) ));
        }
        return aeropuertos;
    }

    public static List<VueloAeropuerto> vuelosLlegada(){
        Datetime hoy = Datetime.now();
        List<VueloAeropuerto> aeropuertos = new List<VueloAeropuerto>();

        List<Product2> vuelos = [SELECT Id, Name, Aeropuerto_de_llegada__r.Id, Aeropuerto_de_llegada__r.posici_n__Latitude__s,
                                Aeropuerto_de_llegada__r.posici_n__Longitude__s FROM Product2 
                                WHERE Fecha_y_hora_de_partida__c >=: hoy
                                AND Fecha_y_hora_de_partida__c <=: hoy.addHours(1)];
        for (Product2 aeropuerto : vuelos) {
            aeropuertos.add(new VueloAeropuerto((string)aeropuerto.Aeropuerto_de_llegada__r.Id, String.valueOf(aeropuerto.Aeropuerto_de_llegada__r.posici_n__Latitude__s),
                            String.valueOf(aeropuerto.Aeropuerto_de_llegada__r.posici_n__Longitude__s) ));
        }
        return aeropuertos;
    }


    public class VueloAeropuerto{
        public string aeropuerto;
        public String longitude;
        public string latitude;

        public VueloAeropuerto(string aeropuerto, string latitude, string longitude){
            this.aeropuerto = aeropuerto;
            this.latitude = latitude;
            this.longitude = longitude;
        }

    }


}
