public class TripulacionRequerida {
    @AuraEnabled(cacheable = true)
    public static List<vuelo> obternerVuelos(){
        try{
            DateTime limitDate = DateTime.now().addDays(7);
            List<Product2> vuelos = [SELECT id, name, Avi_n__r.Auxiliares_de_vuelo_requeridos__c, Copiloto__c, Piloto__c,
                                 (SELECT id FROM AuxiliaresxVuelos__r)
                                 FROM Product2
                                 WHERE IsActive = true AND Estado__c = 'En venta' AND
                                 Fecha_y_hora_de_partida__c > TODAY AND 
                                 Fecha_y_hora_de_partida__c <: limitDate ];
            List<vuelo> vuelosRsta = new List<vuelo>();
            for(Product2 v : vuelos){
            vuelosRsta.add(new vuelo((string)v.id, v.name, (integer)v.Avi_n__r.Auxiliares_de_vuelo_requeridos__c, v.Copiloto__c, v.Piloto__c, v.AuxiliaresxVuelos__r.size()));
            }
        system.debug(vuelosRsta);
        return vuelosRsta;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<opcion> obtenerAuxiliares(string idVuelo){
        try{
        List<Contact> auxiliaresDisponibles = [SELECT Id, Name FROM Contact WHERE RecordType.Name = 'Auxiliar de vuelo' LIMIT 20];

        List<AuxiliaresxVuelos__c> tripulantes = [SELECT Id, Contacto__c, Contacto__r.name FROM AuxiliaresxVuelos__c WHERE Vuelo__c =: idVuelo];

        list<opcion> opciones = new list<opcion>();
            for(contact c : auxiliaresDisponibles){
                opciones.add(new opcion(c.name,c.id,false));    
            }

            for(AuxiliaresxVuelos__c t : tripulantes){
                opciones.add(new opcion(t.Contacto__r.name,t.Contacto__c,true));
            }
            return opciones;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveAuxiliares(List<string> auxiliares, string idvuelo){
        try {
            //estos son los tripulantes que ya existen
            List<AuxiliaresxVuelos__c> tripulantes = [SELECT id, Contacto__c, Contacto__r.Name 
                                                FROM AuxiliaresxVuelos__c
                                                WHERE Vuelo__c =: idVuelo];
            
            set<string> noEncontrados = new set<string>();
            for(AuxiliaresxVuelos__c t : tripulantes){
                for(integer i = 0; i < auxiliares.size(); i++){
                    // vamos a remover los existentes de la lista que llego para no duplicarlos
                    if(t.Contacto__c == auxiliares[i]){
                        auxiliares.remove(i);
                        if(noEncontrados.contains(t.id)){
                            noEncontrados.remove(t.id);
                        }
                    } else {
                        // si no lo encuentra lo agrega a una lista para luego eliminarlos
                        noEncontrados.add(t.id);
                    }
                }
            }
            
            //creamos los nuevos tripulantes
            List<AuxiliaresxVuelos__c> nuevosTripulantes = new List<AuxiliaresxVuelos__c>();
            for(string a : auxiliares){
                nuevosTripulantes.add(new AuxiliaresxVuelos__c(vuelo__c = idVuelo, Contacto__c = a));
            }
            system.debug('nuevosTripulantes-->'+nuevosTripulantes);
            insert nuevosTripulantes;

            //eliminamos los que ya no van
            system.debug('noEncontrados-->'+noEncontrados);
            List<AuxiliaresxVuelos__c> paraBorrar = new List<AuxiliaresxVuelos__c>();
            for(string idT : noEncontrados){
                paraBorrar.add(new AuxiliaresxVuelos__c(id = idT));
            }
            delete paraBorrar;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    

    public class opcion{
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string value;
        @AuraEnabled
        public boolean selected;
        public opcion(string label, string value, boolean selected){
            this.label = label;
            this.value = value;
            this.selected = selected;
        }
    }

    public class AuraHandledException extends Exception {}
    
    

    public class vuelo{
        @AuraEnabled
        public string idVuelo;
        @AuraEnabled
        public string codVuelo;
        @AuraEnabled
        public Integer numAuxiliares;
        @AuraEnabled
        public Integer numAuxiliaresRestantes;
        @AuraEnabled
        public Boolean piloto;
        @AuraEnabled
        public Boolean copiloto;

        public vuelo(string id, string name, integer auxiliares, string copilotoId, string pilotoId, integer sizetripulantes){
            idVuelo = id;
            codVuelo = name;
            numAuxiliares = auxiliares;
            numAuxiliaresRestantes = auxiliares - sizetripulantes;
            copiloto = !String.isBlank(copilotoId);
            piloto = !String.isBlank(pilotoId);
        }   
    }
}