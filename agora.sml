(* Input parse code by Stavros Aronis, modified by Nick Korasidis. *)
fun agora file =
	let
		(* A function to read an integer from specified input. *)
        	fun readInt input = 
	    	Option.valOf (TextIO.scanStream (IntInf.scan StringCvt.DEC) input):IntInf.int

		(* Open input file. *)
    		val inStream = TextIO.openIn file

        	(* Read an integer (number of villages) and consume newline. *)
		val n = readInt inStream
		val _ = TextIO.inputLine inStream

	        (* A function to read N integers from the open file. *)
		fun readInts 0 acc:IntInf.int list = (rev acc) (* Replace with 'rev acc' for proper order. *)
		  | readInts i acc:IntInf.int list = readInts (i - 1) (readInt inStream :: acc)

		fun gcd (a, 0) = a	
			| gcd (a,b) = gcd (b, (a mod b))

		fun lcm (a, b) = 
			let 
				val d = gcd (a, b)
	         	in 
				a * b div d
       
	       	 	 end

		fun lcm_list [] = raise Empty
			| lcm_list [a] = [a]
			| lcm_list (a :: b :: tl) = 
				let 
					val acc = 1
				in 
	
					lcm(acc,a) :: lcm_list (lcm(a,b) :: tl)
				end

		fun lcm_final [] [] = raise Empty
			| lcm_final (_::_) [] = raise Empty
			| lcm_final [] (_::_) = raise Empty
			| lcm_final [x] (_::_) = raise Empty
			| lcm_final (_::_) [y] = raise Empty
			| lcm_final (x1 :: x2 :: xs) (y1 :: y2 :: ys) = if (xs=[] orelse ys=[]) then []
				else lcm(x1, hd ys) :: (lcm_final (x2 :: xs) (y2::ys))


		fun minimum [] = raise Empty 
 			| minimum [x] = x
 			| minimum (x::xs) = IntInf.min(x, minimum xs)

		fun index num [] = raise Empty
			| index (num:IntInf.int) (x::xs) = if num = x then 1
				else 1 + index num xs 

	   		val a =	#2 (n, readInts n []);
			val lcm_right = lcm_list a;
			val c = rev a;
			val d = lcm_list c;
			val lcm_left = rev d;
			val full_final = [List.nth(lcm_left,1)] @ lcm_final lcm_right lcm_left @ [List.nth(lcm_right, length(lcm_right)-2)];
			val result = minimum(full_final);
			val pos = if result = List.nth(lcm_right, length(lcm_right)-1) then 0
				else (index result full_final) 
	in
			print (IntInf.toString (result)); print" "; print (IntInf.toString (pos)); print"\n"
	end

