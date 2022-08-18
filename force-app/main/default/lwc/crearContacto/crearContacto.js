import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CrearContacto extends LightningElement {
    @api tipoId;
    @api numId;

    creacionExitosa(event){
        this.dispatchEvent(new CustomEvent('mensaje'));
        this.dispatchEvent(new CustomEvent('cerrar'));
        this.dispatchEvent(new CustomEvent('tiquete'));
    }

   



}