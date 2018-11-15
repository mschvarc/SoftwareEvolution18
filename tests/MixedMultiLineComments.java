1
2
3
//4
/*
 * Comment here
 * CM line 2
//single line comment here
*/

5
6
//7
8
x
/*
 * comment here
 * line 2
*/
//y
z
w
/*
comment here
*/ x == y;
// /* this inner /* must be ignored by multiline comment parser!
y == z; //NOT in a comment
x == z; /*aaaa*/
/*xxx*/z == w;
1 == 2;