package Crypt::Subset::Publish;

use 5.010000;
use strict;
use warnings;


use Crypt::Subset qw(:publish);

our $VERSION = $Crypt::Subset::VERSION;

sub new {
	publish_new(@_);
}

sub DESTROY {
	publish_DESTROY(@_);
}

1;
