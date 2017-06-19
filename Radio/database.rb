require 'pg'
require './models.rb'

class ComunicadorDAO
	def initialize
	@con = PG.connect :dbname => 'thaylles', 
	:user => 'postgres', 
    :password => 'postgres',
    :host => 'localhost'
  end

  def obter(id)
    rs = @con.exec_params("SELECT * FROM comunicadores WHERE id = $1", [id])
    comunicadores = Comunicador.new
    rs.each do |registro|
      comunicadores.id = registro['id'].to_i
      comunicadores.nome = registro['nome'].to_s
      comunicadores.foto = registro['foto'].to_s         
    end 
    comunicadores
  end

  def editar(comunicador)
	 	rs = @con.exec_params("UPDATE comunicadores SET nome = $1 WHERE id = $2", [comunicador.nome, comunicador.id])
  end 

  def adicionarFoto(comunicador)
    rs = @con.exec_params("UPDATE comunicadores set foto = $1 WHERE id = $2", [comunicador.foto, comunicador.id])
  end
    
  def adicionar(comunicador)    	   
   	rs = @con.exec_params("INSERT INTO comunicadores (nome) VALUES ($1) RETURNING id", [comunicador.nome])
    rs[0]['id'] 
  end
    
  def listar
   	vetcomunicador = []
   	rs = @con.exec "SELECT * FROM comunicadores"
  	rs.each do |registro|
   		comunicador = Comunicador.new
   		comunicador.id = registro['id'].to_i
   		comunicador.nome = registro['nome'].to_s
      comunicador.foto = registro['foto'].to_s
  		vetcomunicador.push(comunicador)
   	end  
   	vetcomunicador
  end
    
  def excluir(id)    	
  	@con.exec_params("DELETE FROM programas WHERE id_comunicador = $1 ", [id])    
    @con.exec_params("DELETE FROM comunicadores WHERE id = $1", [id])
  end	
end	 

class ProgramaDAO
  def initialize
    @con = PG.connect :dbname => 'thaylles', 
    :user => 'postgres', 
    :password => 'postgres',
    :host => 'localhost'
  end

  def obter(id)
    rs = @con.exec_params("select programas.logo, programas.id, programas.nome, programas.duracao, programas.dias, programas.hora_inicio, programas.hora_fim, comunicadores.nome nome_comunicador from programas inner join comunicadores on comunicadores.id = programas.id_comunicador WHERE programas.id = $1", [id])
    programa = Programa.new
    rs.each do |registro|
          programa.id = registro['id'].to_i
          programa.nome = registro['nome'].to_s
          programa.duracao = registro['duracao'].to_s
          programa.dias = registro['dias'].to_s
          programa.hora_inicio = registro['hora_inicio'].to_s
          programa.hora_fim = registro['hora_fim'].to_s
          programa.nome_comunicador = registro['nome_comunicador'].to_s
          programa.logo = registro['logo'].to_s     
    end 
    programa
  end

  def adicionarFoto(programa)
    rs = @con.exec_params("UPDATE programas set logo = $1 WHERE id = $2 and id_comunicador = $3;", [programa.logo, programa.id, programa.id_comunicador])
  end

  def adicionar(programa)         
    rs = @con.exec_params("INSERT INTO programas (nome, duracao, dias, hora_inicio, hora_fim, id_comunicador) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id", 
      [programa.nome, programa.duracao.to_i, programa.dias, programa.hora_inicio.to_i, programa.hora_fim.to_i, programa.id_comunicador.to_i])
    rs[0]['id'] 
  end
  def excluir(id)
    @con.exec_params("DELETE FROM programas WHERE id = $1 ", [id])   
  end
  def listar
      vetprogramas = []
      rs = @con.exec "select programas.logo, programas.id, programas.nome, programas.duracao, programas.dias, programas.hora_inicio, programas.hora_fim, comunicadores.nome nome_comunicador from programas inner join comunicadores on comunicadores.id = programas.id_comunicador"
      rs.each do |registro|
          programa = Programa.new
          programa.id = registro['id'].to_i
          programa.nome = registro['nome'].to_s
          programa.duracao = registro['duracao'].to_s
          programa.dias = registro['dias'].to_s
          programa.hora_inicio = registro['hora_inicio'].to_s
          programa.hora_fim = registro['hora_fim'].to_s
          programa.nome_comunicador = registro['nome_comunicador'].to_s
          programa.logo = registro['logo'].to_s
          vetprogramas.push(programa)
      end  
      vetprogramas
    end

    def editar(programa)
      rs = @con.exec_params("UPDATE programas SET nome = $1, dias = $2, hora_inicio = $3, hora_fim = $4, duracao = $5 WHERE id = $6", 
        [programa.nome, programa.dias, programa.hora_inicio, programa.hora_fim, programa.duracao, programa.id])
    end
end  