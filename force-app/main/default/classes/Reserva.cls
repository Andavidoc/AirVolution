public with sharing class Reserva {

    @AuraEnabled(cacheable = true)
    public static Opportunity buscarReserva(string titularReserva){
        try {
            Opportunity reserva = [SELECT Id,Name FROM Opportunity WHERE Titular_de_reserva__c =: titularReserva 
                                    AND StageName NOT IN ('Pagado','no pagado')  LIMIT 1];
            return reserva;

            } catch (Exception e) {
                 return null;
            }
        }
}