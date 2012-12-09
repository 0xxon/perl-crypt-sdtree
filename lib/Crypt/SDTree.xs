#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "sdtree.h"

typedef struct {
	void* object;
} Publisher;

SV* publish_new(char * classname) {
	Publisher* publisher;
	SV* obj_ref = newSViv(0);
	SV* obj = newSVrv(obj_ref, classname);

	Newx(publisher, 1, Publisher);

	void* object = fpublish_create();
	publisher->object = object;

	sv_setiv(obj, PTR2IV(publisher));
	SvREADONLY_on(obj);
	return obj_ref;
}

SV* newFromFile(char * classname, char * filename) {
	Publisher* publisher;
	SV* obj_ref = newSViv(0);
	SV* obj = newSVrv(obj_ref, classname);

	Newx(publisher, 1, Publisher);

	void* object = fpublish_create_from_file(filename);
	publisher->object = object;

	sv_setiv(obj, PTR2IV(publisher));
	SvREADONLY_on(obj);
	return obj_ref;
}

SV* newFromData(char * classname, SV* data) {
	Publisher* publisher;
	SV* obj_ref = newSViv(0);
	SV* obj = newSVrv(obj_ref, classname);

	New(42, publisher, 1, Publisher);

	/* get string length */
	STRLEN length;
	char* s = SvPV(data, length);
	
	void* object = fpublish_create_from_data(s, length);
	publisher->object = object;

	sv_setiv(obj, PTR2IV(publisher));
	SvREADONLY_on(obj);
	return obj_ref;
}

void printEcInformation(SV* obj) {
	void* object = (INT2PTR(Publisher*, SvIV(SvRV(obj))))->object;
	fpublish_printEcInformation(object);
}

void clearRevokedUsers(SV* obj) {
	void* object = (INT2PTR(Publisher*, SvIV(SvRV(obj))))->object;
	fpublish_clearRevokedUsers(object);
}

void generateCover(SV* obj) {
	void* object = (INT2PTR(Publisher*, SvIV(SvRV(obj))))->object;
	fpublish_generateCover(object);
}

void setRevokelistInverted(SV* obj, unsigned int inverted) {
	void* object = (INT2PTR(Publisher*, SvIV(SvRV(obj))))->object;
	fpublish_setRevokelistInverted(object, inverted);
}

unsigned int getRevokelistInverted(SV* obj) {
	void* object = (INT2PTR(Publisher*, SvIV(SvRV(obj))))->object;
	unsigned int inverted = fpublish_getRevokelistInverted(object);

	return inverted;
}


void printSDKeyList(SV* obj) {
	void* object = (INT2PTR(Publisher*, SvIV(SvRV(obj))))->object;
	fpublish_printSDKeyList(object);
}

void setTreeSecret(SV* obj, SV* secret) {
	void* object = (INT2PTR(Publisher*, SvIV(SvRV(obj))))->object;
	
	/* get string length */
	STRLEN length;
	char* data = SvPV(secret, length);
	
	fpublish_setTreeSecret(object, data, length);
}

void DoRevokeUser(SV* obj, char * dpath, int depth) {
	void* object = (INT2PTR(Publisher*, SvIV(SvRV(obj))))->object;
	tDPath p = StringToDoublePath(dpath);
	if ( depth < 32 ) 
		p |= 0x1LL << ((2* ( 32 - depth) )-1);
	fpublish_revokeuser(object, p);
}

void DoGenerateKeylist(SV* obj, char * path) {
	void* object = (INT2PTR(Publisher*, SvIV(SvRV(obj))))->object;
	tPath p = StringToPath(path);
	fpublish_generateKeylist(object, p);
}

void writeClientData(SV* obj, char * filename) {
	void* object = (INT2PTR(Publisher*, SvIV(SvRV(obj))))->object;
	fpublish_writeClientData(object, filename);
}

void writeServerData(SV* obj, char * filename) {
	void* object = (INT2PTR(Publisher*, SvIV(SvRV(obj))))->object;
	fpublish_writeServerData(object, filename);
}

SV* getClientData(SV* obj) {
	void* object = (INT2PTR(Publisher*, SvIV(SvRV(obj))))->object;
	fString reply = fpublish_getClientData(object);
	SV* perlreply = newSVpv(reply.data, reply.length);
	free(reply.data);
	
	return perlreply;
}

SV* getServerData(SV* obj) {
	void* object = (INT2PTR(Publisher*, SvIV(SvRV(obj))))->object;
	fString reply = fpublish_getServerData(object);
	SV* perlreply = newSVpvn(reply.data, reply.length);
	free(reply.data);	

	return perlreply;
}

void publish_DESTROY(SV* obj) {
	Publisher* publisher = (INT2PTR(Publisher*,SvIV(SvRV(obj))));
	fpublish_free(publisher->object);
	Safefree(publisher);
}

SV* generateSDTreeBlock(SV* obj, SV* message) {
	void* object = (INT2PTR(Publisher*, SvIV(SvRV(obj))))->object;
	
	/* get string length */
	STRLEN length;
	char* data = SvPV(message, length);
	
	fString reply = fpublish_generateSDTreeBlock(object, data, length);
	SV* perlreply = newSVpvn(reply.data, reply.length);
	free(reply.data);	

	return perlreply;
}

SV* generateAESEncryptedBlock(SV* obj, SV* message) {
	void* object = (INT2PTR(Publisher*, SvIV(SvRV(obj))))->object;
	
	/* get string length */
	STRLEN length;
	char* data = SvPV(message, length);
	
	fString reply = fpublish_generateAESEncryptedBlock(object, data, length);
	SV* perlreply = newSVpvn(reply.data, reply.length);
	free(reply.data);	

	return perlreply;
}

typedef struct {
	void* object;
} Subscriber;

SV* subscribe_new(char * classname, char * filename) {
	Subscriber* subscriber;
	SV* obj_ref = newSViv(0);
	SV* obj = newSVrv(obj_ref, classname);

	New(42, subscriber, 1, Subscriber);

	void* object = fclient_create(filename);
	subscriber->object = object;

	sv_setiv(obj, PTR2IV(subscriber));
	SvREADONLY_on(obj);
	return obj_ref;
}

SV* newFromClientData(char* classname, SV* data) {
	Subscriber* subscriber;
	SV* obj_ref = newSViv(0);
	SV* obj = newSVrv(obj_ref, classname);

	New(42, subscriber, 1, Subscriber);

	STRLEN length;
	char* s = SvPV(data, length);
	
	void* object = fclient_create_from_data(s, length);
	subscriber->object = object;

	sv_setiv(obj, PTR2IV(subscriber));
	SvREADONLY_on(obj);
	return obj_ref;
}

SV* decrypt(SV* obj, SV* message) {
	void* object = (INT2PTR(Subscriber*, SvIV(SvRV(obj))))->object;
	
	/* get string length */
	STRLEN length;
	char* data = SvPV(message, length);
	
	fString reply = fclient_decrypt((char*) object, data, length);
	SV* perlreply = newSVpvn(reply.data, reply.length);
	free(reply.data);	

	return perlreply;
}

void subscribe_DESTROY(SV* obj) {
	Subscriber* subscriber = (INT2PTR(Subscriber*,SvIV(SvRV(obj))));
	fclient_free((char*) subscriber->object);
	Safefree(subscriber);
}


MODULE = Crypt::SDTree	PACKAGE = Crypt::SDTree	

PROTOTYPES: DISABLE


SV *
publish_new (classname)
	char *	classname

SV *
newFromFile (classname, filename)
	char *	classname
	char *	filename

SV *
newFromData (classname, data)
	char *	classname
	SV *	data

void
printEcInformation (obj)
	SV *	obj
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	printEcInformation(obj);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
clearRevokedUsers (obj)
	SV *	obj
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	clearRevokedUsers(obj);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
generateCover (obj)
	SV *	obj
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	generateCover(obj);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
setRevokelistInverted (obj, inverted)
	SV *	obj
	unsigned int	inverted
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	setRevokelistInverted(obj, inverted);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

unsigned int
getRevokelistInverted (obj)
	SV *	obj

void
printSDKeyList (obj)
	SV *	obj
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	printSDKeyList(obj);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
setTreeSecret (obj, secret)
	SV *	obj
	SV *	secret
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	setTreeSecret(obj, secret);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
DoRevokeUser (obj, dpath, depth)
	SV *	obj
	char *	dpath
	int	depth
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	DoRevokeUser(obj, dpath, depth);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
DoGenerateKeylist (obj, path)
	SV *	obj
	char *	path
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	DoGenerateKeylist(obj, path);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
writeClientData (obj, filename)
	SV *	obj
	char *	filename
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	writeClientData(obj, filename);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
writeServerData (obj, filename)
	SV *	obj
	char *	filename
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	writeServerData(obj, filename);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
getClientData (obj)
	SV *	obj

SV *
getServerData (obj)
	SV *	obj

void
publish_DESTROY (obj)
	SV *	obj
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	publish_DESTROY(obj);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
generateSDTreeBlock (obj, message)
	SV *	obj
	SV *	message

SV *
generateAESEncryptedBlock (obj, message)
	SV *	obj
	SV *	message

SV *
subscribe_new (classname, filename)
	char *	classname
	char *	filename

SV *
newFromClientData (classname, data)
	char *	classname
	SV *	data

SV *
decrypt (obj, message)
	SV *	obj
	SV *	message

void
subscribe_DESTROY (obj)
	SV *	obj
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	subscribe_DESTROY(obj);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

