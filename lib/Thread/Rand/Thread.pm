package Thread::Rand::Thread;

# Make sure we do everything by the book from now on

our $VERSION : unique = '0.01';
use strict;

# Satisfy -require-

1;

#---------------------------------------------------------------------------

# standard Perl features

#---------------------------------------------------------------------------
#  IN: 1 class for which to bless
# OUT: 1 instantiated object

sub TIESCALAR { bless \*TIESCALAR,shift } #TIESCALAR

#---------------------------------------------------------------------------
#  IN: 1 instantiated object (ignored)
# OUT: 1 value

sub FETCH { rand() } #FETCH

#---------------------------------------------------------------------------
#  IN: 1 instantiated object (ignored)
#      2 new srand value

sub STORE { srand( $_[1] ) } #STORE

#---------------------------------------------------------------------------

__END__

=head1 NAME

Thread::Rand::Thread - helper class for Thread::Rand

=head1 DESCRIPTION

Helper class for L<Thread::Rand>.  See documentation there.

=head1 AUTHOR

Elizabeth Mattijsen, <liz@dijkmat.nl>.

Please report bugs to <perlbugs@dijkmat.nl>.

=head1 COPYRIGHT

Copyright (c) 2002 Elizabeth Mattijsen <liz@dijkmat.nl>. All rights
reserved.  This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Thread::Rand>.

=cut
