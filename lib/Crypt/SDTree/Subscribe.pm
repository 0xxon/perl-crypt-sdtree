package Crypt::SDTree::Subscribe;

use 5.010000;
use strict;
use warnings;

use Crypt::SDTree qw(:subscribe);

our $VERSION = '0.01';

sub new {
	subscribe_new(@_);
}

sub DESTROY {
	subscribe_DESTROY(@_);
}

1;
