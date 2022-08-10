public with sharing class CuentaFutura {
    
    @future
    public static void agregarNumero(string id){
        Account cuenta = new Account(Id = id);

        string numero = String.valueOf((Math.random()*10000000).round());
    
        cuenta.SLASerialNumber__c = numero;

        update cuenta;
    }

}