BEGIN {				# Magic Perl CORE pragma
    if ($ENV{PERL_CORE}) {
        chdir 't' if -d 't';
        @INC = '../lib';
    }
}

use Test::More tests => 11;
use strict;

BEGIN {use_ok( 'Thread::Rand',qw(rand srand) )}

can_ok( 'Thread::Rand',qw(
 import
 rand
 srand
) );

my $times = 10000;
my $srand = 12345678;
my @local;
my @shared : shared;

my $random = int(rand($times));
ok( $random>=0 and $random<$times,	'check range of number' );

$random = rand();
ok( $random>=0 and $random<1,		'check range of number' );

$random = rand(0);
ok( $random>=0 and $random<1,		'check range of number' );

$random = rand(undef);
ok( $random>=0 and $random<1,		'check range of number' );

CORE::srand( $srand );
push( @local,CORE::rand() ) foreach 1..$times;
cmp_ok( scalar(@local),'==',$times,	'check length of array' );

srand( $srand );
push( @shared,rand() ) foreach 1..$times;
cmp_ok( scalar(@shared),'==',$times,	'check length of array' );
is( join('',@shared),join('',@local),	'compare result same thread' );

srand( $srand );
@shared = ();
my $done : shared = 0;
my @thread;
push( @thread, threads->new( sub {
  AGAIN: while (1) {
    {
     lock( $done );
     last AGAIN if $done == $times;
     $done++;
     push( @shared,rand() );
    } #$done
  }
} ) ) foreach 1..10;
$_->join foreach @thread;

cmp_ok( scalar(@shared),'==',$times,	'check length of array' );
is( join('',@shared),join('',@local),	'compare result different threads' );
