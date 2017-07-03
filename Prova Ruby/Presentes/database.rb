require 'pg'
require './models.rb'

class PresenteDAO
	def initialize
	@con = PG.connect :dbname => 'postgres', 
	:user => 'postgres', 
    :password => 'postgres',
    :host => 'localhost'
  end

  def obter(id)
    rs = @con.exec_params("SELECT * FROM presentes WHERE id = $1", [id])
    presente = Presente.new
    rs.each do |registro|
      presente.id = registro['id'].to_i
      presente.preco = registro['preco'].to_i
      presente.nome = registro['nome'].to_s
      presente.icone = registro['icone'].to_s         
    end 
    presente
  end

  def adicionarIcone(presente)
    rs = @con.exec_params("UPDATE presentes set icone = $1 WHERE id = $2", [presente.icone, presente.id])
  end
    
  def adicionar(presente)    	   
   	rs = @con.exec_params("INSERT INTO presentes (nome, preco) VALUES ($1, $2) RETURNING id", [presente.nome, presente.preco])
    rs[0]['id'] 
  end

  def listarUltimos
    vetpresente = []
    rs = @con.exec "SELECT nome, preco FROM PRESENTES order by id DESC limit 3"
    rs.each do |registro|
      presente_nome = registro['nome'].to_s + "<br>" 
      vetpresente.push(presente_nome)
    end  
    vetpresente
  end

  def maior
    vetpresente = []
    rs = @con.exec "SELECT max(preco) FROM PRESENTES"
    rs.each do |registro|
      presente_preco = registro['max'].to_i
      vetpresente.push(presente_preco)
    end  
    vetpresente
  end

   def menor
    vetpresente = []
    rs = @con.exec "SELECT min(preco) FROM PRESENTES"
    rs.each do |registro|
      presente_preco = registro['min'].to_i 
      vetpresente.push(presente_preco)
    end  
    vetpresente
  end

   def media
    vetpresente = []
    rs = @con.exec "SELECT sum(preco)/count(preco) media FROM PRESENTES"
    rs.each do |registro|
      presente_preco = registro['media'].to_i 
      vetpresente.push(presente_preco)
    end  
    vetpresente
  end

  def moda
    vetpresente = []
    rs = @con.exec "SELECT preco, count(preco) contador FROM PRESENTES group by preco order by contador DESC limit 1"
    rs.each do |registro|
      presente_preco = registro['preco'].to_i 
      vetpresente.push(presente_preco)
    end  
    vetpresente
  end
    
  def listar
   	vetpresente = []
   	rs = @con.exec "SELECT * FROM presentes"
  	rs.each do |registro|
   		presente = Presente.new
   		presente.id = registro['id'].to_i
      presente.preco = registro['preco'].to_i
   		presente.nome = registro['nome'].to_s
      presente.icone = registro['icone'].to_s
  		vetpresente.push(presente)
   	end  
   	vetpresente
  end
    
  def excluir(id)    	  
    @con.exec_params("DELETE FROM presentes WHERE id = $1", [id])
  end	
end	