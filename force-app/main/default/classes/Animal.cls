public class Animal {
    public enum Especie {VACA, PERRO, GATO}
    public String color;
	Integer numPatas;
	Boolean esDomestico;
    public Double edad;
    Especie tipo;

public Animal(String color, Integer numPatas, Boolean esDomestico, Especie tipo){
this.color = color;
this.NumPatas = numPatas;
this.esDomestico = esDomestico;
this.edad = 0;
this.tipo = tipo;
}
    
public Boolean comer(String comida){
    if(comida == ''){
    return false;
    }
    return true;    
}


public  Double crecer(){
    edad += 1;
    return edad;
} 

public String hablar(){
    switch on tipo{
        when Perro{
            return 'Wow, Wow, Wow';
        }
        when Gato{
            return 'Miaw... Miaww';
        }
        when Vaca{
            return 'Muuuuuuuuu';
        }
        when else{
           return null;
        }
    }
}

}