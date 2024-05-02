module Irrgarten
  class LabyrinthCharacter
    @@INVALID_POS = -1

    def initialize(name,intelligence,strength,health)
      @name = name
      @intelligence = intelligence
      @strength = strength
      @health = health
      @row = @@INVALID_POS
      @col = @@INVALID_POS
    end

    # Constructor privado porque se pretende que sea abstracta / no instanciable
    private_class_method :new

    attr_reader :name
    attr_reader :row
    attr_reader :col

    def newCopy(other)
      new(other.name,other.intelligence, other.strength, other.health)
      @row = other.row
      @col = other.col
    end

    def dead
      @health<=0
    end

    protected
      def intelligence
        @intelligence
      end

      def strength
        @strength
      end

      def health
        @health
      end

      def health=(health)
        @health = health
      end

      def gotWounded
        @health -= 1
      end
    public
      def pos=(row,col)
        if (row >= 0) && (col >= 0) then
          @row = row
          @col = col
        end
      end

      def to_s
        "[#{@name}, #{@health} HP, #{@intelligence} IP, #{@strength} SP,(#{@row},#{@col})]\n"
      end

      def attack
        raise Exception.new "No implementado, LabyrinthCharacter"
      end

      def defend
        raise Exception.new "No implementado, LabyrinthCharacter"
      end

  end#class
end#module
