#encoding: UTF-8


require_relative 'Dice'
require_relative 'Weapon'
require_relative 'Shield'

module Irrgarten

    class Player
        @@DEFAULT_NAME = "Player #"
        @@INVALID_POS = -1 #TODO: Ver si lo puedes meter junto con el de monstruo en Labyrinth
        
        @@MAX_WEAPONS = 2
        @@MAX_SHIELDS = 3
        @@INITIAL_HEALTH = 10
        @@HITS2LOSE = 3

        def initialize(number,intelligence,strength)
            @name = @@DEFAULT_NAME
            @number = number
            @intelligence = intelligence
            @strength =strength
            @health = @INITIAL_HEALTH
            @row = @INVALID_POS
            @col = @INVALID_POS
            @consecutiveHits = 0 
            @weapons = []
            @shields = []
        end
        #getter row y col
        attr_reader :row
        attr_reader :col
        attr_reader :number
    
        def setPos(row,col)
            if row >= 0 && col >= 0 then
                @row = row
                @col = col
            end
        end


        def receiveWeapon(w)
            for i in 0..@weapons.size do 
                wi = @weapons[i]
                if(wi.discard)
                    @weapons.shift
                end
            end
            size = @weapons.size
            if size<@@MAX_WEAPONS then
                w = newWeapon
                @weapons.push(w)	
            end
        end

        def receiveShield(s)
            for i in 0..@shields.size do
                si = @shields[i]
                if(si.discard)
                    @shields.shift
                end
            end
            size = @shields.size
            if(size<@@MAX_SHIELDS)
                s = newShield
                @shields.push(s)
            end
        end

        def move(direction, validMoves)
            size = validMoves.size
            contained = find(direction,validMoves)
            if (size > 0) && !contained then
                firstElement = validMoves[0]
                return firstElement
            else 	
                return direction
            end 
        end

        def manageHit(receivedAttack)
            defense=defensiveEnergy
            if defense<receivedAttack then
                gotWounded
                incConsecutiveHits
            else
                resetHits
            end
            lose=true
            if (@consecutiveHits == @@HITS2LOSE)||(dead()) then
                resetHits
            else	
                lose=false
            end
            return lose
        end

        def resurrect
            weapons.clear()
            shields.clear()
            health = @INITIAL_HEALTH
            consecutiveHits = 0
        end

        def setPos(row,col)
            @row = row
            @col = col
        end

        def dead
            @health <= 0
        end

        def attack
            @strength + sumWeapons
        end

        def defend(receivedAttack)
            manageHit(receivedAttack)
        end

        def to_s
            str="#{@name}, #{@number}, #{@intelligence}, #{@strength}\n"
            str+= "Weapons: ["
            str += @weapons[0] unless @weapons.size==0

            for w in 1..@weapons.size do
                str += " - " + w.to_s
            end
            str += "]\n"
            str+= "Shields: ["
            str += @shields[0] unless @shields.size==0

            for sh in 1..@shields.size do
                str += " - " + sh.to_s
            end
            str += "]\n"
            str
                
        end
        def receiveReward
            wReward = Dice::Dice.weaponsReward
            sReward = Dice::Dice.shieldsReward
            for i in 0..wReward do
                wnew = newWeapon
                receiveWeapon(wnew)
            end
            for i in 0..sReward do
                snew = newShield
                receiveShield(snew)
            end
            extraHealth = Dice::Dice.healthReward
            @health += extraHealth
        end

        private  

        def newWeapon
            Weapon.new(Dice::Dice.randomStrength, Dice::Dice.usesLeft)
        end

        def newShield
            Shield.new(Dice::Dice.randomShield, Dice::Dice.usesLeft)
        end

        def defensiveEnergy
            @intelligence + sumShields
        end

        def resetHits
            @consecutiveHits = 0
        end

        def gotWounded
            @health -= 1
        end

        def incConsecutiveHits
            @consecutiveHits +=1
        end

        def sumWeapons
            sum=0
            for i in 0..@weapons.size do
                sum += @weapons[i].attack
            end
            sum
        end

        def sumShields
            sum=0
            for i in 0..@shields.size do
                sum += @shields[i].protect
            end
            sum
        end
    def find(element,array)
        found = false
        i = 0
        while !found && (i<array.size) 
            if array[i] == element then 
                found = true
            else 
                i += 1
            end
        end
        found	
    end
end


p = Player.new('45',0,0)

puts p.to_s

p.setPos(0,0)

end
