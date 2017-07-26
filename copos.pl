% Para um problema deve descrever:

% estado_inicial([Condicoes])

% estado_final  ([Condicoes]).

% e declarar as accoes que permitem modelar o seu problema com o seguinte predicado:

% accao(a1,Precondições,AddList,DeleteList).

%/* Exemplo para o problema: copos 1, 2, 3, 4 */



accao(vira_copo_cima_cima(A,B),[baixo(A),baixo(B)],[cima(A),cima(B)],[baixo(A),baixo(B)]):- member(A,[1,2,3]),
						 		   															member(B,[2,3,4]), 
						 		   															B is A+1.


accao(vira_copo_baixo_baixo(A,B),[cima(A),cima(B)],[baixo(A),baixo(B)],[cima(A),cima(B)]):- member(A,[1,2,3]),
						 		   															member(B,[2,3,4]), 
						 		   															B is A+1.


accao(vira_copo_cima_baixo(A,B),[baixo(A),cima(B)],[cima(A),baixo(B)],[baixo(A),cima(B)]):- member(A,[1,2,3]),
						 		   															member(B,[2,3,4]), 
						 		   															B is A+1.


accao(vira_copo_baixo_cima(A,B),[cima(A),baixo(B)],[baixo(A),cima(B)],[cima(A),baixo(B)]):- member(A,[1,2,3]),
						 		   															member(B,[2,3,4]), 
						 		   															B is A+1.

						  																			


accao(troca_copo_cima_baixo(A,B), [cima(A),baixo(B)], [cima(B),baixo(A)], [cima(A),baixo(B)]):- member(A,[1,2,3,4]),
						  																		member(B,[1,2,3,4]),
						  																		A\=B.


accao(troca_copo_baixo_cima(A,B), [baixo(A),cima(B)], [baixo(B),cima(A)], [baixo(A),cima(B)]):- member(A,[1,2,3,4]),
						  																		member(B,[1,2,3,4]),
						  																		A\=B.



%############################ESTADOS##############################

estado_inicial([baixo(1),cima(2), baixo(3), baixo(4)]).



estado_final([cima(1),cima(2), cima(3), baixo(4)]).
