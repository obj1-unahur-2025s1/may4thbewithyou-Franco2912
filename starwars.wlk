
class Personaje {
  var valentia
  const armas = #{} // Colección de armas
  var armaActual

  method agregarArma(unaArma) {
    armas.add(unaArma)
    if (armaActual == null) armaActual = unaArma
  }

  method usarArma(unArma){
    if(armas.contains(unArma)){
      armaActual = unArma
    }else{
      throw ("No tienes esa arma")
    }
  } 

  method potencia() = valentia * armaActual.energia()
                    
}

class Arturito inherits Personaje{
  var bateria = 50

  override method potencia() = bateria * 10

  method cargarBateria(){
    bateria = 100
  }
  method desgastarBateria(){
    bateria -= 1.max(0)
  }
}

class Han inherits Personaje {
  var estado = "congelado"

  override method agregarArma(unArma) {
    if (unArma.esArmaFuego() and !unArma.esArmaBlanca()) {
      armas.add(unArma)
      if (armaActual == null) armaActual = unArma
    }
  }

  method descongelar(){
    estado = "descongelado"
  }

  override method potencia() {
    var potencia = 0
    if(estado == "congelado") {
      potencia = 0
    } else {
      potencia = armaActual.energia() * 2
    }
    return potencia
  }
}

object fuerzaOscuraGlobal {
  var property nivel = 1

  method sumarNivel(){
    nivel += 1
  }

  method restarNivel(){
    nivel = nivel / 2
  }
}

class Maestro inherits Personaje {
  var property esperanza = 0
  var property lado //"jedi" o "sith"
  const midiclorianos
  method initialize(){
    if (lado == "jedi"){
      esperanza = 50
    }
    valentia = 0
    armaActual = sableDeLuz
  }

  method vivirSuceso(cargaEmocional) {
    if (lado == "jedi") {
      esperanza += cargaEmocional
      if (esperanza <= 0) {
        lado = "sith"
        fuerzaOscuraGlobal.sumarNivel()
      }
    } else { // lado == "sith"
      if (cargaEmocional > 100) {
        lado = "jedi"
        esperanza = 50
        fuerzaOscuraGlobal.restarNivel()
      }
    }
  }

  override method potencia() {
    var p = 0
    if (lado == "jedi") {
      p = ((midiclorianos / 1000) + armaActual.energia()) * 10
    } else {
      p = ((midiclorianos / 1000) + armaActual.energia()) * fuerzaOscuraGlobal.nivel()
    }
    return p
    }
  }

class Arma {
  var property energia
}

class Blaster inherits Arma {
  method initialize() {
    energia = 70
  }

  method esArmaFuego() = true
  method esArmaBlanca() = false
}

class RifleDePulso inherits Arma {
  method initialize() {
    energia = 90
  }

  method esArmaFuego() = true
  method esArmaBlanca() = false
}

object sableDeLuz {
  const property energia = 50

  method esArmaFuego() = false
  method esArmaBlanca() = true
}

class Planeta {
  var property habitantes
  const defensores = #{}

  method entraADefender(unPersonaje){
    defensores.add(unPersonaje)
  }
  method irseDelPlaneta(unPersonaje){
    defensores.remove(unPersonaje)
  }

  method potenciaDefensiva() = defensores.sum({p => p.potencia()}) 
  method esAtacadaPor(unInvasor){
    if(unInvasor.potenciaOfensiva() > self.potenciaDefensiva()){
      habitantes = habitantes - (habitantes * 0.1)
    }   
  }
}

class Tatooine inherits Planeta {
  method initialize(){
    habitantes = 1000000
  }
}

class FuerzaOscura {
  const tropas = #{}

  method reclutarTropa(unPersonaje){
    tropas.add(unPersonaje)
  }
  method expulsarTropa(unPersonaje){
    tropas.remove(unPersonaje)
  }

  method potenciaOfensiva() = tropas.sum({t => t.potencia()}) 
}

object suceso {
  method aplicarA(maestro) {}
}

object conSeguirAmigo {
  method aplicarA(maestro, amigo) {
    maestro.vivirSuceso(amigo.potencia())
  }
}

object batalla {
  method aplicarA(maestro, bajas) {
    maestro.vivirSuceso(-bajas)
  }
}

object carreraGanada {
  method aplicarA(maestro) {
    maestro.vivirSuceso(5)
  }
}

object sucesoTragico {
  method aplicarA(maestro) {
    maestro.vivirSuceso(-100)
  }
}

object sucesoExtremoOscuro {
  method aplicarA(maestro) {
    maestro.vivirSuceso(200)
  }
}

// Nuevo tipo de suceso: conjunto de otros sucesos
object sucesoCompuesto {
  method aplicarA(maestro, sucesos) {
    sucesos.forEach({suceso => suceso.aplicarA(maestro)})
  }
}