module Irrgarten
  class LabyrinthCharacter
    @@INVALID_POS = -1

    def initialize(name,intelligence,strength,health)
      #TODO: Preguntar porque es un poco raro
      setStats(name,intelligence,strength,health)
      @row = @@INVALID_POS
      @col = @@INVALID_POS
    end

    #Creado porque si se sobrecarga initialize no se puede usar de forma segura
    #De esta forma podemos en el cloner delegar aqui
    def setStats(name, intelligence,strength,health)
      @name = name
      @intelligence = intelligence.to_f
      @strength = strength.to_f
      @health = health
    end
    private_methods :setStats

    # Constructor privado porque se pretende que sea abstracta / no instanciable
    private_class_method :new

    attr_reader :name
    attr_reader :row
    attr_reader :col

    # Constructor de copia de un Player
    # other -> Personaje del que copiar
    def cloner(other)
      setStats(other.name,other.intelligence, other.strength,other.health)
      @row = other.row
      @col = other.col
    end

    # Comprueba si un jugador esta muerto
    # return -> True -> muerto
    #           False -> vivo
    def dead
      @health<=0
    end

    protected
      # getter intelligence
      def intelligence
        @intelligence
      end

      # getter strength
      def strength
        @strength
      end

      # getter health
      def health
        @health
      end

      # setter health
      # health -> nuevo valor de vida
      def health=(health)
        @health = health
      end

      # Daña a un LabyrinthCharacter
      def gotWounded
        @health -= 1
      end
    public

      # setter row y col
      # row -> fila nueva
      # col -> columna nueva
      def pos=(row,col)
        if (row >= 0) && (col >= 0) then
          @row = row
          @col = col
        end
      end

      # Concatena la informacion de un LabyrinthCharacter
      # return -> cadena con la informacion
      def to_s
        "[#{@name}, #{@health} HP, #{@intelligence} IP, #{@strength} SP,(#{@row},#{@col})]\n"
      end

      #TODO: Preguntar si hay que declararlo
      # Ataque de un Personaje (abstracto)
      def attack
        raise Exception.new "No implementado, LabyrinthCharacter"
      end

      # Defensa de un personaje (abstracto)
      def defend
        raise Exception.new "No implementado, LabyrinthCharacter"
      end

  end#class
end#module
