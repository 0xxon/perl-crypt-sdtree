#!perl 

use strict;
use warnings;
use 5.010;

use Test::More tests => 10;

BEGIN {
	use_ok('Crypt::SDTree::Publish');
	use_ok('Crypt::SDTree::Subscribe');
}

my $p = Crypt::SDTree::Publish->new();
isa_ok($p, "Crypt::SDTree::Publish");

my $testdata = "Encrypt this, decrypt it, lalalalala";

# create two pbases...
$p->revokeUser("10000000000000000000000000000000");
my $pbase = $p->getServerData;
$p->revokeUser("00000000000000000000000000000001");
my $pbase2 = $p->getServerData;

my $sender1 = Crypt::SDTree::Publish->newFromData($pbase);
isa_ok($sender1, "Crypt::SDTree::Publish");
my $sender2 = Crypt::SDTree::Publish->newFromData($pbase2);
isa_ok($sender2, "Crypt::SDTree::Publish");

$sender1->generateCover;
$sender2->generateCover;
my $block1 = $sender1->generateSDTreeBlock($testdata);
my $block2 = $sender2->generateSDTreeBlock($testdata);
isnt($block1, undef, "Not undef");
isnt($block2, undef, "Not undef");


$p->generateKeylist("00000000000000000000000000000001");
my $cbase = $p->getClientData;

my $subscriber = Crypt::SDTree::Subscribe->newFromClientData($cbase);
isa_ok($subscriber, 'Crypt::SDTree::Subscribe');

my $decrypted = $subscriber->decrypt($block1);
is($decrypted, $testdata, "Decrypted = origdata");

my $decrypted2 = $subscriber->decrypt($block2);
ok(!defined($decrypted2), "Cannot decrypt");

