module HelloWorld

import IO;

public void fizzbuzz() {
	for(int i <- [1..17]) {
		if(i % 3 == 0){
			if(i % 5 == 0){
				println("FizzBuzz");
			} else {
				println("Fizz");
			}
		} elseif(i % 5 == 0) {
			println("Buzz");
		} else {
			println(i);
		}
	}
}