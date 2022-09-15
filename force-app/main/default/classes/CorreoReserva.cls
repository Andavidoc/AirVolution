public with sharing class CorreoReserva {
    
    public static void enviarCorreo(Opportunity reserva){    
        string []correos = new list<string>();
        
        correos.add(reserva.Titular_de_reserva__r.Email);
        
        PageReference pagina = Page.ReservaPDF;
        pagina.getParameters().put('id',reserva.id);
        Blob b;
        if(Test.isRunningTest()) { 
  			b = blob.valueOf('Unit.Test');
		} else {
  			b = pagina.getContentAsPDF();
		}        Messaging.SingleEmailMessage correo = new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment adjunto = new Messaging.EmailFileAttachment();
        adjunto.setFileName('Tiquetes.pdf');
        adjunto.setBody(b);
        
        correo.setSubject( 'Reserva pagada');
        
        correo.setToAddresses(correos);
       
        correo.setPlainTextBody('Hola ' + reserva.Titular_de_reserva__r.Name + '. Su reserva ' + reserva.name + ' ha soido pagada con exito, a continuación encontrarás el archivo con la información adicional.' );
        
        correo.setFileAttachments(new Messaging.EmailFileAttachment[] {adjunto});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {correo});

    }

}