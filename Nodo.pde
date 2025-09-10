class Nodo {
  String country;
  String ISO3;
  int tPromedio;
  Nodo nodoIzq, nodoDer, padre;
  int altura;
  float x, y; 

  Nodo(int tPromedio, Nodo padre, String country, String ISO3){ 
    this.tPromedio = tPromedio;
    this.padre = padre;
    this.country = country;
    this.ISO3 = ISO3;
    this.altura = 0; 
    this.x = width/2;
    this.y = 150;
  }
}
