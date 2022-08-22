/* Importación de la clase de Apex y el componente web Lightning. */
import { LightningElement, wire } from 'lwc';
import obternerVuelos from '@salesforce/apex/TripulacionRequerida.obternerVuelos';


const actions = [
    { label: 'asignar', name: 'asignar'}
];

/* Definición de las columnas de la tabla. */
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
    
    /* Declarar las variables que se utilizarán en el componente. */
    columns = columns;
    isModalOpen;
    idVuelo;
    vuelocode;
    numAuxPendientes;
    numAuxRequeridos;
    piloto;
    copiloto;
    selected = [];

    /**
     * Devuelve el valor de la variable idVuelo.
     */
    get vueloId(){
        return this.idVuelo;
    }

    /* Un decorador que le permite acceder a datos desde un método de Apex. */
    @wire(obternerVuelos)
    vuelos;
 

    /**
     * Abre una ventana modal con la información de la fila seleccionada
     */
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

    /**
     * La función se llama cuando el usuario hace clic en el botón Cerrar en el modal.
     */
    closeModal(){
        this.isModalOpen = false;
    }

}