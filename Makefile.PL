require 5.008;
use threads (); # just to force breakage if threads are not available
use ExtUtils::MakeMaker;

WriteMakefile (
 NAME		=> "Thread::Rand",
 ($[ >= 5.005) ?
 (AUTHOR	=> 'Elizabeth Mattijsen (liz@dijkmat.nl)',
  ABSTRACT	=> 'repeatable random sequences between threads') : (),
 VERSION_FROM	=> 'lib/Thread/Rand.pm',
 PREREQ_PM	=> {
		   Thread::Tie => '0.07',
                   },
);
