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
    
// Alimenta al animal
public Boolean comer(String comida){
    if(comida == ''){
    return false;
    }
    return true;    
}

//Hace que el animal cresca en 1 año
public  Double crecer(){
    edad += 1;
    return edad;
} 

//Dependiendo del tipo de animal, este hablará de diferente forma
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