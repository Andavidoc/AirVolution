import { LightningElement, wire } from 'lwc';
import obternerVuelos from '@salesforce/apex/TripulacionRequerida.obternerVuelos';


const actions = [
    { label: 'asignar', name: 'asignar'}
];

const columns = [
    { label: 'Código', fieldName: 'codVuelo' },
    { label: 'Auxiliares Requeridos', fieldName: 'numAuxiliares', type: 'number' },
    { label: 'Auxiliares Faltantes', fieldName: 'numAuxiliaresRestantes', type: 'number' },
    { label: 'Tiene Piloto', fieldName: 'piloto', type: 'boolean' },
    { label: 'Tiene Copiloto', fieldName: 'copiloto', type: 'boolean' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions}
    }
];
export default class AsignarTripulacion extends LightningElement {
    
    columns = columns;
    isModalOpen;
    idVuelo;
    vuelocode;
    numAuxPendientes;
    numAuxRequeridos;
    piloto;
    copiloto;
    selected = [];

    get vueloId(){
        return this.idVuelo;
    }

    @wire(obternerVuelos)
    vuelos;
 

    handleRowAction(event){
        this.isModalOpen = true;
        console.log(event.detail.row);
        this.datos = event.detail.row;
        this.vuelocode = this.datos.codVuelo;
        this.piloto = this.datos.piloto;
        this.copiloto = this.datos.copiloto;
        this.numAuxPendientes = this.datos.numAuxiliaresRestantes;
        this.numAuxRequeridos = this.datos.numAuxiliares;
        this.idVuelo = this.datos.idVuelo;
    }

    closeModal(){
        this.isModalOpen = false;
    }

}