@isTest
public with sharing class AnimalTest {
    
    //se crea un animal y ejecutan sus 3 métodos, adicional se prueba en los 3 tipos diferentes
    @isTest
    static void metodosAnimal(){
        Animal perro = new Animal('negro', 4, true, Animal.Especie.PERRO);
        System.assertEquals(false, perro.comer(''));
        System.assertEquals(true, perro.comer('Comida'));
        System.assertEquals(1, perro.crecer());
        System.assertEquals('Wow, Wow, Wow', perro.hablar());

        Animal vaca = new Animal('negro', 4, true, Animal.Especie.VACA);
        Animal gato = new Animal('negro', 4, true, Animal.Especie.GATO);
        
        System.assertEquals('Miaw... Miaww', gato.hablar());
        
        System.assertEquals('Muuuuuuuuu', vaca.hablar());

    }
}
