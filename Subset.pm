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
our %EXPORT_TAGS = ( 'publish' => [ qw(
	publish_new newFromFile printEcInformation generateCover printSDKeyList 
	setTreeSecret revokeUser DoRevokeUser generateKeylist DoGenerateKeylist 
	writeClientData writeServerData publish_DESTROY generateSDTreeBlock
	generateAESEncryptedBlock newFromData getClientData getServerData
) ],
	'subscribe' => [ qw( 
	subscribe_new decrypt subscribe_DESTROY newFromClientData
	printEcInformation printSDKeyList
	)] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'publish'} }, @{ $EXPORT_TAGS{'subscribe'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';


use Inline C => 'DATA',
	VERSION => '0.01',
	NAME => 'Crypt::Subset',
	LIBS => '-lsdtree';
	
sub revokeUser {
	my ($self, $path, $depth) = @_;
	$depth //= 32;
	die("Wrong depth") if ($depth > 32);
        die("Wrong depth too small") if ($depth < 1);
	die("Wrong key data") unless $path =~ m#^\d{32}$#;
	DoRevokeUser($self, $path, $depth);
	
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

SV* publish_new(char * class) {
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

SV* newFromData(char * class, SV* data) {
	Publisher* publisher;
	SV* obj_ref = newSViv(0);
	SV* obj = newSVrv(obj_ref, class);

	New(42, publisher, 1, Publisher);

	/* get string length */
	STRLEN length;
	char* s = SvPV(data, length);
	
	void* object = fpublish_create_from_data(s, length);
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
	if ( depth < 32 ) 
		p |= 0x1LL << ((2* ( 32 - depth) )-1);
	fpublish_revokeuser(object, p);
}

void DoGenerateKeylist(SV* obj, char * path) {
	void* object = ((Publisher*)SvIV(SvRV(obj)))->object;
	printf("Generating for %s\n", path);
	tPath p = StringToPath(path);
	fpublish_generateKeylist(object, p);
}

void writeClientData(SV* obj, char * filename) {
	void* object = ((Publisher*)SvIV(SvRV(obj)))->object;
	fpublish_writeClientData(object, filename);
}

void writeServerData(SV* obj, char * filename) {
	void* object = ((Publisher*)SvIV(SvRV(obj)))->object;
	fpublish_writeServerData(object, filename);
}

SV* getClientData(SV* obj) {
	void* object = ((Publisher*)SvIV(SvRV(obj)))->object;
	fString reply = fpublish_getClientData(object);
	reply.data[1]=128;
	printf("Got client data with length %d, advertised as length %d\n", reply.length, strlen(reply.data));
	SV* perlreply = newSVpv(reply.data, reply.length);
	
	return perlreply;
}

SV* getServerData(SV* obj) {
	void* object = ((Publisher*)SvIV(SvRV(obj)))->object;
	fString reply = fpublish_getServerData(object);
	SV* perlreply = newSVpvn(reply.data, reply.length);
	
	return perlreply;
}

void publish_DESTROY(SV* obj) {
	Publisher* publisher = ((Publisher*)SvIV(SvRV(obj)));
	fpublish_free(publisher->object);
	Safefree(publisher);
}

SV* generateSDTreeBlock(SV* obj, SV* message) {
	void* object = ((Publisher*)SvIV(SvRV(obj)))->object;
	
	/* get string length */
	STRLEN length;
	char* data = SvPV(message, length);
	
	fString reply = fpublish_generateSDTreeBlock(object, data, length);
	SV* perlreply = newSVpvn(reply.data, reply.length);
	
	return perlreply;
}

SV* generateAESEncryptedBlock(SV* obj, SV* message) {
	void* object = ((Publisher*)SvIV(SvRV(obj)))->object;
	
	/* get string length */
	STRLEN length;
	char* data = SvPV(message, length);
	
	fString reply = fpublish_generateAESEncryptedBlock(object, data, length);
	SV* perlreply = newSVpvn(reply.data, reply.length);
	
	return perlreply;
}

typedef struct {
	void* object;
} Subscriber;

SV* subscribe_new(char * class, char * filename) {
	Subscriber* subscriber;
	SV* obj_ref = newSViv(0);
	SV* obj = newSVrv(obj_ref, class);

	New(42, subscriber, 1, Subscriber);

	void* object = fclient_create(filename);
	subscriber->object = object;

	sv_setiv(obj, subscriber);
	SvREADONLY_on(obj);
	return obj_ref;
}

SV* newFromClientData(char* class, SV* data) {
	Subscriber* subscriber;
	SV* obj_ref = newSViv(0);
	SV* obj = newSVrv(obj_ref, class);

	New(42, subscriber, 1, Subscriber);

	STRLEN length;
	char* s = SvPV(data, length);
	printf("Data length: %d\n", length);
	
	void* object = fclient_create_from_data(s, length);
	subscriber->object = object;

	sv_setiv(obj, subscriber);
	SvREADONLY_on(obj);
	return obj_ref;
}

SV* decrypt(SV* obj, SV* message) {
	void* object = ((Subscriber*)SvIV(SvRV(obj)))->object;
	
	/* get string length */
	STRLEN length;
	char* data = SvPV(message, length);
	
	fString reply = fclient_decrypt(object, data, length);
	SV* perlreply = newSVpvn(reply.data, reply.length);
	
	return perlreply;
}

void subscribe_DESTROY(SV* obj) {
	Subscriber* subscriber = ((Subscriber*)SvIV(SvRV(obj)));
	fclient_free(subscriber->object);
	printf("Destroying client \n");
	Safefree(subscriber);
}


