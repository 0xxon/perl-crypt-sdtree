#!perl 

use strict;
use warnings;
use 5.010;

use Test::More;  # tests => 9

BEGIN {
	use_ok('Crypt::Subset::Publish');
	use_ok('Crypt::Subset::Subscribe');
}

my $p = Crypt::Subset::Publish->new();
isa_ok($p, "Crypt::Subset::Publish");

