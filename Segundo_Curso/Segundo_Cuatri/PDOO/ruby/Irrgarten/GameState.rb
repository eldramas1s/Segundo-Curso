#encoding: UTF-8
module GameState
    class GameState
		def initialize(laby,avatars,beasts,p_player,victorious,account)
			@labyrinthv = laby
			@players = avatars
			@monsters = beasts
			@current_player = p_player
			@winner = victorious
			@log = account
		end
		
		def labyrinthv
			@labyrinthv
		end
		
		def players
			@players
		end

		def monsters
			@monsters
		end
		
		def current_player
			@current_player
		end
		
		def winner
			@winner
		end
		
		def log
			@log
		end
    end

# Main

estadio = GameState.new('Carpena','juan','varios',5,true,'dramas.es')

puts estadio.inspect

puts estadio.labyrinthv

puts estadio.players

puts estadio.monsters

puts estadio.current_player

puts estadio.winner

puts estadio.log

end