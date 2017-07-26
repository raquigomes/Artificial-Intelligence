:-dynamic(ganha/1).

%(lista com a posicao, ultima peca jogada)
estado_inicial(([(p(1,1), _),(p(1,2), _),(p(1,3), _),(p(1,4), _),(p(1,5), _),(p(1,6), _),(p(1,7), _),
                 (p(2,1), _),(p(2,2), _),(p(2,3), _),(p(2,4), _),(p(2,5), _),(p(2,6), _),(p(2,7), _),
                 (p(3,1), _),(p(3,2), _),(p(3,3), _),(p(3,4), _),(p(3,5), _),(p(3,6), _),(p(3,7), _),
                 (p(4,1), _),(p(4,2), _),(p(4,3), _),(p(4,4), _),(p(4,5), _),(p(4,6), _),(p(4,7), _),
                 (p(5,1), _),(p(5,2), _),(p(5,3), _),(p(5,4), _),(p(5,5), _),(p(5,6), _),(p(5,7), _),
                 (p(6,1), _),(p(6,2), _),(p(6,3), _),(p(6,4), _),(p(6,5), _),(p(6,6), _),(p(6,7), _)], _)).


valor((E, _), 100, _):-
	(linhas(E);colunas(E);diagonais(E)),
	ganhador(o),
	!.

valor((E, _), -100, _):-
	(linhas(E);colunas(E);diagonais(E)),
	ganhador(x),
	!.

valor((E, _), 0, _):- 
	empate(E),
	!.


terminal((E,_)):-
	linhas(E);colunas(E);diagonais(E);empate(E).

linhas(E):-
	(findall(X1,member((p(1, _), X1),E), L1),check(L1, 0, 0));
	(findall(X2,member((p(2, _), X2),E), L2),check(L2, 0, 0));
	(findall(X3,member((p(3, _), X3),E), L3),check(L3, 0, 0));
	(findall(X4,member((p(4, _), X4),E), L4),check(L4, 0, 0));
	(findall(X5,member((p(5, _), X5),E), L5),check(L5, 0, 0));
	(findall(X6,member((p(6, _), X6),E), L6),check(L6, 0, 0)).

colunas(E):-
	(findall(X1,member((p(_, 1), X1),E), C1),check(C1, 0, 0));
	(findall(X2,member((p(_, 2), X2),E), C2),check(C2, 0, 0));
	(findall(X3,member((p(_, 3), X3),E), C3),check(C3, 0, 0));
	(findall(X4,member((p(_, 4), X4),E), C4),check(C4, 0, 0));
	(findall(X5,member((p(_, 5), X5),E), C5),check(C5, 0, 0));
	(findall(X6,member((p(_, 6), X6),E), C6),check(C6, 0, 0)).

diagonais(E):-
	diagonais_1(E);diagonais_2(E).

diagonais_1(E):-
	(findall(J1, (member((p(X1,Y1), J1), E), (diagonal_left_half_1(4, 1, LP1), member((X1, Y1), LP1))), D1),check(D1, 0, 0));
	(findall(J2, (member((p(X2,Y2), J2), E), (diagonal_left_half_1(5, 1, LP2), member((X2, Y2), LP2))), D2),check(D2, 0, 0));
	(findall(J3, (member((p(X3,Y3), J3), E), (diagonal_left_half_1(6, 1, LP3), member((X3, Y3), LP3))), D3),check(D3, 0, 0));
	(findall(J4, (member((p(X4,Y4), J4), E), (diagonal_right_half_1(6, 2, LP4), member((X4, Y4), LP4))), D4),check(D4, 0, 0));
	(findall(J5, (member((p(X5,Y5), J5), E), (diagonal_right_half_1(6, 3, LP5), member((X5, Y5), LP5))), D5),check(D5, 0, 0));
	(findall(J6, (member((p(X6,Y6), J6), E), (diagonal_right_half_1(6, 4, LP6), member((X6, Y6), LP6))), D6),check(D6, 0, 0)).

diagonais_2(E):-
	(findall(J1, (member((p(X1,Y1), J1), E), (diagonal_right_half_2(4, 7, LP1), member((X1, Y1), LP1))), D1),check(D1, 0, 0));
	(findall(J2, (member((p(X2,Y2), J2), E), (diagonal_right_half_2(5, 7, LP2), member((X2, Y2), LP2))), D2),check(D2, 0, 0));
	(findall(J3, (member((p(X3,Y3), J3), E), (diagonal_right_half_2(6, 7, LP3), member((X3, Y3), LP3))), D3),check(D3, 0, 0));
	(findall(J4, (member((p(X4,Y4), J4), E), (diagonal_right_half_2(6, 6, LP4), member((X4, Y4), LP4))), D4),check(D4, 0, 0));
	(findall(J5, (member((p(X5,Y5), J5), E), (diagonal_left_half_2(6, 5, LP5), member((X5, Y5), LP5))), D5),check(D5, 0, 0));
	(findall(J6, (member((p(X6,Y6), J6), E), (diagonal_left_half_2(6, 4, LP6), member((X6, Y6), LP6))), D6),check(D6, 0, 0)).
