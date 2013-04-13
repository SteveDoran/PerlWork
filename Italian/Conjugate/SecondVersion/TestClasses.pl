
use v5.14;

use VerbFormDescription;
use VerbTenseDescription;

tie(my @array1, "VerbFormDescription");
tie(my @array2, "VerbTenseDescription");

map { print $_, "\n" } @array1;
map { print $_, "\n" } @array2;
