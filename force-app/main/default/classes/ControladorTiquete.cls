public class ControladorTiquete {
    public List<OpportunityLineItem> tiquetes {get; set;}
    public List<OpportunityLineItem> vuelo {get; set;}
    
    public ControladorTiquete(ApexPages.StandardController cont){
        if(cont.getRecord().Id != null){
            string idReserva = cont.getRecord().Id;
            tiquetes = [SELECT id, Name,Equipaje_permitido__c, Pasajero__r.Name, 
                        UnitPrice, Asiento__c FROM OpportunityLineItem WHERE OpportunityId =: idReserva];

            vuelo = [SELECT Product2.Name, Product2.Fecha_y_hora_de_partida__c,
                        Product2.Fecha_y_hora_estimada_de_llegada__c,
                        Product2.Aeropuerto_de_partida__r.Name, Product2.Aeropuerto_de_llegada__r.Name,
                        UnitPrice, Asiento__c FROM OpportunityLineItem WHERE OpportunityId =: idReserva LIMIT 1];
        }
    }

}