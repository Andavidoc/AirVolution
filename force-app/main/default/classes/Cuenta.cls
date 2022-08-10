public with sharing class Cuenta {
    
    public static void usaFuturo(string nombre) {
        Account cuenta = new Account(Name = nombre);
        insert cuenta;
        string id = cuenta.Id;
        
        CuentaFutura.agregarNumero(id);
    }
}