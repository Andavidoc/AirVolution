@isTest
public with sharing class DuracionDeContratoTest {

    @isTest
    static void contratoTrimestreUno(){
        Contract contrato = new Contract(Valor_de_contrato__c = 10000, Status = 'Draft', startDate = Date.newInstance(2022,2,3),AccountId = '0018a00001nsEHhAAM'); 

        Contract resultado = DuracionDeContrato.definirDuracion(contrato);

        System.assertEquals(6,resultado.ContractTerm);
        System.assert(resultado.Id != null);

    }

    @isTest
    static void contratoTrimestreDosTres(){
        Contract contrato = new Contract(Valor_de_contrato__c = 10000, Status = 'Draft', startDate = Date.newInstance(2022,5,3),AccountId = '0018a00001nsEHhAAM'); 

        Contract resultado = DuracionDeContrato.definirDuracion(contrato);

        System.assertEquals(3,resultado.ContractTerm);
        System.assert(resultado.Id != null);
        
    }

    @isTest
    static void contratoTrimestreCuatro(){
        Contract contrato = new Contract(Valor_de_contrato__c = 10000, Status = 'Draft', startDate = Date.newInstance(2022,11,3),AccountId = '0018a00001nsEHhAAM'); 

        Contract resultado = DuracionDeContrato.definirDuracion(contrato);

        System.assertEquals(1,resultado.ContractTerm);
        System.assert(resultado.Id != null);
        system.assertEquals(8500, resultado.valor_Total__c);
        
    }

    @isTest
    static void contratoError(){
        Contract contrato = new Contract(Valor_de_contrato__c = 10000, Status = 'Draft', startDate = Date.newInstance(2022,1,3),AccountId = '0018a00001nsEHhAAM'); 

        try {
            Contract resultado = DuracionDeContrato.definirDuracion(contrato);
        } catch (Exception e) {
            System.assert(e.getMessage().contains('La fecha de inicio no esta permitida'));
        }
        

        
    }

}