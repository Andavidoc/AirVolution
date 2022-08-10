public with sharing class VueloTriggerHandler implements TriggerHandler{
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public VueloTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Product2> newRecords){
        nombrarVuelo(newRecords);
    }
    public void beforeUpdate(List<Product2> oldRecords, List<Product2> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap){
        desactivarVuelo(newRecords);
    }
    public void beforeDelete(List<Product2> oldRecords, Map<ID, SObject> oldRecordMap){

    }
    public void afterInsert(List<Product2> newRecords, Map<ID, SObject> newRecordMap){

    }
    public void afterUpdate(List<Product2> oldRecords, List<Product2> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap){

    }
    public void afterDelete(List<Product2> oldRecords, Map<ID, SObject> oldRecordMap){

    }
    public void afterUndelete(List<Product2> newRecords, Map<ID, SObject> newRecordMap){
        
    }

    public void desactivarVuelo(List<Product2> vuelos){
        for(Product2 vuelo : vuelos){
            if(vuelo.IsActive != false && (vuelo.Estado__c == 'Terminado' || vuelo.Estado__c == 'Cancelado')){
                vuelo.IsActive = false;
                if(vuelo.Estado__c == 'Cancelado' && String.isNotEmpty(vuelo.Motivo_de_cancelaci_n__c)){
                    date fecha = date.today();
                    vuelo.Fecha_de_cancelaci_n__c = fecha;
                }else if(vuelo.Estado__c == 'Cancelado'){
                    vuelo.Motivo_de_cancelaci_n__c.addError('Debe agregar un motivo de cancelación');
                }     
            }
        }
    }

    public void nombrarVuelo(List<Product2> vuelos){
        for(Product2 vuelo : vuelos){
            vuelo.Name = 'AE-'+ Integer.valueOf(Math.random()*10000);
        }
    }
}