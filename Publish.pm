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
	VERSION => '0.01',
	NAME => 'Crypt::Subset::Publish',
	LIBS => '-lsdtree';
	
sub revokeUser {
	my ($self, $path, $depth) = @_;
	die("Wrong depth") if ($depth >= 32);
	die("Wrong key data") unless $path =~ m#^\d{32}$#;
	DoRevokeUser(@_);
	
}

sub generateKeylist {
	my ($self, $path) = @_;
	die("Wrong key data") unless $path =~ m#^\d{32}$#;
	DoGenerateKeylist(@_);
}


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

void setTreeSecret(SV* obj, SV* secret) {
	void* object = ((Publisher*)SvIV(SvRV(obj)))->object;
	
	/* get string length */
	STRLEN length;
	char* data = SvPV(secret, length);
	
	fpublish_setTreeSecret(object, data, length);
}

void DoRevokeUser(SV* obj, char * dpath, int depth) {
	void* object = ((Publisher*)SvIV(SvRV(obj)))->object;
	tDPath p = StringToDoublePath(dpath);
	p |= 0x1LL << ((2* ( 32 - depth) )-1);
	fpublish_revokeuser(obj, p);
}

void DoGenerateKeylist(SV* obj, char * path) {
	void* object = ((Publisher*)SvIV(SvRV(obj)))->object;
	tPath p = StringToPath(path);
	fpublish_generateKeylist(obj, p);
}

void writeClientData(SV* obj, char * filename) {
	void* object = ((Publisher*)SvIV(SvRV(obj)))->object;
	fpublish_writeClientData(object, filename);
}

void writeServerData(SV* obj, char * filename) {
	void* object = ((Publisher*)SvIV(SvRV(obj)))->object;
	fpublish_writeServerData(object, filename);
}

void DESTROY(SV* obj) {
	Publisher* publisher = ((Publisher*)SvIV(SvRV(obj)));
	fpublish_free(publisher->object);
	Safefree(publisher);
}

