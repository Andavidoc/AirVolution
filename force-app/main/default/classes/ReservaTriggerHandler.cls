public without sharing class ReservaTriggerHandler implements TriggerHandler {
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public ReservaTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }
    
    public void beforeInsert(List<Opportunity> newOpportunitys) {
        cambiarNombreDeReserva(newOpportunitys);
        reservaPagada(newOpportunitys);
        actualizarFechaPago(newOpportunitys);
    }

    public void beforeUpdate(List<Opportunity> oldOpportunitys, List<Opportunity> newOpportunitys, Map<ID, SObject> oldOpportunityMap, Map<ID, SObject> newOpportunityMap) {
        reservaPagada(newOpportunitys);
        actualizarFechaPago(newOpportunitys);
    }
    public void beforeDelete(List<Opportunity> oldOpportunitys, Map<ID, SObject> oldOpportunityMap) {
        // helper.doTask5();
        // helper.doTask1();
    }
    public void afterInsert(List<Opportunity> newOpportunitys, Map<ID, SObject> newOpportunityMap) {
        // helper.doTask2();
        // helper.doTask3();
    }
    public void afterUpdate(List<Opportunity> oldOpportunitys, List<Opportunity> newOpportunitys, Map<ID, SObject> oldOpportunityMap, Map<ID, SObject> newOpportunityMap) {
        // helper.doTask4();
        // helper.doTask5();
    }
    public void afterDelete(List<Opportunity> oldOpportunitys, Map<ID, SObject> oldOpportunityMap) {
        // helper.doTask3();
        // helper.doTask1();
    }
    public void afterUndelete(List<Opportunity> newOpportunitys, Map<ID, SObject> newOpportunityMap) {
        // helper.doTask4();
        // helper.doTask2();
    }

    public static void reservaPagada(List<Opportunity> oportunidad){
        for(Opportunity reserva : oportunidad){
            if((reserva.Numero_de_vuelos__c < 1 && reserva.StageName == 'Pagado')||(reserva.Numero_de_vuelos__c < 1 && reserva.StageName == 'Completado')){
                reserva.Numero_de_vuelos__c.addError('Para completar o pagar una reserva, esta debe tener por lo menos un vuelo asignado.');
            }
        }
    }

    public static void cambiarNombreDeReserva(List<Opportunity> opportunities) {
        set <Id> TitularesID = new set<Id>();
        for(Opportunity opp : opportunities){
            TitularesID.add(opp.Titular_de_reserva__c);
        }
        Map<Id, Contact>  Titulares = new Map<Id, Contact>([SELECT Name FROM Contact WHERE Id = : TitularesID]);
        
        for (Opportunity opp : opportunities) {
            if(String.isNotEmpty(opp.Name)){
                String NumeroDeReserva = '-'+EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 6);
                opp.Name = (Titulares.get(opp.Titular_de_reserva__c).name).replace(' ','') + NumeroDeReserva;
            }
        }
    }

    public static void actualizarFechaPago(List<Opportunity> oportunidades){
        List<String> idContactos = new List<String>();
        for (opportunity r : oportunidades) {
            if(r.StageName == 'Pagado'){
                r.Fecha_de_pago__c = Date.today();
                idContactos.add(r.Titular_de_reserva__c);
            }
        }
        // if(idContactos.size() > 0 ){
        // EmailTemplate plantillaCorreo = [SELECT Id FROM EmailTemplate WHERE Name = 'Confirmación de reserva' LIMIT 1];

        // Messaging.MassEmailMessage correo = new Messaging.MassEmailMessage();
        // correo.setTargetObjectIds(idContactos);
        // correo.setSenderDisplayName('Air-Volution Support');
        // correo.setTemplateId(plantillaCorreo.Id);  
        // Messaging.sendEmail(new Messaging.MassEmailMessage[] {correo});
        // }
    }
}