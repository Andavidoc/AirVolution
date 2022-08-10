public with sharing class ReversaDescMartes implements Schedulable{
    public void execute(SchedulableContext ctx){
        ReverDescMartesBatch descuento = new ReverDescMartesBatch();
        ID batchprocessid = Database.executeBatch(descuento);
    } 
}