@RestResource(urlMapping='/Opportunity/*')
global with sharing class WebServiceReserva {
    
    @HttpPost
    global static ReservaHttp crearReserva(string nombre, string apellidos, string tipoId, string numeroDoc, String email, String idListaPrecios, string idVuelo){
        ReservaHttp respuesta;
        OpportunityLineItem tiquete;
        Contact pasajero = null;
        Opportunity reserva = null;
        Cliente.CtoReserva clienteReserva = Cliente.clienteReserva(numeroDoc, tipoId);

        if(clienteReserva.contacto == null){
            pasajero = new Contact(FirstName = nombre, LastName = apellidos, Tipo_de_Identificaci_n__c = tipoId, N_mero_de_Identificaci_n__c = numeroDoc, Email = email);
            insert pasajero;
        } else if(clienteReserva.oportunidad == null){
            pasajero = clienteReserva.contacto;
        }else {
            respuesta = new ReservaHttp(clienteReserva.oportunidad, 'El pasajero ya cuenta con la siguiente reserva');
            return respuesta;
        }

        reserva = new Opportunity(Name = 'n', Titular_de_reserva__c = pasajero.Id, StageName = 'Pre-venta', CloseDate = Date.today(), Pricebook2Id = idListaPrecios);
        insert reserva;

        tiquete = Cliente.crearTiquete(reserva.Id, idVuelo, pasajero.Id);
        respuesta = new ReservaHttp(reserva, 'Reserva creada exitosamente', tiquete);
        return respuesta;
    }

    @HttpPatch
    global static string pagarReserva(String reserva, Decimal cupo, string tarjeta) {

        Opportunity oportunidad = [SELECT Id, Valor_total__c,Titular_de_reserva__r.Email, Titular_de_reserva__r.Name, name FROM Opportunity WHERE Id =: reserva LIMIT 1];

        if(oportunidad.Valor_total__c < cupo){
            oportunidad.StageName = 'pagado';
            update oportunidad;
            CorreoReserva.enviarCorreo(oportunidad);
        }else {
            return 'El cupo de su tarjeta es insuficiente.';
        }

        return 'El pago se ha realizado de forma correcta con la tarjeta ' + tarjeta;
        
    }

    global class ReservaHttp{
        global Opportunity oportunidad;
        global string mensaje;
        OpportunityLineItem tiquete;

        global ReservaHttp(Opportunity reserva, string mensaje){
            this.oportunidad = reserva;
            this.mensaje = mensaje;
        }

        global ReservaHttp(Opportunity reserva, string mensaje, OpportunityLineItem tiquete){
            this.tiquete = tiquete;
            this.oportunidad = reserva;
            this.mensaje = mensaje;
        }

    }
}
