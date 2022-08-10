@isTest
public with sharing class JuegoPPTTest {

    @isTest
    static void empatePiedra(){
        JuegoPPT.resultado ganador = JuegoPPT.jugada('Juan', JuegoPPT.jugada.PIEDRA, 'David', JuegoPPT.jugada.PIEDRA);
        system.assertEquals(JuegoPPT.jugada.PIEDRA, ganador.jugada);
        system.assertEquals('Se ha producido un empate', ganador.jugador);
    }
    
    @isTest
    static void empatePapel(){
        JuegoPPT.resultado ganador = JuegoPPT.jugada('Juan', JuegoPPT.jugada.PAPEL, 'David', JuegoPPT.jugada.PAPEL);
        system.assertEquals(JuegoPPT.jugada.PAPEL, ganador.jugada);
        system.assertEquals('Se ha producido un empate', ganador.jugador);
    }

    @isTest
    static void empateTijera(){
        JuegoPPT.resultado ganador = JuegoPPT.jugada('Juan', JuegoPPT.jugada.TIJERA, 'David', JuegoPPT.jugada.TIJERA);
        system.assertEquals(JuegoPPT.jugada.TIJERA, ganador.jugada);
        system.assertEquals('Se ha producido un empate', ganador.jugador);
    }

    @isTest
    static void unoGanaPiedra(){
        JuegoPPT.resultado ganador = JuegoPPT.jugada('Juan', JuegoPPT.jugada.PIEDRA, 'David', JuegoPPT.jugada.TIJERA);
        system.assertEquals(JuegoPPT.jugada.PIEDRA, ganador.jugada);
        system.assertEquals('Juan', ganador.jugador);
    }

    @isTest
    static void unoGanaPAPEL(){
        JuegoPPT.resultado ganador = JuegoPPT.jugada('Juan', JuegoPPT.jugada.PAPEL, 'David', JuegoPPT.jugada.PIEDRA);
        system.assertEquals(JuegoPPT.jugada.PAPEL, ganador.jugada);
        system.assertEquals('Juan', ganador.jugador);
    }

    @isTest
    static void unoGanaTijera(){
        JuegoPPT.resultado ganador = JuegoPPT.jugada('Juan', JuegoPPT.jugada.TIJERA, 'David', JuegoPPT.jugada.PAPEL);
        system.assertEquals(JuegoPPT.jugada.TIJERA, ganador.jugada);
        system.assertEquals('Juan', ganador.jugador);
    }

    @isTest
    static void dosGanaPiedra(){
        JuegoPPT.resultado ganador = JuegoPPT.jugada('Juan', JuegoPPT.jugada.TIJERA, 'David', JuegoPPT.jugada.PIEDRA);
        system.assertEquals(JuegoPPT.jugada.PIEDRA, ganador.jugada);
        system.assertEquals('David', ganador.jugador);
    }

    @isTest
    static void dosGanaPAPEL(){
        JuegoPPT.resultado ganador = JuegoPPT.jugada('Juan', JuegoPPT.jugada.PIEDRA, 'David', JuegoPPT.jugada.PAPEL);
        system.assertEquals(JuegoPPT.jugada.PAPEL, ganador.jugada);
        system.assertEquals('David', ganador.jugador);
    }

    @isTest
    static void dosGanaTijera(){
        JuegoPPT.resultado ganador = JuegoPPT.jugada('Juan', JuegoPPT.jugada.PAPEL, 'David', JuegoPPT.jugada.TIJERA);
        system.assertEquals(JuegoPPT.jugada.TIJERA, ganador.jugada);
        system.assertEquals('David', ganador.jugador);
    }

    @isTest
    static void nombreVacio(){
        try {
            JuegoPPT.resultado vacio = JuegoPPT.jugada(null, JuegoPPT.jugada.PAPEL, 'David', JuegoPPT.jugada.TIJERA);
        } catch (Exception e) {
            system.assertEquals('Se deben ingresar los dos jugadores.', e.getMessage());
        }
    }

    @isTest
    static void jugadaVacia(){
        try {
            JuegoPPT.resultado vacio = JuegoPPT.jugada('Juan',null, 'David', JuegoPPT.jugada.TIJERA);
        } catch (Exception e) {
            system.assertEquals('Los dos jugadores deben realizar una jugada.', e.getMessage());
        }
    }




}