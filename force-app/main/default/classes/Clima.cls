public with sharing class Clima {

        
    public static void climasPArtida(){
        String latitude;
        string longitude;
        string aeropuerto;
        Datetime hoy = Datetime.now();
        List<Product2> vuelos = [SELECT Id, Name, Aeropuerto_de_partida__r.Id, Aeropuerto_de_partida__r.posici_n__Latitude__s,
                                Aeropuerto_de_partida__r.posici_n__Longitude__s FROM Product2 
                                WHERE Fecha_y_hora_de_partida__c >=: hoy
                                AND Fecha_y_hora_de_partida__c <=: hoy.addHours(24)];
        List<clima__c> climas = new List<clima__c>();
        for(Product2 vuelo : vuelos){
            latitude = String.valueOf(vuelo.Aeropuerto_de_partida__r.posici_n__Latitude__s);
            longitude = String.valueOf(vuelo.Aeropuerto_de_partida__r.posici_n__Longitude__s);
            aeropuerto = (String)vuelo.Aeropuerto_de_partida__r.Id;
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api.openweathermap.org/data/2.5/weather?lat='+latitude+'&lon='+longitude+'&appid=45808e14cf05d6316b1c5b3a6eb4a7c0&lang=sp&units=metric');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> temp = (Map<String, Object>) results.get('main');
                System.debug(temp.get('temp'));
            clima__c clima = new clima__c(Temperatura__c = (Decimal)temp.get('temp'), Unidad__c = 'Centigrados',
                                         Aeropuerto__c = aeropuerto, Fecha_y_hora_de_predicci_n__c = hoy );
            climas.add(clima);
            }
        }

        insert climas;
}

public static void climasLlegada(){
    String latitude;
    string longitude;
    string aeropuerto;
    Datetime hoy = Datetime.now();
    List<Product2> vuelos = [SELECT Id, Name, Aeropuerto_de_llegada__r.Id, Aeropuerto_de_llegada__r.posici_n__Latitude__s,
                            Aeropuerto_de_llegada__r.posici_n__Longitude__s FROM Product2 
                            WHERE Fecha_y_hora_de_partida__c >=: hoy
                            AND Fecha_y_hora_de_partida__c <=: hoy.addHours(1)];
    List<clima__c> climas = new List<clima__c>();
    for(Product2 vuelo : vuelos){
        latitude = String.valueOf(vuelo.Aeropuerto_de_llegada__r.posici_n__Latitude__s);
        longitude = String.valueOf(vuelo.Aeropuerto_de_llegada__r.posici_n__Longitude__s);
        aeropuerto = (String)vuelo.Aeropuerto_de_llegada__r.Id;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.openweathermap.org/data/2.5/weather?lat='+latitude+'&lon='+longitude+'&appid=45808e14cf05d6316b1c5b3a6eb4a7c0&lang=sp&units=metric');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        Map<String, Object> temp = (Map<String, Object>) results.get('main');
            System.debug(temp.get('temp'));
        clima__c clima = new clima__c(Temperatura__c = (Decimal)temp.get('temp'), Unidad__c = 'Centigrados',
                                     Aeropuerto__c = aeropuerto, Fecha_y_hora_de_predicci_n__c = hoy );
        climas.add(clima);
        }
    }

    insert climas;
}






}