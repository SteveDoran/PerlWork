
use v5.14;

sub check_cl(+);
sub init_tenses;

$main::desc    = [ "1 p s", "2 p s", "3 p s", "1 p p", "2 p p", "3 p p" ];
$main::tense   = [ [ "present", 0 ], [ "imperfect", 0 ], [ "future", 0 ],
                   [ "pr cond", 0 ], [ "past hist", 0 ], [ "pr subj", 0 ],
                   [ "imp subj", 0 ] 
                 ];
$main::endings = {
      "are" => [ [ "hold", "o", "i", "a", "iamo", "ate", "ano" ],
                 [ "hold", "avo", "avi", "ava", "avamo", "avate", "avano" ],
                 [ "hold", "erò", "erai", "erà", "eremo", "erete", "eranno" ],
                 [ "hold", "erei", "eresti", "erebbe", "eremmo", "ereste", "erebbero" ],
                 [ "hold", "ai", "asti", "ò", "ammo", "aste", "arono" ],
                 [ "hold", "i", "i", "i", "iamo", "iate", "ino" ],
                 [ "hold", "assi", "assi", "asse", "assimmo", "aste", "assero" ]
               ],
      "ere" => [ [ "hold", "o", "i", "e", "iamo", "ete", "ono" ],
                 [ "hold", "evo", "evi", "eva", "evamo", "evate", "evano" ],
                 [ "hold", "erò", "erai", "erà", "eremo", "erete", "eranno" ],
                 [ "hold", "erei", "eresti", "erebbe", "eremmo", "ereste", "erebbero" ],
                 [ "hold", "ei", "esti", "ette", "emmo", "este", "ettero" ],
                 [ "hold", "a", "a", "a", "iamo", "iate", "ano" ],
                 [ "hold", "essi", "essi", "esse", "essimmo", "este", "essero" ]
               ],
      "ire" => [ [ "hold", "o", "i", "e", "iamo", "ite", "ono" ],
                 [ "hold", "ivo", "ivi", "iva", "ivamo", "ivate", "ivano" ],
                 [ "hold", "irò", "irai", "irà", "iremo", "irete", "iranno" ],
                 [ "hold", "irei", "iresti", "irebbe", "iremmo", "ireste", "irebbero" ],
                 [ "hold", "iì", "isti", "i", "immo", "iste", "irono" ],
                 [ "hold", "a", "a", "a", "iamo", "iate", "ano" ],
                 [ "hold", "issi", "issi", "isse", "issimmo", "iste", "issero" ]
               ]
};
# Will hold verbs read in
my @verbs;

# Input and output filenames
# Output file will be reference to allow for screen display 
my ($inputfile, $outputfile);

# Preset names of tenses
init_tenses;

# Process command line for arguments 
check_cl(\@ARGV);

# Read in verbs from file(s)
while (<$inputfile>) {
    chomp $_;
    if (/^(.+)([a|e|i]re)$/) {
        push @verbs, $_;
    }
}
print @verbs, "\n";

# Conjugate the verbs
for my $currverb (@verbs) {
    # Detect verb type and save root for conjugation
    # Already a valid verb form but this grabs the components required
    if ($currverb =~ /(.+)([a|e|i]re)/) {
        # Save verb type
        my $root = $1;
        my $type = $2;
        print $outputfile "PRINTING ", $type, " VERB ", $_, " WITH ROOT ", $root, "\n";
        #Start conjugating
        # Check to prevent autovivification of hash keys
        if (exists $main::endings->{$type}) {
            # Use array references within the array
            for my $tensearray ( @{ $main::endings->{$type} } ) {
                # Print the tense for reference
                print $outputfile "TENSE: ", $tensearray->[0], "\n";
                #Print the person/mode and combined verb
                for my $myindex (1 .. $#{ $tensearray }) {
                    #Print the person/mode, the combined verb
                    print $outputfile $main::desc->[$myindex-1],
                                      ":",
                                      $root,
                                      $tensearray->[$myindex],
                                      "\n"
                    ;
                }
            }
        }
    }
}


sub init_tenses {
    # For all verb forms
    for my $verbform (keys %{ $main::endings }) {
        # Need a single array reference to value
        my $arrref = $main::endings->{$verbform};
        # For the sub-arrays in each verbform array
        for my $index (0 .. scalar(@ { $main::tense })-1) {
            # Replace the first position of the sub-array with tense name 
            splice(@{ $arrref->[$index] },
                   0,
                   1,
                   $main::tense->[$index]->[0])
            ;
        }
    }
    
    # Present options of which tenses can be presented in the output file
    print "OPTIONS FOR EXTRACT\n\n";
    my $displayindex = 0;
    map { print "<", ++$displayindex, "> ", $_->[0], "\n" } @{$main::tense};
    # Print the prompt
    print "\n", "Enter your selections separated by spaces\n";
        
    # Read the response
    chomp( my $answer = <STDIN> ) ;
    
    # Process the answer
    # Put -1 check first to save "-" check in exclusion
    if ($answer =~ qr/-1/) {
        # -1 means all will be allowed
        # No other -1 value allowed even though array syntax allows it
        say "-1 found";
        for my $index (0 .. scalar(@ { $main::tense })-1) {
            # Set the value to "used"
            $main::tense->[$index]->[1] = 1;
        }
    }
    elsif ($answer =~ /[^\d ]/) {
        # Only digits and spaces allowed
        die "Invalid input data";
    }
    else {
        # Process each element in the returned list
        
        # Max value, determined once in case the method of detecting changes
        my $maxvalue = scalar(@ { $main::tense });
        
        # Return values as an array
        my @answers = map { split " " } $answer;
        print "RESPONSE: ", join(":", @answers);
        
        # Process the types based on input
        for (@answers) {
            die "Entry too large: $_" if ($_ > $maxvalue);
            # Set the value to "used"
            $main::tense->[$_-1]->[1] = 1;
        }
    }
    
    for my $temparrref (@{ $main::tense }) {
        for my $tempvalue (@{ $temparrref }) {
            print $tempvalue, "\n";
        }
    }
}

sub check_cl(+) {
    my $aref = shift;
    my $infound = 0;
    my $outfound = 0;
    my $myindex;
    my ($infilename, $outfilename);
    
    # Verify a passed array ref
    die "Not an array ref" unless ref($aref) eq "ARRAY";
    
    # Process command line
    $myindex = 0;
    while ($myindex <= scalar(@{ $aref })) {
       if ($aref->[$myindex] eq "-i") {
           # Read input filename,if any
           $infound = 1;
           $infilename = $aref->[++($myindex)];
       } elsif ($aref->[$myindex] eq "-o") {
           # Read output filename,if any
           $outfound = 1;
           $outfilename = $aref->[++($myindex)];
       }
       
       # Increment index regardless
       $myindex++;
    }
    
    # Open alternate input and output files
    if ($infound == 1) {
        open($inputfile, "<", $infilename) || die "Cannot open input file: $infilename";
    } else {
        $inputfile = \*STDIN;
    }
    
    if ($outfound == 1) {
        open($outputfile, ">", $outfilename) || die "Cannot open output file: $outfilename";
    } else {
        $outputfile = *STDOUT;
    }
}

