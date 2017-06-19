 # enconding: utf-8

require 'pg'
require 'sinatra'
require 'erb'
require './database.rb'
require 'sinatra/base'
require 'tilt/erb'
require 'rubygems'
#require 'twilio-ruby' 

get '/' do
	if (session[:login].nil? && session[:senha].nil?)
		erb :home	
	else	
		redirect '/admin'
	end
end

get '/admin/adicionar' do
	erb :form
end

post '/admin/adicionar' do

	comunicador = Comunicador.new
	comunicador.nome = params['nome'].to_s
	comunicadorDAO = ComunicadorDAO.new
	id = comunicadorDAO.adicionar(comunicador)
	comunicador.id = id

	extensao = File.extname(params['arquivo'][:filename])

	comunicador.foto = "/upload/comunicador_"+id.to_s+extensao

	comunicadorDAO.adicionarFoto(comunicador)

 	File.open("./public/upload/comunicador_"+id.to_s+extensao, "wb") do |f|
  		f.write(params['arquivo'][:tempfile].read)
 	end

	erb :form
	redirect '/'
end

get '/admin/listar' do
	comunicadorDAO = ComunicadorDAO.new
	@vet = comunicadorDAO.listar
	erb :listar
end

get '/listar' do
	comunicadorDAO = ComunicadorDAO.new
	@vet = comunicadorDAO.listar
	erb :listarvisitante
end

get '/admin/excluir/:id' do
	comunicadorDAO = ComunicadorDAO.new

	rs = comunicadorDAO.obter(params['id'].to_i)
	filename = rs.foto
	File.delete("./public#{filename}")
	comunicadorDAO.excluir(params['id'].to_i)

	redirect '/admin/listar'
end

get '/admin/tela_alterar/:id' do
	comunicadorDAO = ComunicadorDAO.new
	@comunicador = comunicadorDAO.obter(params['id'].to_i)
	erb :tela_alterar
end

post '/admin/alterar' do
	comunicador = Comunicador.new
	comunicador.id = params['id'].to_i
	comunicador.nome = params['nome'].to_s
	comunicadorDAO = ComunicadorDAO.new
	comunicadorDAO.editar(comunicador)
	redirect '/admin/listar'
end

get '/admin/adicionarPrograma' do
	comunicadorDAO = ComunicadorDAO.new
	@vet = comunicadorDAO.listar
	erb :formPrograma
end

post '/admin/adicionarPrograma' do
	programa = Programa.new
	programa.nome = params['nome'].to_s
	programa.dias = params['dias'].to_s
	programa.hora_inicio = params['hora_inicio'].to_i
	programa.hora_fim = params['hora_fim'].to_i
	programa.duracao = (programa.hora_fim - programa.hora_inicio).to_i
	programa.id_comunicador = params['id_comunicador'].to_i

	programaDAO = ProgramaDAO.new
	id = programaDAO.adicionar(programa)
 	programa.id = id

 	extensao = File.extname(params['arquivo'][:filename])

	programa.logo = "/upload/programa_"+id.to_s+extensao

 	File.open("./public/upload/programa_"+id.to_s+extensao, "wb") do |f|
  	 f.write(params['arquivo'][:tempfile].read)
 	end

 	programaDAO.adicionarFoto(programa)

	comunicadorDAO = ComunicadorDAO.new
	@vet = comunicadorDAO.listar

	erb :formPrograma
	redirect '/admin/listarProgramas'
end

get '/admin/listarProgramas' do
	programaDAO = ProgramaDAO.new
	@vetProgramas = programaDAO.listar
	erb :listarProgramas
end

get '/listarProgramas' do
	programaDAO = ProgramaDAO.new
	@vetProgramas = programaDAO.listar
	erb :listarProgramasvisitante
end

get '/admin/excluirPrograma/:id' do
	programaDAO = ProgramaDAO.new

	rs = programaDAO.obter(params['id'].to_i)
	filename = rs.logo
	File.delete("./public#{filename}")

	programaDAO.excluir(params['id'].to_i)
	redirect '/admin/listarProgramas'
end

get '/admin/tela_alterarProgramas/:id' do
	programaDAO = ProgramaDAO.new
	@programa = programaDAO.obter(params['id'].to_i)
	erb :tela_alterarProgramas
end

post '/admin/alterarPrograma' do
	programa = Programa.new
	programa.id = params['id'].to_i
	programa.nome = params['nome'].to_s
	programa.dias = params['dias'].to_s
	programa.hora_inicio = params['hora_inicio'].to_i
	programa.hora_fim = params['hora_fim'].to_i
	programa.duracao = (programa.hora_fim - programa.hora_inicio).to_i
	programa.id_comunicador = params['id_comunicador'].to_i
	programaDAO = ProgramaDAO.new
	programaDAO.editar(programa)
	redirect '/admin/listarProgramas'
end

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/login/form' do
  erb :login_form, :layout => :layout2
end

get '/' do
  erb :home, :layout => :layout3
end

get '/admin' do
  erb :homead, :layout => :layout3
end

post '/login/attempt' do
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from
end

enable :sessions

before '/admin*' do
  if (session[:login].nil? && session[:senha].nil?)
  	halt 404, "Voce nao eh admin!"
  end
end

get '/logout' do
	session.clear
	redirect '/' 
end

get '/admin/extras' do
	erb :ajax
end

post '/login' do
	login = params['login']
	senha = params['senha']
	
	if (login == "admin" && senha == "123")
		session[:login] = login
		session[:senha] = senha
		redirect '/admin'
	else 
		@m = "Login e Senha nao combinam"
		erb :home
	end
end

get '/admin' do
	erb :homead
end

get '/adiciona/:parametro' do
	con = params['parametro']
	comunicador = Comunicador.new
	comunicador.nome = params['parametro'].to_s
	comunicadorDAO = ComunicadorDAO.new
	id = comunicadorDAO.adicionar(comunicador)
end