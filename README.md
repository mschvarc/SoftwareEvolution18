# SoftwareEvolution18
## Martin Schvarcbacher and Jelle Manders

## Volume
The volume metric is by far the simplest of the analyzed four; We simply go over all of the Java Files, strip them of all comment and blank lines, and count whatever is left. This is done by asking RASCAL for all of the JAVA files in the project, parsing each of them with our Comment and Whiteline stripper, and counting the amount of lines left.

|Project| volume | Rating |
| ---| ---| ---|
|SmallSQL| 24050 | `++` | 
|HSQL| 172119 | `+` |

## Unit Size
Units are "the smallest piece of code that can be executed and tested individually" (Heitlager). For JAVA, these units are functions. This makes our life very easy, since RASCAL has a builtin method (`MR.methods()`) that returns the strings encompassing all of the functions in a project. We simply call this function over the given project, parse all of the chunks of code given to us by this function, strip the chunk of all empty and comment lines, including docblocks at the top of the function, and count whatever is left. We average this result over all of the methods in the project, and end up with the Average Unit Size in the project.

### Results

|Project| Unit Size | Rating |
| ---| ---| ---|
|SmallSQL| 8.8 | `++` | 
|HSQL| 13.9 | `++` |

## Duplicate Lines of Code (LOC)
Duplicate lines of code are defined as chunks of at least six lines, if we encounter six lines of code and encounter these exact same lines (excluding comments and whitelines) later, the second (and third, fourth, and so on) will be marked as duplicate. Note that the original will not be marked as a duplicate, hence the ratio of duplicate code will never quite reach 1.
Since the Duplicate chunks can also be bigger than 6 lines, we devised a sort of sliding window approach. The algorrithm works as follows:
* All of the file locations in the current project are loaded into memory.
* For each file, we do a first pass over the lines and remove all whitespace and comment lines.
* Then, for each line, we take the next five lines after it and count this as a chunk. If it is an unknown chunk, we store it in a set.
* If the chunk is already in the set, this means we have encountered this chunk before. We mark this section of six lines as duplicate.
* If the last chunk that we checked already was a duplicate chunk, this means we haven't found a completely new duplicate chunk. We just found a duplicate chunk that is more than 6 lines long. Instead of marking all of the code as duplicate, we only add 1 LOC to the duplicate counter.
* After parsing all of the files like this we have counted how many LOC we encountered, and how many of these are encountered more than once. This gives us all the necessary information to calculate the Duplication Rate.

### Results

| Project | Duplicates | Total LOC | Percentage | Rating |
| --- | --- | --- | --- | --- |
| SmallSQL | 2274 | 24050 | 9.45% | `0` |
| HSQL| 23236 | 172119 | 13.5% | `--` |



## Cyclomatic Complexity

We use M3 to convert the Java source code to an AST. For each encountered unit (method for Java), we traverse the AST declaration. 
For each branch in a method, we count the number of branching statements (`if`, `else if`, `else`, `case` inside `switch`, `ternary operator`) and inside each if statement we add a new branch for each `&&` and `||` operator.

The resulting cyclomatic complexity is aggregated into 5 separate "bins" according to the SIG cyclomatic complexity rating methodology. 
From this we derive the final SIG rating. 

### Results:

| Project | Low Risk | Medium Risk | High Risk | Very High Risk | Rating |
| --- |  --- |  --- |  --- |  --- |  --- | 
| SmallSQL | 74% | 7% | 12% | 6% | `--` |
| HSQLDB | 65% | 13% | 11.6% | 10% | `--` |


## Aggregated Metrics
For each atomic metric described above we can derive aggregated metrics using at least two or more atomic metrics. 
We assign a numeric value to each SIG rating (5 = `++`, 1 = `--`) and use arithmentic average of the individual ratings to derive the aggregated metric. 
The numeric rating is then converted in reverse to the SIG rating. 

The SIG ratings can be converted to ISO 9126 maintainability ratings by taking the average of multiple SIG metrics. 

### Results

#### SmallSQL

Analysability: `+`

Changeability: `-`

Testability: `0`

Maintainability: `0`


#### HSQL

Analysability: `0`

Changeability: `--`

Testability: `0`

Maintainability: `-`
