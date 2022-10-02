public with sharing class VueloBatchShedul implements Schedulable{

    public void execute(SchedulableContext ctx){
        VueloBatch batchClass = new VueloBatch(); 
        ID batchprocessid = Database.executeBatch(batchClass);
        clima.crearClimas('Partida');
    }
    
}