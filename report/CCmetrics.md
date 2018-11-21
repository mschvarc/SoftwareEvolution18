## Cyclomatic Complexity

We use M3 to convert the Java source code to an AST. For each encountered unit (method for Java), we traverse the AST declaration. 
For each branch in a method, we count the number of branching statements (`if`, `else if`, `else`, `case` inside `switch`, `ternary operator`) and inside each if statement we add a new branch for each `&&` and `||` operator.

The resulting cyclomatic complexity is aggregated into 5 separate "bins" according to the SIG cyclomatic complexity rating methodology. 
From this we derive the final SIG rating. 

### Results:

|Project|Low Risk | Medium Risk | High Risk | Very High Risk | Rating |
| --- |  --- |  --- |  --- |  --- |  --- | 
|SmallSQL|
|HSQLDB|
