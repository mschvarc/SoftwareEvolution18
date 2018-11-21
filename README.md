# SoftwareEvolution18
## Martin SchvarcBacher and Jelle Manders



## Duplicate Lines of Code (LOC)
Duplicate lines of code are defined as chunks of at least six lines, if we encounter six lines of code and encounter these exact same lines (excluding comments and whitelines) later, the second (and third, fourth, and so on) will be marked as duplicate. Note that the original will not be marked as a duplicate, hence the ratio of duplicate code will never quite reach 1.
Since the Duplicate chunks can also be bigger than 6 lines, we devised a sort of sliding window approach. The algorrithm works as follows:
* All of the file locations in the current project are loaded into memory.
* For each file, we do a first pass over the lines and remove all whitespace and comment lines.
* Then, for each line, we take the next five lines after it and count this as a chunk. If it is an unknown chunk, we store it in a set.
* If the chunk is already in the set, this means we have encountered this chunk before. We mark this section of six lines as duplicate.
* If the last chunk that we checked already was a duplicate chunk, this means we haven't found a completely new duplicate chunk. We just found a duplicate chunk that is more than 6 lines long. Instead of marking all of the code as duplicate, we only add 1 LOC to the duplicate counter.
* After parsing all of the files like this we have counted how many LOC we encountered, and how many of these are encountered more than once. This gives us all the necessary information to calculate the Duplication Rate.
