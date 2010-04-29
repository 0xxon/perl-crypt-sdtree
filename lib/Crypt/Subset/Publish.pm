package Crypt::Subset::Publish;

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
	NAME => 'Crypt::Subset::Publish',
	LIBS => '-lsdtree',
	INC => '';


# Preloaded methods go here.

1;

__DATA__

=pod

=cut

__C__

#include "sdtree.h"

typedef struct {
	void* object;
} Publisher;

SV* new(char * class) {
	Publisher* publisher;
	SV* obj_ref = newSViv(0);
	SV* obj = newSVrv(obj_ref, class);

	New(42, publisher, 1, Publisher);

	void* object = fpublish_create();
	publisher->object = object;

	sv_setiv(obj, publisher);
	SvREADONLY_on(obj);
	return obj_ref;
}

SV* newFromFile(char * class, char * filename) {
	Publisher* publisher;
	SV* obj_ref = newSViv(0);
	SV* obj = newSVrv(obj_ref, class);

	New(42, publisher, 1, Publisher);

	void* object = fpublish_create_from_file(filename);
	publisher->object = object;

	sv_setiv(obj, publisher);
	SvREADONLY_on(obj);
	return obj_ref;
}

void printEcInformation(SV* obj) {
	void* object = ((Publisher*)SvIV(SvRV(obj)))->object;
	fpublish_printEcInformation(object);
}

void generateCover(SV* obj) {
	void* object = ((Publisher*)SvIV(SvRV(obj)))->object;
	fpublish_generateCover(object);
}

void printSDKeyList(SV* obj) {
	void* object = ((Publisher*)SvIV(SvRV(obj)))->object;
	fpublish_printSDKeyList(object);
}

//void setTreeSecret();

void DESTROY(SV* obj) {
	Publisher* publisher = ((Publisher*)SvIV(SvRV(obj)));
	fpublish_free(publisher->object);
	Safefree(publisher);
}

