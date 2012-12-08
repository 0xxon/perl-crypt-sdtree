package Crypt::SDTree;

use 5.010000;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
our $VERSION = 0.01;

BOOT_XS: {
  require DynaLoader;

  # DynaLoader calls dl_load_flags as a static method.
  *dl_load_flags = DynaLoader->can('dl_load_flags');

  do {__PACKAGE__->can('bootstrap') || \&DynaLoader::bootstrap}->(__PACKAGE__, $VERSION);
}

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
	setRevokelistInverted getRevokelistInverted clearRevokedUsers
) ],
	'subscribe' => [ qw( 
	subscribe_new decrypt subscribe_DESTROY newFromClientData
	printEcInformation printSDKeyList
	)] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'publish'} }, @{ $EXPORT_TAGS{'subscribe'} } );

our @EXPORT = qw(
	
);

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

=head1 NAME

Crypt::SDTree - Subset Difference Encryption/Revocation Scheme 

=head1 ABSTRACT

Implementation of a broadcast encryption/revocation scheme

=head1 DESCRIPTION

This library implements a broadcast encryption and revocation scheme.
The basic scheme that is implemented here was proposed by Naor et al.
in the paper "Revocation and Tracing Schemes for Stateless Receivers".

To be more detailed, this module allows encryption of a message to a
group of users, where a subset of this group is considered to be revoked.
All non-revoked users will be able to decrypt the message, while the 
revoked users will not. The receivers are stateless and do not have to 
update any state from session to session. 

The functionality is split into two sub-packages. To encrypt or send data, 
please refer to L<Crypt::SDTree::Publish>. To decrypt or receive data,
please refer to L<Crypt::SDTree::Subscribe>.

Please note that this module has not been reviewed by anyone other than
myself. I am not sure that it actually is secure - while the theoretical
basis should be sound it might leak key material or have other implementation
defects.

Hence, please consult a cryptographer before using this for anything that
is actually important. 

=head1 AUTHOR

Johanna Amann, E<lt>johanna@icir.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010-2012 by Johanna Amann

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA


=cut

1;
