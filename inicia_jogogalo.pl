inicia_jogogalo:-menu.

%Inicia a contagem de nos

iniciaNos:-
	retractall(n(_)),
	assertz(n(0)),
	!.


%Incrementa o contador mais N

incrementaMais(N):-
	retract(n(M)),
	M1 is N+M,
	assertz(n(M1)),
	!.


%Limita a profundidade

limita_profundidade(0):-
	retractall(prof(_)), 
	assertz(prof(100)),
	!.
	
limita_profundidade(X):-
	retractall(prof(_)), 
	assertz(prof(X)),
	!.


%Incrementa a profundidade

incrementaProf:-
	p(P),
	P1 is P + 1,
	retract(p(_)), 
	assertz(p(P1)).
	

%Inicia a contagem da profundidade

iniciaProf:-
	retractall(p(_)),
	assertz(p(1)),
	!.


%Funcao main do jogo do galo com o menu inicial
menu:-
	nl,
	write('Jogo do galo: '),
	nl,
	write('1 - Jogo contra o Computador (minimax)'),
	nl,
	nl,
	write('3 - Sair do Programa'),
	nl,
	nl,
	write('Insira um numero de acordo com o que pretende fazer: '),
	read(X),
	menu_opcao(X).


menu_opcao(1):-
	[minimax],	
	[jogodogalo],
	iniciaNos,	
	iniciaProf,
	nl,
	write('Primeiro a jogar: Jogador ou Computador (j ou c)? '),
	read(Jogador),
	nl,
	write('O Jogador fica com as cruzes - x'),
	nl,
	estado_inicial(Ei),nl,
	comeca_ciclo(Jogador,x,Ei),nl,
	write('Deseja sair (s) ou voltar ao menu (m)? '),
	read(X),
	opcao(X).



%predicado de saida do menu
menu_opcao(3).


%Caso não se insira nenhum numero apresentado no menu
menu_opcao(_):-
	nl,
	menu.

opcao('s'):- menu_opcao(3).

opcao('m'):- 
	nl,
	menu.

opcao(_):-
	nl,
	menu.


comeca_ciclo('c', S, (E,P)):-
	P = S,
	ciclo_jogo('c', (E,P)).

comeca_ciclo('j', S, (E,P)):-
	inverteJogada(S,P1),
	P = P1,	
	ciclo_jogo('j', (E,P)).
