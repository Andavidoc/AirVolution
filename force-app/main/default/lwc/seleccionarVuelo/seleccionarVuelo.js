import { LightningElement, wire } from 'lwc';
import obtenerVuelos from '@salesforce/apex/Cliente.obtenerVuelos';

const actions = [
    { label: 'seleccionar', name: 'seleccionar'}
];

const columns = [
    { label: 'Vuelo', fieldName: 'Name' },
    { label: 'Aeropuerto de Partida', fieldName: 'Aeropuerto_de_Partida__r.name', type: 'number' },
    { label: 'Aeropuerto de Destino', fieldName: 'Aeropuerto_de_Llegada__r.name', type: 'number' },
    { label: 'Fecha de partida', fieldName: 'Fecha_y_hora_de_partida__c', type: 'date' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions}
    }
];

export default class SeleccionarVuelo extends LightningElement {
    columns = columns;

    @wire(obtenerVuelos)
    vuelos;


}