
package VerbTenseDescription;
use Carp;

my @tenses  = ( "present",
                "imperfect",
                "future",
                "pr cond",
                "past hist",
                "pr subj",
                "imp subj"
              );

sub TIEARRAY {
    my $class = shift;
    return bless { MAX_INDEX => $#tenses,
                   DATA => [ @tenses ]
                 }, $class;
}

sub FETCH {
    my ($self, $index) = @_;
    if ($index > $self->{MAX_INDEX}) {
        confess "Array OOB: $index > $self->{MAX_INDEX}";
    }
    return $self->{DATA}[$index];
}

sub STORE {
    confess "Function STORE not implemented";
    return 0;
}

sub FETCHSIZE {
    my $self = shift;
    return scalar @{$self->{DATA}};
}

sub STORESIZE {
    confess "Function STORESIZE not implemented";
    return 0;
}

sub EXISTS {
    my ($self, $index) = @_;
    if ($index > $self->{MAX_INDEX}) {
        confess "Array OOB: $index > $self->{MAX_INDEX}";
    }
    exists $self->{DATA}[$index];
}

sub DELETE {
    confess "Function DELETE not implemented";
    return 0;
}

sub CLEAR {
    confess "Function CLEAR not implemented";
    return 0;
}

sub PUSH {
    confess "Function PUSH not implemented";
    return 0;
}

sub POP {
    confess "Function POP not implemented";
    return 0;
}

1;