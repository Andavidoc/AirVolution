/* Un componente que le permite crear una reserva y un boleto. */
import { LightningElement, api, wire} from 'lwc';
import clienteReserva from '@salesforce/apex/Cliente.clienteReserva';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import obtenerVuelos from '@salesforce/apex/Cliente.obtenerVuelos';
import listaPrecios from '@salesforce/apex/Cliente.listaPrecios';
import crearTiquete from '@salesforce/apex/Cliente.crearTiquete';

const actions = [
    { label: 'seleccionar', name: 'seleccionar'}
];

/* Definición de las columnas de la tabla. */
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

    // Se declaran las variables para manjerar la lógica de proyecto
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
    agregarP;
    nuevosPasajeros;

    /**
     * Devuelve la matriz con la lista de selección del tipo de identidad
     */
    get identidad() {
        return [
            { label: 'Tarjeta de Identidad', value: 'Tarjeta de Identidad' },
            { label: 'Cédula de extranjería', value: 'Cédula de extranjería' },
            { label: 'Cédula de ciudadanía', value: 'Cédula de ciudadanía' },
        ];
    }

    /**
     * La función devuelve una matriz de objetos, cada objeto tiene una etiqueta y una propiedad de valor.
     */
    get opciones() {
        return [
            { label: 'Turista', value: 'Standard Price Book' },
            { label: 'Negocios', value: 'Tiquetes Negocios' },
        ];
    }

    listaPrecios(event) {
        /* Llamar al método de Apex `listaPrecios` y pasar el valor de `this.lista` como parámetro. */
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

    /**
     * Crea un tiquete con los datos obtenidos anteriromente de reserva y contacto, además del vuelo que se está seleccionando. 
     */
    handleRowAction(event){
        this.datos = event.detail.row;
        this.idVuelo = event.detail.row.idVuelo;
        console.log(this.idVuelo + ' ' + this.idReserva + ' ' + this.idContact);
        crearTiquete({reserva : this.idReserva, vuelo : this.idVuelo, pasajero : this.idContact})
        .then((result) => {
            console.log(result);
            this.cerrarModalCreaReserva();
            this.pasajero = true;
            this.showToastTiquete();
        })
        .catch((error) => {
            console.log(error);
        });
    }

    // Funcion utilizada para crear pasajeros adicionales al titular de la reserva
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
                this.pasajero = false;
                this.nuevosPasajeros = true;
            } else{
                this.idContact = this.contacto.Id;
                console.log(this.idContact);
                this.nuevoTiquete();
                this.showToastTiquete();
                this.documento = "";
            } 
        })
        .catch((error) => {
            this.error = error;
            this.contacto = undefined;
            this.reserva = undefined;
        })
    }

    

    /**
     * Crea un tiquete con las propiedades actuales 
     */
    nuevoTiquete(){
        console.log(this.idContact);
        crearTiquete({reserva : this.idReserva, vuelo : this.idVuelo, pasajero : this.idContact})
        .then((result) => {
            console.log(result);
            this.ensayo = true;
        })
        .catch((error) => {
            console.log(error);
        })   
    }
    

    /** 
     * Lanza un mensaje para indicar que el contacto fue creado con éxito.
     */
    showToast(event){
        const evento = new ShowToastEvent({
            title: 'Contacto creado' ,
            message:  'Se ha creado el contaco',
            variant: 'success',
        });
        this.dispatchEvent(evento);
    }

    /**
     * Lanza un mensaje para indicar que la reserva fue creada con éxito.
     */
    showToastReserva(event){
        const evento = new ShowToastEvent({
            title: 'Reserva Exitosa' ,
            message:  'Se ha creado la reserva con éxito',
            variant: 'success',
        });
        this.dispatchEvent(evento);
    }

    /**
     * Lanza un mensaje para indicar que el tiquete fue creado con éxito.
     */
    showToastTiquete(event){
        const evento = new ShowToastEvent({
            title: 'Tiquete Exitosa' ,
            message:  'Se ha creado el tiquete con éxito para: ' + this.contacto.Name,
            variant: 'success',
        });
        this.dispatchEvent(evento);
    }

    
    /**
     * La función docChange() se llama cuando el usuario cambia el valor del campo de entrada. El valor
     * del campo de entrada se almacena en la variable documento.
     */
    docChange(event){
        this.documento = event.detail.value;
        console.log(this.documento);
    }

    /**
     * La función idChange() se llama cuando el usuario cambia el valor del campo de entrada. El valor
     * del campo de entrada se almacena en la variable tIdent.
     */
    idChange(event) {
        this.tIdent = event.target.value;
        console.log(this.tIdent);
    }
    
    /**
     * Comprueba si el contacto existe, si no existe; crea un nuevo contacto, si existe; comprueba si
     * existe la oportunidad, si no existe; crea una nueva oportunidad, si existe; muestra un error indicando qu ela reserva existe.
     */
    crearReserva(){
        clienteReserva({documento: this.documento, tipoDoc: this.tIdent})
        .then((result) => {
            this.error = undefined;
            this.contacto = result.contacto;
            console.log(this.contacto);
            this.reserva = result.oportunidad;
            if(this.contacto === undefined){
                this.crearCliente = true;
                this.pasajero = false;
                this.nuevosPasajeros = false;
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


    // Se generan los metodos para cerrar y abrir los modales
    createOpportunity(event){
        this.idReserva = event.detail
    }

    // Todos: se crean todos los eventos para cerrar los diferentes modales 
    cerrarCreacion(){
        this.crearCliente = false;
        this.crearReserva();
    }

    CerrarModalCreaTiquete(){
        this.crearCliente = false;
        this.pasajero = true;
        this.agregarPasajeros();
    }

    cerrarModalCrearCliente(){
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

    addpasajeros(){
        this.agregarP = true;
    }

}