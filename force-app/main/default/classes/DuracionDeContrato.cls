public with sharing class DuracionDeContrato {
    
    public static Contract definirDuracion(contract contrato) {
        Integer mes = contrato.startDate.month();
        if((contrato.startDate.month() == 1 && contrato.StartDate.day() < 15) || (contrato.startDate.month() == 12 && contrato.StartDate.day() > 20) ){
            throw new contratoException('La fecha de inicio no esta permitida');
        }

        if(mes < 4){
            contrato.ContractTerm = 6;
        }else if((mes > 3) && (mes<10)){
            contrato.ContractTerm = 3;
        }else {
            contrato.ContractTerm = 1;
            contrato.Valor_Total__c = contrato.Valor_de_contrato__c * 0.85;
        }

        insert contrato;


        return contrato;
    }

    public class contratoException extends Exception {}

   
}