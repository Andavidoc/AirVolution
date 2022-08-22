import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CrearContacto extends LightningElement {
    @api tipoId;
    @api numId;

    /**
     * Despacha un evento al componente principal.
     */
    creacionExitosa(event){
        this.dispatchEvent(new CustomEvent('mensaje'));
        this.dispatchEvent(new CustomEvent('cerrar'));
        this.dispatchEvent(new CustomEvent('tiquete'));
    }

   



}