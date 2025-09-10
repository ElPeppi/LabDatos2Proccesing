import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

AVL arbol; 
String input = "";
int altura = 0;
ArrayList<ArrayList<String>> datos = new ArrayList<ArrayList<String>>();
void setup(){
  size(1280,720);
  String ruta = sketchPath("climate_change_indicators.csv");

  try {
    BufferedReader br = new BufferedReader(new FileReader(ruta));
    String linea;
    
    while ((linea = br.readLine()) != null) {
      String[] valores = linea.split(",");
      ArrayList<String> fila = new ArrayList<String>();
      for (String valor : valores) {
        fila.add(valor);
      }
      int acumulador = 0;
      for(int i = 3; i < fila.size(); i++){
        acumulador += parseFloat(fila.get(i));
      }
      float tPromedio = acumulador / (fila.size() - 3);
      fila.add(str(tPromedio));
      datos.add(fila);
    }

    br.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}

void draw(){
  background(255);
  fill(0);
  textSize(32);
  text("Arboles AVL", 20, 40);

        fill(255);
      rect(130, 70, 200, 40);
      fill(0);
      text(input, 140, 100);
  if (arbol != null){
    drawArbol(arbol.raiz, width/2, 150, width/4);
    fill(0);
    textAlign(LEFT, BASELINE);
    text("Altura del arbol: " + arbol.raiz.altura, 20, height - 60);
    text("Factor de equilibrio raiz: " + arbol.factorEquilibrio(arbol.raiz), 20, height - 30);
  }
}

void drawArbol(Nodo nodo, int x, int y, int separacion){
  if (nodo != null){
    fill(0);
    ellipse(nodo.x, nodo.y, 40, 40);
    nodo.x = lerp(nodo.x, x, 0.1);
    nodo.y = lerp(nodo.y, y, 0.1);
    fill(255);
    textAlign(CENTER, CENTER);
    text(nodo.ISO3, x, y);
    textAlign(LEFT, BASELINE);
    if (nodo.nodoIzq != null){
      line(x - 10, y + 10, x - separacion + 10, y + 60 - 10);
      drawArbol(nodo.nodoIzq, x - separacion, y + 60, separacion / 2);
    }
    if (nodo.nodoDer != null){
      line(x + 10, y + 10, x + separacion - 10, y + 60 - 10);
      drawArbol(nodo.nodoDer, x + separacion, y + 60, separacion / 2);
    }
  }
}

void keyPressed(){
  //si se presionan numeros, se agregen al rectangulo
  if ((key >= '0' && key <= '9') || key == '-'){
    input += key;

  }
  if (key == BACKSPACE){
    if (input.length() > 0){
      input = input.substring(0, input.length() - 1);
    }
  }
  if (key == 'a' || key == 'A'){
    if (input.length() > 0){
      int valor = Integer.parseInt(input);
      Nodo nuevoNodo = new Nodo(valor, null, "Country", "ISO3");
      if (arbol == null){
        arbol = new AVL(nuevoNodo);
      } else {
        //metodo para insertar en el arbol
        arbol.insertarYBalancear(valor, "Country", "ISO3");
      }
      println("altura: " + arbol.raiz.altura);
      input = "";
      fill(255);
    }
  }
  if (key == 'e' || key == 'E'){
    arbol.eliminar(Integer.parseInt(input));
  }
  if (key == 'p' || key == 'P'){
    arbol.preorden();
    println();
    arbol.inorden();
    println();
    arbol.posorden();
  }
}
