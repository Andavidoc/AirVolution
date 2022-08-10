public class JuegoPPT {
    public enum jugada {PIEDRA, PAPEL, TIJERA}
    public static resultado jugada(String jugador1, jugada jugadaDe1, String jugador2, jugada jugadaDe2) {
        resultado jugadorUno = new resultado();
        resultado jugadorDos = new resultado();
        resultado ganador = new resultado();
        try {
            if(jugador1 == null || jugador2 == null){ 
                throw new juegoException();
            }
            if(jugadaDe1 == null || jugadaDe2 == null){
                throw new jugadaException();
            }
            jugadorUno.jugador = jugador1;
            jugadorUno.jugada = jugadaDe1;
            jugadorDos.jugador = jugador2;
            jugadorDos.jugada = jugadaDe2;
    
            if(jugadorUno.jugada == jugadorDos.jugada){
            System.debug('Se produjo un empate con '+ jugadorUno.jugada);
            ganador.jugada = jugadorUno.jugada;   
            ganador.jugador = 'Se ha producido un empate';
            }else if(jugadorUno.jugada == jugada.PAPEL && jugadorDos.jugada == jugada.PIEDRA){
            system.debug('El jugador '+ jugadorUno.jugador + ' Ha ganado con '+ jugadorUno.jugada );
            ganador = jugadorUno;
            }else if(jugadorUno.jugada == jugada.PIEDRA && jugadorDos.jugada == jugada.TIJERA){
            system.debug('El jugador '+ jugadorUno.jugador + ' Ha ganado con '+ jugadorUno.jugada );
            ganador = jugadorUno;
            }else if(jugadorUno.jugada == jugada.TIJERA && jugadorDos.jugada == jugada.PAPEL){
            system.debug('El jugador '+ jugadorUno.jugador + ' Ha ganado con '+ jugadorUno.jugada );
            ganador = jugadorUno;
            }else if(jugadorUno.jugada == jugada.PIEDRA && jugadorDos.jugada == jugada.PAPEL){
            system.debug('El jugador '+ jugadorDOS.jugador + ' Ha ganado con '+ jugadorDOS.jugada );
            ganador = jugadorDos;
            }else if(jugadorUno.jugada == jugada.TIJERA && jugadorDos.jugada == jugada.PIEDRA){
            system.debug('El jugador '+ jugadorDOS.jugador + ' Ha ganado con '+ jugadorDOS.jugada );
            ganador = jugadorDos;
            }else if(jugadorUno.jugada == jugada.PAPEL && jugadorDos.jugada == jugada.TIJERA){
            system.debug('El jugador '+ jugadorDOS.jugador + ' Ha ganado con '+ jugadorDOS.jugada );
            ganador = jugadorDos;
            }
        }catch(juegoException j) {
            throw new juegoException('Se deben ingresar los dos jugadores.');
        }catch(jugadaException e){
            throw new juegoException('Los dos jugadores deben realizar una jugada.');
        }

        return ganador;

    }

    public class resultado{
    public String jugador;      
    public JuegoPPT.jugada jugada;   
    }

    public class juegoException extends Exception {}
    
    public class jugadaException extends Exception{}

}

/*
JuegoPPT.resultado juego = JuegoPPT.jugada('', JuegoPPT.jugada.PAPEL, 'David', JuegoPPT.jugada.TIJERA );
JuegoPPT.jugada('bueno', JuegoPPT.jugada.PAPEL, 'David', JuegoPPT.jugada.TIJERA );

*/