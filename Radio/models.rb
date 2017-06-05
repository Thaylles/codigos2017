# camada de modelo

class Comunicador
	attr_accessor :id, :nome, :foto
end

class Programa
	attr_accessor :id, :nome, :duracao, :dias, :hora_inicio, :hora_fim, :id_comunicador, :nome_comunicador, :logo
end