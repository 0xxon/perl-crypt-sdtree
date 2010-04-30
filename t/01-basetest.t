#!perl 

use strict;
use warnings;
use 5.010;

use Test::More;  # tests => 9

sub burp {
    my( $file_name ) = shift ;
    open( my $fh, ">$file_name" ) ||
        die "can't create $file_name $!" ;
    print $fh @_ ;
}

BEGIN {
	use_ok('Crypt::Subset::Publish');
	use_ok('Crypt::Subset::Subscribe');
}

my $p = Crypt::Subset::Publish->new();
isa_ok($p, "Crypt::Subset::Publish");

$p->revokeUser("10000000000000000000000000000000");
my $pbase = $p->getServerData;
burp("pt2", $pbase);

#$p->generateKeylist("10000000000000000000000000000000");
$p->generateKeylist("00000000000000000000000000000001");
my $cbase = $p->getClientData;
$p->writeClientData("ctestdata");
burp("ct2", $cbase);

say "lala \n $cbase \n";
say "Length: ".length $cbase;

my $subscriber2 = Crypt::Subset::Subscribe->new("ctestdata");
my $subscriber = Crypt::Subset::Subscribe->newFromClientData($cbase);
isa_ok($subscriber, 'Crypt::Subset::Subscribe');

