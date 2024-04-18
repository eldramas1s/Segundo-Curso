#encoding: UTF-8

require_relative 'Dice'
require_relative 'Directions'
require_relative 'Player'
require_relative 'Orientation'

module Irrgarten

    class Labyrinth

        @@INVALID_POS=-1
        @@BLOCK_CHAR='X'
        @@EMPTY_BLOCK='-'
        @@MONSTER_CHAR='M'
        @@COMBAT_CHAR='C'
        @@EXIT_CHAR='E'
        @@ROW=0
        @@COL=1

        def initialize(nRows,nCols,exitRow,exitCol)
            @nRows=nRows
            @nCols=nCols
            @exitRow=exitRow
            @exitCol=exitCol
            @mtab=Array.new(nRows) {(Array.new(nCols))}
            @ltab=Array.new(nRows) {(Array.new(nCols))}
            @ptab=Array.new(nRows) {(Array.new(nCols))}

            for i in 0...nRows do
                for j in 0...nCols do
                    @ltab[i][j] = @@EMPTY_BLOCK
                end
            end

            @ltab[exitRow][exitCol] = @@EXIT_CHAR
        end

        def spreadPlayers(players)
            for i in 0..players.size-1 do
                pos = randomEmptyPos
                putPlayer2D(@@INVALID_POS,@@INVALID_POS,pos[@@ROW],pos[@@COL],players[i])
            end
        end

        def haveAWinner #bool
            @ptab[@exitRow][@exitCol] != nil
        end

        def to_s
            str="[#{@nRows}x#{@nCols}],(#{@exitRow},#{@exitCol}) \n"
            for i in 0...@nRows do
                for j in 0...@nCols do
                    str += "|" + @ltab[i][j].to_s + "|"
                end
                str +="\n"
            end
            return str
        end

        def addMonster(row,col,monster) #void
            if @ltab[row][col] == @@EMPTY_BLOCK then
                @ltab[row][col] = @@MONSTER_CHAR
                @mtab[row][col] = monster
            end

        end

        def putPlayer(direction, player) #monster
            oldRow = player.row
            oldCol = player.col
            newPos = dir2Pos(oldRow,oldCol,direction)
            monster = putPlayer2D(oldRow,oldCol,newPos[@@ROW],newPos[@@COL],player)
            monster
        end

        def addBlock(orientation,startRow,startCol, length)#void
            if orientation == Orientation::VERTICAL then
                incRow = 1
                incCol = 0
            else
                incRow = 0
                incCol = 1
            end
            row = startRow
            col = startCol

            while posOK(row,col) && emptyPos(row,col) && length > 0
                @ltab[row][col] = @@BLOCK_CHAR
                length -= 1
                row += incRow
                col += incCol
            end

        end

        def validMoves(row,col)#Directions[]
            output = Array.new
            if(canStepOn(row+1,col))then
                output.append(Directions::DOWN)
            end

            if(canStepOn(row-1,col))then
                output.append(Directions::UP)
            end

            if(canStepOn(row,col+1))then
                output.append(Directions::RIGHT)
            end

            if(canStepOn(row,col-1))then
                output.append(Directions::LEFT)
            end
            output
        end

	private
        def posOK(row,col)#bool
            (0 <= row && row < @nRows && 0 <= col && col < @nCols)
        end

        def emptyPos(row,col)#bool
            @ltab[row][col] == @@EMPTY_BLOCK
        end

        def monsterPos(row,col)#bool
            @ltab[row][col] == @@MONSTER_CHAR
        end

        def exitPos(row,col)#bool
            @ltab[row][col] == @@EXIT_CHAR
        end

        def combatPos(row,col)#bool
            @ltab[row][col] == @@COMBAT_CHAR
        end

        def canStepOn(row,col)#bool
            posOK(row,col) && (emptyPos(row,col) || monsterPos(row,col) || exitPos(row,col))
        end

        def updateOldPos(row,col)#void
            if posOK(row, col)
                if @ltab[row][col] == @@COMBAT_CHAR then
                    @ltab[row][col] = @@MONSTER_CHAR
                else
                    @ltab[row][col] = @@EMPTY_BLOCK
                end
            end

        end

        def dir2Pos(row,col, direction) #int[]
            case direction
            when Directions::UP
                [row-1, col]
            when Directions::DOWN
                [row+1, col]
            when Directions::LEFT
                [row, col-1]
            when Directions::RIGHT
                [row, col+1]
            end
        end

        def randomEmptyPos #int[]
            begin
                row = Dice.randomPos(@nRows)
                col = Dice.randomPos(@nCols)
            end until emptyPos(row,col)
            [row,col]

        end

        def putPlayer2D(oldRow, oldCol, row, col, player) #monster
            output = nil
            if canStepOn(row,col) then
                if posOK(oldRow,oldCol) then
                    p = @ptab[oldRow][oldCol]
                    if p == player then
                        updateOldPos(oldRow,oldCol)
                        @ptab[oldRow][oldCol] = nil
                    end
                end

                monsterPos = monsterPos(row,col)
                if monsterPos then
                    @ltab[row][col] = @@COMBAT_CHAR
                    output = @mtab[row][col]
                else
                    number = player.number
                    @ltab[row][col] = number
                end
                @ptab[row][col] = player
                player.setPos(row,col)
            end
            output
        end

    end#class
end#module
