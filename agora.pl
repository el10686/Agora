atomtoint([],[]).
atomtoint([Head|Tail],[Neo|Lista]):-
    atom_number(Head,Neo),
    atomtoint(Tail,Lista).

read_input(File,Lista,N) :-
    open(File, read, Stream),
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atom_number(Atom, N),
    read_lines(Stream,Lista).

read_lines(Stream,Lista):-
    read_line_to_codes(Stream,Line),
    atom_codes(Atom,Line),
    atomic_list_concat(List,' ',Atom),
    atomtoint(List,Lista).

sys_gcd(X, 0, X) :- !.
sys_gcd(X, Y, Z) :-
   H is X rem Y,
   sys_gcd(Y, H, Z).

%euclid(A, B, Z) :- B > A, euclid(B, A, Z).
%euclid(A, 0, Z) :- Z is A.
%euclid(A, B, Z) :- X is A mod B, euclid(B, X, Z).
%gcd(A, B, Z) :- euclid(A, B, Z).

lcm(X,Y,LCM) :-
	sys_gcd(X,Y,GCD),
	LCM is X * Y / GCD.

lcm_list([A],[A]).
lcm_list([A,B|C], [HD|LIST]) :-
	lcm(1,A,HD),
	lcm(A,B,TEMP),
	lcm_list([TEMP|C],LIST).

lcm_final([_,_],[_,_|_],[]).
lcm_final([_,_|_],[_,_],[]).
lcm_final([_,_],[_,_],[]).
lcm_final([A1,B1,C1|D1],[_,B2,C2|D2],[LCM1|TEMP]) :-
	lcm(A1,C2,LCM1),
	lcm_final([B1,C1|D1],[B2,C2|D2],TEMP).

total_rev(Xs, Ret) :-
	rev(Xs, [], Ret).
rev([], Z, Z).
rev([Head|Tail], Z, Ret) :-
	rev(Tail,[Head|Z], Ret). 

min_in_list([Min],Min).                 
min_in_list([H,K|T],M) :-
	( H =< K ->                             
    	  min_in_list([H|T],M)
        ; min_in_list([K|T],M)
	).      

index1(N,[HD|TL],RES) :-
	( N =:= HD ->
		RES is 1
	; index1(N,TL,TMP),
	  RES is 1 + TMP
	).
	
put_first(X,Elem,[Elem|X]).

put_last(X,Elem,Result) :-
	append(X,[Elem],Temp),
	Result = Temp.

get_2nd([_,B|_], RES):-
	RES = B.

get_protelefteo([A,_],RES) :-
	RES = A.
get_protelefteo([_,B|C],RES) :-
	get_protelefteo([B|C],RES).

get_telefteo([_,B],RES) :-
	RES = B.
get_telefteo([_,B|C],RES) :-
	get_telefteo([B|C],RES).
	
agora_semi(INPUT, When, Missing) :-
	lcm_list(INPUT,LCM_RIGHT),
	total_rev(INPUT,REV),
	lcm_list(REV,Temp),
	total_rev(Temp,LCM_LEFT),
	lcm_final(LCM_RIGHT,LCM_LEFT,LCM_FINAL),
	nth0(1, LCM_LEFT, First),
	%get_2nd(LCM_LEFT,First),
	get_protelefteo(LCM_RIGHT,Last),
	put_first(LCM_FINAL,First, Final),
	put_last(Final, Last, Finall),
	min_in_list(Finall,Min),
	get_telefteo(LCM_RIGHT, Telefteo),
	index1(Min, Finall, INDEX),
	(Min =:= Telefteo ->
			Missing = 0
	; Missing = INDEX),
	When = Min.

agora(FILE, When, Missing) :-
	read_input(FILE, INPUT, _),
	once(agora_semi(INPUT, When, Missing)).

