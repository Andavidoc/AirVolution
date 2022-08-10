public with sharing class DescuentoMartes implements Schedulable{
    
    public void execute(SchedulableContext ctx){
        DescuentoMartesBatch descuento = new DescuentoMartesBatch();
        ID batchprocessid = Database.executeBatch(descuento);
    } 
}