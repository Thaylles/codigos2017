 # enconding: utf-8

require 'pg'
require 'sinatra'
require 'erb'
require './database.rb'
require 'sinatra/base'
require 'tilt/erb'
require 'rubygems'

get '/' do
	erb :home	
end

get '/adicionar' do
	erb :form
end

post '/adicionar' do

	presente = Presente.new
	presente.nome = params['nome'].to_s
	presente.preco = params['preco'].to_i
	presenteDAO = PresenteDAO.new
	id = presenteDAO.adicionar(presente)
	presente.id = id

	extensao = File.extname(params['arquivo'][:filename])

	presente.icone = "/upload/presente_"+id.to_s+extensao

	presenteDAO.adicionarIcone(presente)

 	File.open("./public/upload/presente_"+id.to_s+extensao, "wb") do |f|
  		f.write(params['arquivo'][:tempfile].read)
 	end

	erb :form
	redirect '/'
end

get '/listar' do
	presenteDAO = PresenteDAO.new
	@vet = presenteDAO.listar
	erb :listar
end

get '/excluir/:id' do
	presenteDAO = PresenteDAO.new

	rs = presenteDAO.obter(params['id'].to_i)
	filename = rs.icone
	File.delete("./public#{filename}")
	presenteDAO.excluir(params['id'].to_i)

	redirect '/listar'
end

get '/precos' do
	presenteDAO = PresenteDAO.new
	session[:media] = presenteDAO.media
	session[:menor] = presenteDAO.menor
	session[:maior] = presenteDAO.maior
	session[:moda] = presenteDAO.moda
	erb :precos
end

get '/ultimos' do
	presenteDAO = PresenteDAO.new
	vet = presenteDAO.listarUltimos
    vet
end

configure do
  enable :sessions
end

get '/' do
  erb :home, :layout => :layout
end

enable :sessions