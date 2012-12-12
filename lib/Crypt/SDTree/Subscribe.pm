package Crypt::SDTree::Subscribe;

use strict;
use warnings;

use Crypt::SDTree qw(:subscribe);

our $VERSION = '0.03';

sub new {
	subscribe_new(@_);
}

sub DESTROY {
	subscribe_DESTROY(@_);
}

=head1 NAME

Crypt::SDTree::Subscribe - Decrypt Broadcast Messages

=head1 SYNOPSIS

  use Crypt::SDTree::Subscribe;

  my $client = Crypt::SDTree::Subscribe->new('keyfile');
  my $decrypted = $subscriber->decrypt($message);

=head1 ABSTRACT

Perl interface for the decryption of broadcast messages

=head1 DESCRIPTION

This package allows the decryption of messages that have
been encrypted by L<Crypt::SDTree::Publish>. 

Please note that this module has not been reviewed by anyone other than
myself. I am not sure that it actually is secure - while the theoretical
basis should be sound it might leak key material or have other implementation
defects.

Hence, please consult a cryptographer before using this for anything that
is actually important. 

=head1 FUNCTIONS

=over 4

=item B<new($filename)>

Create a new class instance. Key information is loaded
from C<$filename>. Key material can be created using 
C<Crypt::SDTree::Publish>

=item B<newFromClientData($data)>

Same as C<new>, just that the client key information
is directly provided and not loaded from a file.

=item B<decrypt($data)>

Try to decrypt the encrypted data block in C<$data>.
Returns the decrypted data or C<undef>, if it cannot
be decrypted.

=item B<printEcInformation>

Print information about the publishers EC-key to STDOUT.

=item B<printSDKeyList> 

Print the subset-difference key list to STDOUT

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
