@RestResource(urlMapping = '/Cualquiera/*')
global class ClaseCualquiera {
    @HttpPost
    global static Account ClaseCualquiera(String IdCuenta, string nombre){
        Account cuenta = new Account (Id = IdCuenta, Name = nombre);

        update cuenta;

        return cuenta;
    }
}
