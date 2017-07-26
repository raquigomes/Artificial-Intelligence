:-dynamic(ganha/1).

%(lista com a posicao, ultima peca jogada)
estado_inicial(([
	(p(1,1), _),
	(p(1,2), _),
	(p(1,3), _),
        (p(2,1), _),
	(p(2,2), _),
	(p(2,3), _),
	(p(3,1), _),
	(p(3,2), _),
	(p(3,3), _)],_)).

%asserta - O termo é afirmado como a primeiro cláusula do predicado correspondente
setValor(valor(V)):-
	retractall(valor(_)), 
	asserta(valor(V)).


% joga o jogador X

valor((E, _), 1, _):-
	(linhas(E);colunas(E);diagonais(E)),
	ganha(o),
	!. %cut

valor((E, _), -1, _):-
	(linhas(E);colunas(E);diagonais(E)),
	ganha(x),
	!.

valor((E, _), 0, _):- 
	empate(E),
	!.


terminal((E, _)):-
	linhas(E);colunas(E);diagonais(E);empate(E).

linhas(E):-
	(linha(E,1);linha(E,2);linha(E,3)).

colunas(E):-
	(coluna(E,1);coluna(E,2);coluna(E,3)).


%retractall - Todos as cláusulas de dados para o qual a cabeça unifica com a Cabeça são removidos. Se Head se refere a um predicado que não está definido, é implicitamente criado como um predicado dinâmico.
guarda(ganha(P)):- 
	retractall(ganha(_)), 
	asserta(ganha(P)),
	!.

%atom - Verdadeiro se o termo está ligado a um átomo.
coluna(E,Y):-
	findall(P, (member((p(_,Y),P),E), atom(P)),L),
	length(L, S),
	S = 3,
	L = [O,O,O], guarda(ganha(O)),!.
	
linha(E,X):-
	findall(P, (member((p(X,_),P),E), atom(P)),L),
	length(L, S),
	S = 3,
	L = [O,O,O], guarda(ganha(O)),!.


% diagonais(Estado, Valor)

diagonais(E):-
	(diagonal_1(E, 1, 0, 0, NX1, _), NX1=3;	
	diagonal_2(E, 1, 0, 0, NX2, _), NX2=3), 
	guarda(ganha(x)), 
	!.

diagonais(E):-
	(diagonal_1(E, 1, 0, 0, _, NO1), NO1=3;
	diagonal_2(E, 1, 0, 0, _, NO2), NO2=3), 
	guarda(ganha(o)), 
	!.


% diagonal_1(Estado, Posicao, XActual, OActual, XSeguinte, OSeguinte)
% member - Verdadeiro se o elemento é um membro da lista

diagonal_1(E, 3, NX, NO, NX2, NO2):-
	member((p(3,3), X), E),
	count(X, NX, NO, NX2, NO2).

diagonal_1(E, I, NX, NO, NX3, NO3):-
	I < 3, I2 is I+1,
	member((p(I,I), X), E),
	count(X, NX, NO, NX2, NO2),
	diagonal_1(E, I2, NX2, NO2, NX3, NO3).


% diagonal_2(Estado, Posicao, XActual, OActual, XSeguinte, OSeguinte )
diagonal_2(E, 3, NX, NO, NX2, NO2):-
	member((p(3,1), X), E),
	count(X, NX, NO, NX2, NO2).

diagonal_2(E, I, NX, NO, NX3, NO3):-
	I < 3, I2 is I+1, J is 4-I,
	member((p(I,J), X), E),
	count(X, NX, NO, NX2, NO2),
	diagonal_2(E, I2, NX2, NO2, NX3, NO3).

%caso de empate
empate(E):-
	todos_atomics(E), 
	asserta(empate).

%atom - verdadeiro se o termo está ligado a um átomo
todos_atomics([]).
todos_atomics([(p(_,_), X)|T]):-
	atom(X),
	todos_atomics(T).


% count(ElementoDaPosicao, Jogador, XAntesIncrementar, OAntesIncrementar, XDepoisIncrementar, XDepoisIncrementar)
count(E, NX, NO, NX2, NO):-
	atom(E), E = x,
	NX2 is NX+1.
count(E, NX, NO, NX, NO2):-
	atom(E), E = o,
	NO2 is NO+1.


op1((E,O), insere(p(X,Y),P), (EF,P)):-
	member(X, [1,2,3]),
	member(Y, [1,2,3]),
	inverteJogada(O,P),	
	insere_posicao(X, Y, P, E, EF).

insere_posicao(X, Y, S, E, EF):-
	member((p(X,Y), J), E),
	\+ nonvar(J), J = S,
	EF = E.


%Contagem do numero de pecas
%Conta apenas 1 peça - o numero total de 1x's ou 1o's 

find_all_1peca(E, J, V):-
	%encontra todos os membros nao atomicos do estado
	findall((p(X,Y), J1), (member((p(X,Y), J1), E),atom(J1)), L),
	findall(J, find_1peca(L, J), L2),
	length(L2, V).


%Encontrar 1x's ou 1o's numa linha

find_1peca(E, J):-
	member((p(X,Y), J), E),
	X1 is X+1, X2 is X-1,
	Y1 is Y-1, Y2 is Y+1,
	\+ member((p(X,Y1),J), E), 
	\+ member((p(X,Y2),J), E), 
	\+ member((p(X1,Y),J), E), 
	\+ member((p(X2,Y),J), E), 
	\+ member((p(X1,Y1),J), E), 
	\+ member((p(X2,Y2),J), E), 
	\+ member((p(X1,Y2),J), E), 
	\+ member((p(X2,Y1),J), E).


%Conta duas peças - o numero total de 2x's ou 2o's 

find_all_2pecas(E, J, V):-
	findall((p(X,Y), J1), (member((p(X,Y), J1), E),atom(J1)), L),
	findall(J, find_2pecas(L, J), L2),
	length(L2, V).


%Encontrar 2x's ou 2o's numa linha

find_2pecas(E, J):-
	member((p(X,Y), J), E),
	Y1 is Y-1,
	member((p(X,Y1),J), E).


%Encontrar 2x's ou 2o's numa coluna

find_2pecas(E, J):-
	member((p(X,Y), J), E),
	X1 is X-1,
	member((p(X1,Y),J), E).


%Encontra 2x's ou 2o's numa diagonal 

find_2pecas(E, J):-
	member((p(X,Y), J), E),
	X1 is X-1, Y1 is Y-1,
	member((p(X1,Y1),J), E).


%Encontra 2x's ou 2o's na outra diagonal

find_2pecas(E, J):-
	member((p(X,Y), J), E),
	X1 is X-1, Y1 is Y+1,
	member((p(X1,Y1),J), E).
	

% avalia(Estado, Tipo_peca, Avaliacao)
%É dado um estado, o tipo de peca (x ou o), retorna em C o valor da avaliacao

func_avalia((E,J), Val,_):-
	inverteJogada(J, J2),
	avalia(E,J2,Val).

avalia(E, J, Val):-
	find_all_1peca(E, J, V1),
	find_all_2pecas(E, J, V2),
	Val1 is V1+(3*V2),
	inverteJogada(J, J2),
	find_all_1peca(E, J2, V3),
	find_all_2pecas(E, J2, V4),
	Val2 is V3+(3*V4),
	Val is (Val1-Val2).

%Inverter as jogadas
	
inverteJogada('x','o').
inverteJogada('o','x').


%Ciclo das jogadas
%Imprime quem e o vencedor

ciclo_jogo(_,(E,J)):- 
	(linhas(E);colunas(E);diagonais(E)), 
	print_(E),
	write('Vencedor: '),
	write(J),
	!.

%Imprime que houve empate
%Write - escrever termo para a saída atual
%nl - escreve um caractere de nova linha 

ciclo_jogo(_,(E,_)):- 
	empate(E), 
	print_(E),
	write('Empate!'),
	nl,
	!.


%Imprime o tempo do jogo e o numero de nos utilizados 

ciclo_jogo('c',(E,J)):-
	nl,print_(E),
	nl,statistics(real_time,[Ti,_]),
	minimax_decidir((E,J),Op),
	statistics(real_time,[Tf,_]), T is Tf-Ti,
	nl, 
	write('Tempo total de jogo: '(T)),
	nl,
	n(N),
	write('Numero de nos utilizados: '(N)),
	iniciaNos,	
	nl,
	write(Op),
	nl,
	nl,
	op1((E,J),Op,Es),
	ciclo_jogo('j',Es).


%Pergunta ao jogador qual a linha  ou a coluna em que quer jogar
%read - lê o próximo termo de input e unifica-o como termo
%Agente inteligente

ciclo_jogo('j',(E,J)):-
	print(E),
	nl,
	write('Escreva a linha da posicao onde deseja jogar: '),
	read(X),
	write('Escreva a coluna da posicao onde deseja jogar: '),
	read(Y),
	inverteJogada(J,J1),
	op1((E,J),
	insere(p(X,Y),J1),Es),nl,
	print(E),nl,
	ciclo_jogo('c',Es).

%Imprime todas as linhas

print_(E):-
	print_linhas(E).



print_linhas(E):-
	write('       '),
	print_linha(E, 1, 1),
	write('       '),
	write_line(1, 3),
	write('       '),
	print_linha(E, 2, 1),
	write('       '),
	write_line(1, 3),
	write('       '),
	print_linha(E, 3, 1),
	write('\n\n').


print_linha(E, I, J):-
	member((p(I,J), X), E),
	J = 3,
	write_last_element(X),
	write('\n').

print_linha(E, I, J):-
	\+member((p(I,J), X), E),
	J = 3,
	write_last_element(X).

print_linha(E, I, J):-
	J < 3, J2 is J+1,
	member((p(I,J), X), E),
	write_elements(X),
	print_linha(E, I, J2).

print_linha(E, I, J):-
	J < 3, J2 is J+1,
	\+member((p(I,J), X), E),
	write_elements(X),
	print_linha(E, I, J2).

write_line( I, P):-
        I = P, 
	write('- - -'), 
	nl.

write_line( I, P):-
        I < P, I2 is I+1,
        write('- '),
        write_line(I2, P).

%nonvar - é verdadeiro se o termo atual não é uma variável livre 

write_elements(X):-
	nonvar(X),
	write(X),
	write(' | ').

write_elements(X):-
	\+ nonvar(X),
	write(' '),
	write(' | ').

write_last_element(X):-
	nonvar(X),
	write(X).

write_last_element(X):-
	\+ nonvar(X),
	write(' ').


	
