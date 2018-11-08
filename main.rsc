module demo::basic::Factorial


import IO;                                   
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;




public int fac(int N) = N <= 0 ? 1 : N * fac(N - 1); 

public int fac2(0) = 1; 
public default int fac2(int N) = N * fac2(N - 1); 

public int fac3(int N)  { 
  if (N == 0) 
    return 1;
  return N * fac3(N - 1);
}


public void squares(int N){
  println("Table of squares from 1 to <N>"); 
  for(int I <- [1 .. N + 1])
      println("<I> squared = <I * I>");      
}

// a solution with a multi line string template:

public str squaresTemplate(int N) 
  = "Table of squares from 1 to <N>
    '<for (int I <- [1 .. N + 1]) {>
    '  <I> squared = <I * I><}>
    ";