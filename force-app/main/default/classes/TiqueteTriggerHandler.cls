public without sharing class TiqueteTriggerHandler implements TriggerHandler {
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public TiqueteTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }
    
    public void beforeInsert(List<OpportunityLineItem> newOpportunityLineItems) {
        asignarEquipajeNegocios(newOpportunityLineItems);
        sobreventa(newOpportunityLineItems);
       
    }
    public void beforeUpdate(List<OpportunityLineItem> oldOpportunityLineItems, List<OpportunityLineItem> newOpportunityLineItems, Map<ID, SObject> oldOpportunityLineItemMap, Map<ID, SObject> newOpportunityLineItemMap) {
        
    }
    public void beforeDelete(List<OpportunityLineItem> oldOpportunityLineItems, Map<ID, SObject> oldOpportunityLineItemMap) {
        // helper.doTask5();
        // helper.doTask1();
    }
    public void afterInsert(List<OpportunityLineItem> newOpportunityLineItems, Map<ID, SObject> newOpportunityLineItemMap) {
        // helper.doTask2();
        // helper.doTask3();
    }
    public void afterUpdate(List<OpportunityLineItem> oldOpportunityLineItems, List<OpportunityLineItem> newOpportunityLineItems, Map<ID, SObject> oldOpportunityLineItemMap, Map<ID, SObject> newOpportunityLineItemMap) {
        // helper.doTask4();
        // helper.doTask5();
    }
    public void afterDelete(List<OpportunityLineItem> oldOpportunityLineItems, Map<ID, SObject> oldOpportunityLineItemMap) {
        // helper.doTask3();
        // helper.doTask1();
    }
    public void afterUndelete(List<OpportunityLineItem> newOpportunityLineItems, Map<ID, SObject> newOpportunityLineItemMap) {
        // helper.doTask4();
        // helper.doTask2();
    }




    public static void sobreventa(List<OpportunityLineItem> tiquetes){

        set <Id> idTiquetes = new set<Id>();
        for (opportunityLineItem Tiquete : tiquetes)
        {
            idTiquetes.add(Tiquete.Product2Id);
        }
        map<id , product2> productos = new map<id , product2>([select ID,avi_n__r.Id,avi_n__r.Numero_de_pasajeros_clase_de_negocio__c,avi_n__r.N_mero_de_pasajeros_clase_turista__c 
                                                                from Product2 where Id IN :idTiquetes]); 
        AggregateResult[] groupedResults = [SELECT Count(Id),Product2Id FROM OpportunityLineItem where Product2Id IN :idTiquetes GROUP BY Product2Id  ];
        List<Product2> vuelos = new List<Product2>();
        for (AggregateResult ar : groupedResults){
            system.debug(ar.get('Product2Id'));
            system.debug(ar.get('expr0'));
            decimal pasajerosTotales = productos.get((string)ar.get('Product2Id')).avi_n__r.Numero_de_pasajeros_clase_de_negocio__c+productos.get((string)ar.get('Product2Id')).avi_n__r.N_mero_de_pasajeros_clase_turista__c;
            if ((pasajerosTotales*1.1)<(integer)ar.get('expr0')) {
                vuelos.add(new product2(id=(string)ar.get('Product2Id')));
            }
            
        }
        for(opportunityLineItem a: tiquetes){
            for(product2 p: vuelos){
                if (a.Product2Id==p.Id){
                    a.adderror('No es posible sobrevender los tiquetes');
                }
            }
        }
    }
   

public static void asignarEquipajeNegocios(List<OpportunityLineItem> tiquetes){
    set <Id> idVuelos = new set<Id>();
    for (OpportunityLineItem tiq : tiquetes) {
        idVuelos.add(tiq.product2id);            
    }
    String idNegocios = [SELECT id FROM Pricebook2 WHERE Name = 'Tiquetes Negocios' LIMIT 1].Id;
    List<PricebookEntry> listEntry = [SELECT Id, Pricebook2Id, Product2Id FROM PricebookEntry WHERE Pricebook2Id =: IdNegocios AND Product2Id IN : idVuelos];
    for (PricebookEntry enLis: listEntry) {
        for (OpportunityLineItem tiq : tiquetes) {
            if (tiq.product2id == enLis.product2id){
                tiq.Equipaje_permitido__c = 'Maleta de cabina;Maleta de bodega';
            }
        }
    }
}

}