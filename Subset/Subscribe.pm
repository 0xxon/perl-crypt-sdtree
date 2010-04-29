package Crypt::Subset::Subscribe;

use 5.010000;
use strict;
use warnings;

use Crypt::Subset qw(:subscribe);

sub new {
	subscribe_new(@_);
}

sub DESTROY {
	subscribe_DESTROY(@_);
}

1;