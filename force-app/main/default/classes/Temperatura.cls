public with sharing class Temperatura {
    
    public static List<clima__c> obtenerTemperaturas(List<Vuelo.VueloAeropuerto> aeropuertos){
        Datetime hoy = Datetime.now();
        String latitude;
        string longitude;
        string aeropuerto;
        List<clima__c> climas = new List<clima__c>();
        for(Vuelo.VueloAeropuerto aero : aeropuertos){
            latitude = aero.latitude;
            longitude = aero.longitude;
            aeropuerto = aero.aeropuerto;
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
        return climas;

    }

}
