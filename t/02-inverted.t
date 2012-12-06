#!perl 

use strict;
use warnings;
use 5.010;

use Test::More tests => 16;

BEGIN {
	use_ok('Crypt::Subset::Publish');
	use_ok('Crypt::Subset::Subscribe');
}

my $p = Crypt::Subset::Publish->new();
isa_ok($p, "Crypt::Subset::Publish");

my $testdata = "Encrypt this, decrypt it, lalalalala";

$p->revokeUser("10000000000000000000000000000000");
$p->revokeUser("00000000000000000000000000000001");
is ( $p->getRevokelistInverted, 0, "Revokelist not inverted yet");
$p->setRevokelistInverted(1);
is ( $p->getRevokelistInverted, 1, "Revokelist not inverted");
my $pbase = $p->getServerData;

my $sender1 = Crypt::Subset::Publish->newFromData($pbase);
isa_ok($sender1, "Crypt::Subset::Publish");

$sender1->generateCover;
my $block1 = $sender1->generateSDTreeBlock($testdata);
isnt($block1, undef, "Not undef");

$p->generateKeylist("00000000000000000000000000000001");
my $cbase = $p->getClientData;
isnt($cbase, undef, "Not undef");
$p->generateKeylist("00000010000000000000000000000001");
my $cbase2 = $p->getClientData;
isnt($cbase2, undef, "Not undef");
$p->generateKeylist("10000000000000000000000000000001");
my $cbase3 = $p->getClientData;
isnt($cbase3, undef, "Not undef");

my $subscriber = Crypt::Subset::Subscribe->newFromClientData($cbase);
isa_ok($subscriber, 'Crypt::Subset::Subscribe');
my $subscriber2 = Crypt::Subset::Subscribe->newFromClientData($cbase2);
isa_ok($subscriber2, 'Crypt::Subset::Subscribe');
my $subscriber3 = Crypt::Subset::Subscribe->newFromClientData($cbase3);
isa_ok($subscriber3, 'Crypt::Subset::Subscribe');

my $decrypted = $subscriber->decrypt($block1);
is($decrypted, $testdata, "Decrypted = origdata");

my $decrypted2 = $subscriber2->decrypt($block1);
ok(!defined($decrypted2), "Cannot decrypt");

my $decrypted3 = $subscriber3->decrypt($block1);
is($decrypted3, $testdata, "Decrypted = origdata");


