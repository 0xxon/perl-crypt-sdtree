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

=head1 NAME

Crypt::SDTree::Publish - Create Broadcast Messages

=head1 SYNOPSIS

  use 5.10.1;

  use Crypt::SDTree::Publish;

  # create a new publisher with all key maerial
  my $publisher = Crypt::SDTree::Publish->new();

  # Generate client keys
  $p->generateKeylist("00000000000000000000000000000001");
  $p->writeClientData('clientkeys');
  
  # revoke a user
  $publisher->revokeUser("10000000000000000000000000000000");

  # save publisher keys and list of revoked users
  $publisher->writeServerData('serverkeys');

  # encrypt message
  my $data = 'testmessage';
  $publisher->generateCover;
  my $encrypted = $publisher->generateSDTreeBlock($data);

=head1 ABSTRACT

Perl interface for the encryption of broadcast messages and user-management.

=head1 DESCRIPTION

This package allows the encryption of broadcast messages, creation
of broadcaster and subscriber keys as well as the encryption of messages.
Messages can be decrypted using <Crypt::SDTree::Subscribe>. 

Individual clients are identified by a path in a 32-bit binary tree, which
is represented as a bitstring.

Please note that this module has not been reviewed by anyone other than
myself. I am not sure that it actually is secure - while the theoretical
basis should be sound it might leak key material or have other implementation
defects.

Hence, please consult a cryptographer before using this for anything that
is actually important. 

=head1 FUNCTIONS

=over 4

=item B<new>

Create a new class instance. Includes the generation of an EC
server key (for signing) and the subset-difference keys.

=item B<newFromFile($file)>

Create a new class instance. Load previously generated 
key material from C<$file>.

=item B<newFromData($data)>

Create a new class instance. Previously generated key
material is provided in $data.

=item B<printEcInformation>

Print information about the server EC key to STDOUT.

=item B<writeServerData($file)>

Write the current server EC and subset-keys, as well
as the information about revoked users to C<$file>.

=item B<getServerData>

Returns the same information as in B<writeServerData>
as a string.

=item B<revokeUser($user)>

Revoke the user that is identified by the 32-bit path
in C<$user>. After calling this function, the server
data should probably be saved.

Please note that, for the scheme to work, always at
least one user has to be revoked.

=item B<clearRevokedUsers>

Clear the list of revoked users

=item B<generateKeylist($user)>

Generate a client keylist for a specified user. Only holds
it in the library, it is not output or written to disk.

=item B<writeClientData($filename)>

Write the last generated client keylist to C<$filename>.

=item B<getClientData>

Return the last generated client keylist

=item B<generateCover>

Generate the keys, etc. necessary for data encryption
using the current list of revoked users. After calling
this function you can encrypt data using C<generateSDTreeBlock>.

Please note that at least one user always has to be revoked
for the encryption to work. Please also note that no
user- or other management functions should be called
after generateCover is called, because it alters some 
data structures in a non-reversible way.

Do not call writeServerData after calling this function.

=item B<generateSDTreeBlock($data)>

Return an encrypted block of data.

=back

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
