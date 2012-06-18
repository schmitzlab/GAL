#!/usr/bin/perl
use strict;

use Test::More  'no_plan'; # tests => 17;

BEGIN {
	use lib '../../';
	#TEST 1
	use_ok('GAL::Annotation');
}

my $path = $0;
$path =~ s/[^\/]+$//;
$path ||= '.';
chdir($path);

# TEST 2
my $annotation = GAL::Annotation->new();
isa_ok($annotation, 'GAL::Annotation');

# TEST 
isa_ok($annotation->parser(class => 'gff3'), 'GAL::Parser::gff3', '$annotation->parser');

# TEST 
isa_ok($annotation->storage(dsn   => 'DBI:SQLite:data/test_storage.sqlite',
			    class => 'SQLite'
			   ), 'GAL::Storage::SQLite', '$annotation->storage');

# TEST 
ok($annotation->load_files('data/dmel-4-r5.29.gff'),
   '$annotation->load_files');

# TEST 
isa_ok($annotation->schema, 'GAL::Schema', '$annotation->schema');

my $features = $annotation->features;
isa_ok($features, 'DBIx::Class::ResultSet');

while (my $feature = $features->next) {
  ok($feature->seqid, '$feature->seqid');
}

# TEST 
my $annotation1 = GAL::Annotation->new('./data/dmel-4-r5.24.partial.gff');
isa_ok($annotation, 'GAL::Annotation');

my $features1 = $annotation1->features;
isa_ok($features, 'DBIx::Class::ResultSet');

while (my $feature = $features1->next) {
  ok($feature->seqid, '$feature->seqid');
}


################################################################################
################################# Ways to Test #################################
################################################################################

__END__

=head3

# Various other ways to say "ok"
ok($this eq $that, $test_name);

is  ($this, $that,    $test_name);
isnt($this, $that,    $test_name);

# Rather than print STDERR "# here's what went wrong\n"
diag("here's what went wrong");

like  ($this, qr/that/, $test_name);
unlike($this, qr/that/, $test_name);

cmp_ok($this, '==', $that, $test_name);

is_deeply($complex_structure1, $complex_structure2, $test_name);

can_ok($module, @methods);
isa_ok($object, $class);

pass($test_name);
fail($test_name);

BAIL_OUT($why);

=cut
