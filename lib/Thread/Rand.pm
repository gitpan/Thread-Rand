package Thread::Rand;

# Start the Thread::Tie thread now if not already started (as clean as possible)

use Thread::Tie ();

# Make sure we have version info for this module
# Make sure we do everything by the book from now on

$VERSION = '0.04';
use strict;

# Make sure we only load stuff when we actually need it

use load;

# Make sure we have something tied to the thread

tie my $RAND,'Thread::Tie',{module => 'Thread::Rand::Thread'};

# Satisfy -require-

1;

#---------------------------------------------------------------------------

# exportable subroutines

#---------------------------------------------------------------------------
#  IN: 1 range for random value (default: 0..1)
# OUT: 1 random value

sub rand {

# Obtain random value between 0 and 1
# Return now if no range
# Adapt to range if appropriate and return that

    my $rand = $RAND;
    return $rand unless defined($_[0]);
    $rand * (shift || 1);
} #rand

#---------------------------------------------------------------------------
#  IN: 1 new value for seed

sub srand { $RAND = shift } #srand

#---------------------------------------------------------------------------

# The following subroutines are loaded on demand only

__END__

#---------------------------------------------------------------------------

# class methods

#---------------------------------------------------------------------------

sub global {

# Allow for dirty tricks
# Hijack rand()
# Hijack srand()

    no strict 'refs';
    *CORE::GLOBAL::rand  = \&rand;
    *CORE::GLOBAL::srand = \&srand;
} #global

#---------------------------------------------------------------------------

# standard Perl features

#---------------------------------------------------------------------------
#  IN: class (ignored)

sub import {

# Lose the class
# Obtain the namespace
# Obtain the names of the subroutines to export
# Allow for dirty tricks
# Export all subroutines specified

    shift;
    my $namespace = caller().'::';
    @_ = qw(rand seed) unless @_;
    no strict 'refs';
    *{$namespace.$_} = \&$_ foreach @_;
} #import

#---------------------------------------------------------------------------

__END__

=head1 NAME

Thread::Rand - repeatable random sequences between threads

=head1 SYNOPSIS

  use Thread::Rand;             # exports rand() and srand()

  use Thread::Rand ();          # must call fully qualified subs

  BEGIN {Thread::Rand->global}  # replace rand() and srand() globally

=head1 DESCRIPTION

                  *** A note of CAUTION ***

 This module only functions on Perl versions 5.8.0 and later.
 And then only when threads are enabled with -Dusethreads.  It
 is of no use with any version of Perl before 5.8.0 or without
 threads enabled.

                  *************************

The Thread::Rand module allows you to create repeatable random sequences
between different threads.  Without it, repeatable random sequences can
only be created B<within> a thread.

=head1 SUBROUTINES

There are only two subroutines.

=head2 rand

 my $value = rand();          # a value between 0 and 1

 my $value = rand( number );  # a value between 0 and number-1 inclusive

The "rand" subroutine functions exactly the same as the normal rand() function.

=head2 srand

 srand( usethis );

The "srand" subroutine functions exactly the same as the normal srand()
function.

=head1 CLASS METHODS

There is one class method.

=head2 global

 use Thread::Rand ();
 BEGIN {Thread::Rand->global}

The "global" class method allows you to replace the rand() and srand() system
functions in all programs by the version supplied by Thread::Rand.  To ensure
that the right subroutines are called, you B<must> call this class method from
within a BEGIN {} block.

=head1 CAVEATS

A bug in Perl 5.8.0 causes random sequences to be identical in threads if the
rand() function was called in the parent thread.  You can circumvent this
problem by adding a CLONE subroutine thus:

 sub CLONE { srand() } # needed for bug in 5.8.0

This will make sure that each thread gets its own unique seed and therefore
its own unique sequence of random numbers.  Alternately, you could also solve
this with Thread::Rand and a call to the L<global> class method thus:

 use Thread::Rand ();
 BEGIN {Thread::Rand->global}

You should however keep monitoring whether future versions of Perl will have
this problem fixed.  You can then take these circumventions out again.

=head1 AUTHOR

Elizabeth Mattijsen, <liz@dijkmat.nl>.

Please report bugs to <perlbugs@dijkmat.nl>.

=head1 COPYRIGHT

Copyright (c) 2002 Elizabeth Mattijsen <liz@dijkmat.nl>. All rights
reserved.  This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Thread::Tie>.

=cut
