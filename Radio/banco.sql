create table comunicadores(
id SERIAL,
foto VARCHAR(200),  
nome VARCHAR(30),
primary key (id)
);

create table programas(
id SERIAL,
logo VARCHAR(200),
nome VARCHAR(100),
duracao integer, 
dias VARCHAR(30),
hora_inicio integer,
hora_fim integer,
id_comunicador integer references comunicadores (id),
primary key (id, id_comunicador)
);
