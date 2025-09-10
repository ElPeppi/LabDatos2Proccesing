public class AVL {
  Nodo raiz;

  public AVL (Nodo raiz) {
    this.raiz = raiz;
  }

  public void preorden() {
    preorden(raiz);
    System.out.println();
  }

  private void preorden(Nodo nodo) {
    if (nodo != null) {
      System.out.print(nodo.tPromedio + ", ");
      preorden(nodo.nodoIzq);
      preorden(nodo.nodoDer);
    }
  }

  public void inorden() {
    inorden(raiz);
    System.out.println();
  }

  private void inorden(Nodo nodo) {
    if (nodo != null) {
      inorden(nodo.nodoIzq);
      System.out.print(nodo.tPromedio + ", ");
      inorden(nodo.nodoDer);
    }
  }

  public void posorden() {
    posorden(raiz);
    System.out.println();
  }

  private void posorden(Nodo nodo) {
    if (nodo != null) {
      posorden(nodo.nodoIzq);
      posorden(nodo.nodoDer);
      System.out.print(nodo.tPromedio + ", ");
    }
  }


  private int altura(Nodo n) {
    return (n == null) ? -1 : n.altura;
  }

  public void actualizarAltura(Nodo n) {
    if (n != null) n.altura = 1 + Math.max(altura(n.nodoIzq), altura(n.nodoDer));
  }

  private int factorEquilibrio(Nodo n) {
    return (n == null) ? 0 : altura(n.nodoIzq) - altura(n.nodoDer);
  }

  private Nodo rotacionDerecha(Nodo y) {
    Nodo x = y.nodoIzq;
    Nodo T2 = x.nodoDer;

    // rotación
    x.nodoDer = y;
    y.nodoIzq = T2;

    // padres
    x.padre = y.padre;
    y.padre = x;
    if (T2 != null) T2.padre = y;

    // alturas
    actualizarAltura(y);
    actualizarAltura(x);

    return x; // nueva raíz del subárbol
  }

  private Nodo rotacionIzquierda(Nodo x) {
    Nodo y = x.nodoDer;
    Nodo T2 = y.nodoIzq;

    // rotación
    y.nodoIzq = x;
    x.nodoDer = T2;

    // padres
    y.padre = x.padre;
    x.padre = y;
    if (T2 != null) T2.padre = x;

    // alturas
    actualizarAltura(x);
    actualizarAltura(y);

    return y; // nueva raíz del subárbol
  }


  private Nodo balancear(Nodo n) {
    if (n == null) return null;

    actualizarAltura(n);
    int factor = factorEquilibrio(n);

    if (factor > 1) {                      // pesado a la izquierda
      if (factorEquilibrio(n.nodoIzq) < 0) // caso LR
        n.nodoIzq = rotacionIzquierda(n.nodoIzq);
      return rotacionDerecha(n);           // LL o LR resuelto
    }
    if (factor < -1) {                     // pesado a la derecha
      if (factorEquilibrio(n.nodoDer) > 0) // caso RL
        n.nodoDer = rotacionDerecha(n.nodoDer);
      return rotacionIzquierda(n);         // RR o RL resuelto
    }
    return n; // ya balanceado
  }


  public void insertarYBalancear(float tPromedio, String country, String ISO3) {
    raiz = insertar(raiz, tPromedio, null, country, ISO3);
    if (raiz != null) raiz.padre = null; // asegurar raíz limpia
  }

  private Nodo insertar(Nodo n, float tPromedio, Nodo padre, String country, String ISO3) {
    if (n == null) return new Nodo(tPromedio, padre, country, ISO3);

    if (tPromedio < n.tPromedio) {
      n.nodoIzq = insertar(n.nodoIzq, tPromedio, n, country, ISO3);
    } else if (tPromedio > n.tPromedio) {
      n.nodoDer = insertar(n.nodoDer, tPromedio, n, country, ISO3);
    } else {
      return n; // duplicado: no inserta
    }

    n = balancear(n);

    // si tras balancear cambió la raíz del subárbol, fijar su padre
    if (n.padre != padre) n.padre = padre;

    return n;
  }

  public void eliminar(int tPromedio) {
    raiz = eliminar(raiz, tPromedio);
    if (raiz != null) raiz.padre = null; // asegurar raíz limpia
  }

  private Nodo eliminar(Nodo n, double tPromedio) {
    if (n == null) return n;

    if (tPromedio < n.tPromedio) {
      n.nodoIzq = eliminar(n.nodoIzq, tPromedio);
    } else if (tPromedio > n.tPromedio) {
      n.nodoDer = eliminar(n.nodoDer, tPromedio);
    } else {
      // nodo con un solo hijo o sin hijos
      if ((n.nodoIzq == null) || (n.nodoDer == null)) {
        Nodo temp = (n.nodoIzq != null) ? n.nodoIzq : n.nodoDer;

        // sin hijos
        if (temp == null) {
          n = null;
        } else { // un hijo
          temp.padre = n.padre;
          n = temp;
        }
      } else {
        // nodo con dos hijos: obtener el sucesor inorder
        Nodo temp = minValorNodo(n.nodoDer);

        // copiar el valor del sucesor al nodo a eliminar
        n.tPromedio = temp.tPromedio;
        n.country = temp.country;
        n.ISO3 = temp.ISO3;

        // eliminar el sucesor
        n.nodoDer = eliminar(n.nodoDer, temp.tPromedio);
      }
    }

    if (n == null) return n;

    n = balancear(n);

    // si tras balancear cambió la raíz del subárbol, fijar su padre
    if (n.padre != null && (n.padre.nodoIzq != n && n.padre.nodoDer != n)) {
      n.padre = null; // desconectar si ya no es hijo de su padre original
    }

    return n;
  }
  private Nodo minValorNodo(Nodo n) {
    Nodo actual = n;
    while (actual.nodoIzq != null) {
      actual = actual.nodoIzq;
    }
    return actual;
  }
  
}
