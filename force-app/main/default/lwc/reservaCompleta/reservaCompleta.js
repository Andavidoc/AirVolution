import { LightningElement, api, wire} from 'lwc';
import clienteReserva from '@salesforce/apex/Cliente.clienteReserva';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import obtenerVuelos from '@salesforce/apex/Cliente.obtenerVuelos';
import listaPrecios from '@salesforce/apex/Cliente.listaPrecios';
import crearTiquete from '@salesforce/apex/Cliente.crearTiquete';

const actions = [
    { label: 'seleccionar', name: 'seleccionar'}
];

const columns = [
    { label: 'Vuelo', fieldName: 'nombreVuelo' },
    { label: 'Aeropuerto de Partida', fieldName: 'aeroPartida', type: 'text' },
    { label: 'Aeropuerto de Destino', fieldName: 'aeroLlegada', type: 'text' },
    { label: 'Fecha de partida', fieldName: 'fechaPartida', type: 'date' },
    { label: 'Fecha de Llegada', fieldName: 'fechaLlegada', type: 'date' },
    { label: 'Precio', fieldName: 'valor'},
    {
        type: 'action',
        typeAttributes: { rowActions: actions}
    }
];


export default class ReservaCompleta extends LightningElement {
    columns = columns;
    @wire(obtenerVuelos,({precio: '$nombreLista'}))
    vuelos;

    lista;
    documento;
    contacto = undefined;
    tIdent;
    crearCliente;
    reservaExistente;
    crearReserevaModal;
    modalVuelos;
    reserva = undefined;
    nombreReserva;
    idContact;
    ensayo = true;
    nombreLista;
    idReserva;
    idVuelo;
    pasajero;


    get identidad() {
        return [
            { label: 'Tarjeta de Identidad', value: 'Tarjeta de Identidad' },
            { label: 'Cédula de extranjería', value: 'Cédula de extranjería' },
            { label: 'Cédula de ciudadanía', value: 'Cédula de ciudadanía' },
        ];
    }

    get opciones() {
        return [
            { label: 'Turista', value: 'Standard Price Book' },
            { label: 'Negocios', value: 'Tiquetes Negocios' },
        ];
    }

    listaPrecios(event) {
        this.lista = event.detail.value;
        console.log(this.lista);
        listaPrecios({entradaDeLista: this.lista})
        .then((result) => {
            this.error = undefined;
            this.nombreLista = result;
            console.log(this.nombreLista);
        })
        .catch((error) => {
            this.error = error;
            this.contacto = undefined;
            this.reserva = undefined;
        })
    }

    handleRowAction(event){
        this.datos = event.detail.row;
        this.idVuelo = event.detail.row.idVuelo;
        console.log(this.idVuelo + ' ' + this.idReserva + ' ' + this.idContact);
        crearTiquete({reserva : this.idReserva, vuelo : this.idVuelo, pasajero : this.idContact})
        .then((result) => {
            console.log(result);
            this.crearReserevaModal = false;
            this.pasajero = true;
        })
        .catch((error) => {
            console.log(error);
        });
        
    }

    agregarPasajeros(event){
        clienteReserva({documento: this.documento, tipoDoc: this.tIdent})
        .then((result) => {
            this.error = undefined;
            this.contacto = result.contacto;
            console.log(this.contacto);
            this.reserva = result.oportunidad;
            if(this.contacto === undefined){
                this.crearReserevaModal = false;
                this.crearCliente = true;
            } else{
                this.idContact = this.contacto.Id;
                console.log(this.idContact);
                this.nuevoTiquete();
            } 
        })
        .catch((error) => {
            this.error = error;
            this.contacto = undefined;
            this.reserva = undefined;
        })
        //
    }

    

    nuevoTiquete(){
        console.log(this.idContact);
        crearTiquete({reserva : this.idReserva, vuelo : this.idVuelo, pasajero : this.idContact})
        .then((result) => {
            console.log(result);
        })
        .catch((error) => {
            console.log(error);
        })   
    }
    

    showToast(event){
        const evento = new ShowToastEvent({
            title: 'Contacto creado' ,
            message:  'Se ha creado el contaco',
            variant: 'success',
        });
        this.dispatchEvent(evento);
    }

    showToastReserva(event){
        const evento = new ShowToastEvent({
            title: 'Reserva Exitosa' ,
            message:  'Se ha creado la reserva con éxito',
            variant: 'success',
        });
        this.dispatchEvent(evento);
    }

    
    docChange(event){
        this.documento = event.detail.value;
        console.log(this.documento);
    }

    idChange(event) {
        this.tIdent = event.target.value;
        console.log(this.tIdent);
    }
    
    crearReserva(){
        clienteReserva({documento: this.documento, tipoDoc: this.tIdent})
        .then((result) => {
            this.error = undefined;
            this.contacto = result.contacto;
            console.log(this.contacto);
            this.reserva = result.oportunidad;
            if(this.contacto === undefined){
                this.crearCliente = true;
            } else if(this.reserva === undefined){
                this.nombreContacto = this.contacto.Name;
                this.idContact = this.contacto.Id;
                this.crearReserevaModal = true;
            } else if(this.reserva != undefined){
                this.nombreReserva = this.reserva.Name;
                this.reservaExistente = true;
            } 
        })
        .catch((error) => {
            this.error = error;
            this.contacto = undefined;
            this.reserva = undefined;
        })
    }



    createOpportunity(event){
        this.idReserva = event.detail
    }

    cerrarCreacion(){
        this.crearCliente = false;
    }

    cerrarReserva(){
        this.reservaExistente = false;
    }

    cerrarModalCreaReserva(){
        this.ensayo = true;
        this.crearReserevaModal = false;
    }

    cerrarModalVuelos(){
        this.modalVuelos = false;
    }

    cerrarPasajero(){
        this.pasajero = false;
    }

    
    abrirVuelos(){
        this.ensayo = false;
        this.modalvuelos = false;
    }

}