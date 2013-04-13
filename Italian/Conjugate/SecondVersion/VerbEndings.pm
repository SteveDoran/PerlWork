
package VerbEndings;
use Carp;
use feature "switch";

use VerbFormDescription;
use VerbTenseDescription;

tie(my @forms,  "VerbFormDescription");
tie(my @tenses, "VerbTenseDescription");

sub new {
    my $invocant = shift;
    my $endings = {
      "are" => [],
      "ere" => [],
      "ire" => []
    };
    for my $index (0 .. $#tenses) {
        my $tar;
        given ($index) {
            when (0) {
                $tar = [ "o", "i", "a", "iamo", "ate", "ano" ]
            }
            when (1) {
                $tar = [ "avo", "avi", "ava", "avamo", "avate", "avano" ]
            }
            when (2) {
                $tar = [ "erò", "erai", "erà", "eremo", "erete", "eranno" ]
            }
            when (3) {
                $tar = [ "erei", "eresti", "erebbe", "eremmo", "ereste", "erebbero" ]
            }
            when (4) {
                $tar = [ "ai", "asti", "ò", "ammo", "aste", "arono" ]
            }
            when (5) {
                $tar = [ "i", "i", "i", "iamo", "iate", "ino" ]
            }
            when (6) {
                $tar = [ "assi", "assi", "asse", "assimmo", "aste", "assero" ]
            }
        }
        $endings->{"are"}->[$index] = [ @{$tar}];
    }
    for my $index (0 .. $#tenses) {
        my $tar;
        given  ($index) {
            when (0) {
                $tar = [ "o", "i", "e", "iamo", "ete", "ono" ]
            }
            when (1) {
                $tar = [ "evo", "evi", "eva", "evamo", "evate", "evano" ]
            }
            when (2) {
                $tar = [ "erò", "erai", "erà", "eremo", "erete", "eranno"  ]
            }
            when (3) {
                $tar = [ "erei", "eresti", "erebbe", "eremmo", "ereste", "erebbero" ]
            }
            when (4) {
                $tar = [ "ei", "esti", "ette", "emmo", "este", "ettero" ]
            }
            when (5) {
                $tar = [ "a", "a", "a", "iamo", "iate", "ano" ]
            }
            when (6) {
                $tar = [ "essi", "essi", "esse", "essimmo", "este", "essero" ]
            }
        }
        $endings->{"ere"}->[$index] = [ @{$tar}];
    }
    for my $index (0 .. $#tenses) {
        my $tar;
        given ($index) {
            when (0) {
                $tar = [ "o", "i", "e", "iamo", "ite", "ono" ]
            }
            when (1) {
                $tar = [ "ivo", "ivi", "iva", "ivamo", "ivate", "ivano" ]
            }
            when (2) {
                $tar = [ "irò", "irai", "irà", "iremo", "irete", "iranno"  ]
            }
            when (3) {
                $tar = [ "irei", "iresti", "irebbe", "iremmo", "ireste", "irebbero" ]
            }
            when (4) {
                $tar = [ "iì", "isti", "i", "immo", "iste", "irono" ]
            }
            when (5) {
                $tar = [ "a", "a", "a", "iamo", "iate", "ano" ]
            }
            when (6) {
                $tar = [ "issi", "issi", "isse", "issimmo", "iste", "issero" ]
            }
        }
        $endings->{"ire"}->[$index] = [ @{$tar}];
    }
    
    return bless $endings, $invocant;
}

sub conjugate {
    my $invocant = shift;
    confess "Not a class method" unless ref $invocant;
    
    my $verb = shift;
    my ($root, $type);
    
    
    if ($verb =~ /(.+)([a|e|i]re)/) {
        $root = $1;
        $type = $2;
    } else {
        print "Not a valid verb\n";
    }
    
    my $nodearray = $invocant->{$type};
    
    for my $row (0 .. $#tenses) {
        print "Conjugating $tenses[$row] form of $verb\n";
        for my $column (0 .. $#forms) {
            print uc $forms[$column],
                  ": ",
                  ($root . $nodearray->[$row]->[$column]),
                  "\n"
            ; 
        }
    }
}

1;