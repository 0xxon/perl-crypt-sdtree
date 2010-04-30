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

$p->revokeUser("10000000000000000000000000000000");
my $pbase = $p->getServerData;

#$p->generateKeylist("10000000000000000000000000000000");
$p->generateKeylist("00000000000000000000000000000001");
my $cbase = $p->getClientData;

