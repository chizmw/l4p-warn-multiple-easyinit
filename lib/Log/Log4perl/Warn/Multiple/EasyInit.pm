package Log::Log4perl::Warn::Multiple::EasyInit;
# ABSTRACT: trap multiple calls to Log::Log4perl::easy_init
use strict;
use warnings;

use Carp;
use Log::Log4perl;

our ($package, $filename, $line);

sub set_trap {
    my $code = \&Log::Log4perl::easy_init;
    no warnings 'redefine';
    *Log::Log4perl::easy_init = sub {
        if(Log::Log4perl->initialized) {
            carp( "Log::Log4perl already initialised with easy_init() [at $filename, line $line]" );
        }
        else {
            # store our first initialisation
            ($package, $filename, $line) = caller;
        }
        # run the original function
        &$code($@);
    };
}

BEGIN {
    set_trap;
}

1;
__END__

=pod

=head1 SYNOPSIS

  BEGIN {
    use Log::Log4perl::Warn::Multiple::EasyInit;
  }

=cut
