import { api, LightningElement, wire } from 'lwc';
import {createRecord,  getRecord, getFieldValue} from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import TITULARDERESERVA_FIELD from '@salesforce/schema/Opportunity.Titular_de_reserva__c';
import ESTADO_FIELD from '@salesforce/schema/Opportunity.StageName';
import FECHADEPAGO_FIELD from '@salesforce/schema/Opportunity.CloseDate';
import NOMBREDERESERVA_FIELD from '@salesforce/schema/Opportunity.Name';
import LISTAPRECIO_FIELD from '@salesforce/schema/Opportunity.Pricebook2Id';


export default class CrearReserva extends LightningElement {
    lista;
    @api recordId;
    @wire(getRecord, {recordId: '$recordId', fields: [NAME_FIELD]}) record;
    
    objectApiName = OPPORTUNITY_OBJECT;
    opportunityId;
    estado = 'Pre-venta';
    fecha = new Date().toISOString().slice(0, 10);
    @api listaPrecio;

    get contactName(){
        return this.record.data ? getFieldValue(this.record.data, NAME_FIELD) : '';
    }

    createOpportunity(){
        const fields = {}
        fields[NOMBREDERESERVA_FIELD.fieldApiName] = this.contactName + this.numeroAleatorio;
        fields[TITULARDERESERVA_FIELD.fieldApiName] = this.recordId;
        fields[ESTADO_FIELD.fieldApiName] = this.estado;
        fields[FECHADEPAGO_FIELD.fieldApiName] = this.fecha;
        fields[LISTAPRECIO_FIELD.fieldApiName] = this.listaPrecio;

        const recordInput ={apiName: OPPORTUNITY_OBJECT.objectApiName, fields };
        createRecord(recordInput)
        .then(opportunity => {
            this.opportunityId = opportunity.id;
            const eventoShow = new ShowToastEvent({
                title: 'Éxito',
                message: 'Reserva creada con éxito',
                variant: 'success',
            });
            const idreserva = this.opportunityId;
            this.dispatchEvent(new CustomEvent('mensaje'));
            this.dispatchEvent(new CustomEvent('cerrar'));
            this.dispatchEvent(new CustomEvent('idreserva', {detail: idreserva}));
            console.log(fields);
            console.log('Reserva creada con éxito');
        })
        .catch(error => {
            console.error(error);
        })
    }
}