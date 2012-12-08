use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new(
	module_name => 'Crypt::SDTree',
	license => 'lgpl',
	dist_author => 'Johanna Amann <johanna@icir.org>',
	include_dirs => 'sdtree/lib',
	c_source => 'sdtree/lib',
	extra_linker_flags => '-lcrypto',
);


$builder->create_build_script;
