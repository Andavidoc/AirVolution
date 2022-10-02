@RestResource(urlMapping='/Product2/*')
global class WebServiceVuelo {
    
    @HttpGet
    global static Respuesta obtenerVuelos() {
        Respuesta respuesta ;
        String fechaMenor = '';
        String fechaMayor = '';
        String ciudadPartida = '';
        String ciudadDestino = '';
        Datetime primerFecha;
        Datetime segundaFecha;
        Date fecha1;
        Date fecha2;
        string clase;

        RestRequest restReq = RestContext.request;
        RestResponse restRes = RestContext.response;
    
        // Reading parametrs from URL
        fechaMenor = restReq.params.get('fechaMenor').replace('-', '/');
        //fechaMayor = restReq.params.get('fechaMayor').replace('-', '/');
        ciudadPartida = restReq.params.get('ciudadPartida');
        ciudadDestino = restReq.params.get('ciudadDestino');
        clase = restReq.params.get('clase');

        clase = Cliente.listaPrecios(clase);

        try {
        fecha1 = Date.parse(fechaMenor);
        primerFecha = (Datetime)fecha1;
        } catch (Exception e) {
            respuesta = new Respuesta( 'El formato de fecha inicial correcto  es: dd-mm-yyyy.', false );
            return respuesta;
        }
        
        Schema.DescribeFieldResult ciudades = Aeropuerto__c.Ciudad__c.getDescribe();
        List<Schema.PicklistEntry> ciudadesDisponibles =  ciudades.getPicklistValues();
        List<String> listaCiudades = new List<String>();
        for (Schema.PicklistEntry ciudad : ciudadesDisponibles) {
            listaCiudades.add(ciudad.getLabel());
        }
        if(!listaCiudades.contains(ciudadPartida)){
            respuesta = new Respuesta( 'La ciudad de partida no está en el catalogo de la compañia', false);
            return respuesta;
        }else if(!listaCiudades.contains(ciudadDestino)){
            respuesta = new Respuesta( 'La ciudad de destino no está en el catalogo de la compañia', false);
            return respuesta;
        }

        respuesta = new Respuesta('La solicitud ha sido exitosa', true);

        List<Product2> vuelos = [SELECT Id, Name, Aeropuerto_de_Partida__r.Name,
                                Aeropuerto_de_Llegada__r.Name, Fecha_y_hora_de_partida__c, 
                                Fecha_y_hora_estimada_de_llegada__c, (SELECT unitPrice FROM PricebookEntries WHERE Pricebook2Id =: clase)
                                FROM Product2 
                                WHERE Fecha_y_hora_de_partida__c >=: fecha1.addDays(-1) AND Fecha_y_hora_de_partida__c <=: fecha1.addDays(1)
                                AND Aeropuerto_de_Partida__r.ciudad__c =: ciudadPartida AND Aeropuerto_de_Llegada__r.ciudad__c =: ciudadDestino];

        List<Cliente.vueloWrapper> listaVuelos = new List<Cliente.vueloWrapper>();
        for(Product2 a : vuelos){
            if(a.PricebookEntries.size() > 0){
            listaVuelos.add(new Cliente.vueloWrapper((String)a.Id, a.Name, a.Aeropuerto_de_Partida__r.Name, a.Aeropuerto_de_Llegada__r.Name,
                                             a.Fecha_y_hora_de_partida__c, a.Fecha_y_hora_estimada_de_llegada__c, a.PricebookEntries[0].UnitPrice));
            }
        }

        respuesta.vuelos = listaVuelos;
        respuesta.idListaprecios = clase;
        return respuesta;
    }


    global class Respuesta{
        global List<Cliente.vueloWrapper> vuelos;
        global string mensaje;
        global Boolean exitoso;
        global String idListaprecios;
       
        global Respuesta ( string mensaje, Boolean exito){
            this.mensaje = mensaje;
            this.exitoso = exito;
       }
    }
}