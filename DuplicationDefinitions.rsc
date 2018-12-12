module DuplicationDefinitions

alias DuplicationResult = tuple[int duplicationCount, list[loc] fileLocations];
alias DuplicationResults = list[DuplicationResult];
alias DuplicateMap = map[node, set[node]];

data DuplicationType = TYPE_ONE() | TYPE_TWO() | TYPE_THREE();


alias CloneReport = map[str, set[tuple[loc path, list[int] indices]]];

