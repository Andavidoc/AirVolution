public with sharing class ReservaScheduled implements Schedulable{
    
    public void execute(SchedulableContext ctx){
        ReservaBatch batchClass = new ReservaBatch(); 
        ID batchprocessid = Database.executeBatch(batchClass);
    } 

}
