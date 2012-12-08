use strict;
use warnings;

use Module::Build;

BEGIN {
  unless (`pkg-config --modversion openssl`) {
    warn "\nNo OpenSSL found on system, bailing out...\n";
    exit 0;
  }
}

my $cflags = `pkg-config --cflags openssl`;
my $ldflags = `pkg-config --libs openssl`;

my $builder = Module::Build->new(
	module_name => 'Crypt::SDTree',
	license => 'lgpl',
	dist_author => 'Johanna Amann <johanna@icir.org>',
	include_dirs => 'sdtree/lib',
	c_source => 'sdtree/lib',
	extra_linker_flags => $ldflags,
	extra_compiler_flags => $cflags,
	build_requires => {
		'ExtUtils::CBuilder' => 0,
	},
	requires => {
		perl => '5.10.1',
	},
	meta_merge => {
		resources => {
			license => 'http://www.gnu.org/licenses/lgpl-2.1.html',
			homepage => 'https://github.com/0xxon/perl-crypt-sdtree',
			bugtracker => 'https://github.com/0xxon/perl-crypt-sdtree/issues',
			repository  => 'git://github.com/0xxon/perl-crypt-sdtree.git',
		},
	},
);


$builder->create_build_script;
