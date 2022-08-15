public with sharing class CuentaScheduled implements Schedulable{

    public void execute(SchedulableContext ctx){
        CuentaBatch batchClass = new CuentaBatch(); 
        ID batchprocessid = Database.executeBatch(batchClass);
    } 

}