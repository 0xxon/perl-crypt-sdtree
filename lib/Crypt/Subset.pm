package Crypt::Subset;

use 5.010000;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Crypt::Subset ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';


use Inline C => 'DATA',
#	VERSION => '0.01',
	NAME => 'Crypt::Subset',
	LIBS => '-L /home/ba/igorfs/src/sdtree -lsdtree';


# Preloaded methods go here.

1;

__DATA__

=pod

=cut

__C__


