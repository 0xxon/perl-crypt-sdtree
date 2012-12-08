package Crypt::SDTree::Publish;

use 5.010000;
use strict;
use warnings;

use Crypt::SDTree qw(:publish);

our $VERSION = '0.01';

sub new {
	publish_new(@_);
}

sub DESTROY {
	publish_DESTROY(@_);
}

1;
