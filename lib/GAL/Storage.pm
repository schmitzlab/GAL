package GAL::Storage;

use strict;
use vars qw($VERSION);


$VERSION = '0.01';
use base qw(GAL::Base);

=head1 NAME

GAL::Storage - <One line description of module's purpose here>

=head1 VERSION

This document describes GAL::Storage version 0.01

=head1 SYNOPSIS

     use GAL::Storage;

=for author to fill in:
     Brief code example(s) here showing commonest usage(s).
     This section will be as far as many users bother reading
     so make it as educational and exemplary as possible.

=head1 DESCRIPTION

=for author to fill in:
     Write a full description of the module and its features here.
     Use subsections (=head2, =head3) as appropriate.

=head1 METHODS

=cut

#-----------------------------------------------------------------------------

=head2 new

     Title   : new
     Usage   : GAL::Storage->new();
     Function: Creates a Storage object;
     Returns : A Storage object
     Args    :

=cut

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args);
	$class = $class . '::' . $self->driver;
	$self->load_module($class);
	$self = $class->new(@args);
	return $self;
}

#-----------------------------------------------------------------------------

sub _initialize_args {
	my ($self, @args) = @_;

	######################################################################
	# This block of code handels class attributes.  Use the
	# @valid_attributes below to define the valid attributes for
	# this class.  You must have identically named get/set methods
	# for each attribute.  Leave the rest of this block alone!
	######################################################################
	my $args = $self->SUPER::_initialize_args(@args);
	# Set valid class attributes here
	my @valid_attributes = qw(dsn user password);
	$self->set_attributes($args, @valid_attributes);
	######################################################################
}

#-----------------------------------------------------------------------------

=head2 dsn

 Title   : dsn
 Usage   : $a = $self->dsn();
 Function: Get/Set the value of dsn.
 Returns : The value of dsn.
 Args    : A value to set dsn to.

=cut

sub dsn {
	my ($self, $dsn) = @_;

	if ($self->{dsn} && ! $dsn) {
		return $self->{dsn};
	}

	# If we don't have a dsn, then create one
	$dsn ||= '';
	my @parts = split ':', $dsn;
	shift @parts if $parts[0] =~ /^dbi$/i;
	my ($driver, @attribute_parts) = @parts;
	my $attribute_txt = join '', @attribute_parts;
	my %attributes = map {split /=/} split /;/, $attribute_txt;

	$driver  = $self->driver($driver);
	$attributes{database} = $self->database($attributes{database});
	$attribute_txt = '';
	for my $key (keys %attributes) {
	  $attribute_txt .= $key . '=' . $attributes{$key} . ';';
	}
	$self->{dsn} = join ':', ('DBI', $driver, $attribute_txt);

	return $self->{dsn};
}

#-----------------------------------------------------------------------------

=head2 user

 Title   : user
 Usage   : $a = $self->user();
 Function: Get/Set the value of user.
 Returns : The value of user.
 Args    : A value to set user to.

=cut

sub user {
	my ($self, $user) = @_;
	$self->{user} = $user if $user;
	return $self->{user};
}

#-----------------------------------------------------------------------------

=head2 password

 Title   : password
 Usage   : $a = $self->password();
 Function: Get/Set the value of password.
 Returns : The value of password.
 Args    : A value to set password to.

=cut

sub password {
	my ($self, $password) = @_;
	$self->{password} = $password if $password;
	return $self->{password};
}

#-----------------------------------------------------------------------------

=head2 database

 Title   : database
 Usage   : $a = $self->database();
 Function: Get/Set the value of database.
 Returns : The value of database.
 Args    : A value to set database to.

=cut

sub database {
	my ($self, $database) = @_;

	if (! $self->{database} && ! $database) {
		# Generate a date stamp
		my ($sec,$min,$hour,$mday,$mon,$year,$wday,
		    $yday,$isdst) = localtime(time);
		my $time_stamp = sprintf("%02d%02d%02d", $year + 1900,
					 $mon, $mday);
		# Generate a 8 charachter semi-random hex extension
		# for the database.
		my @symbols = (0..9);
		push @symbols, qw(a b c d e f);
		my $extension = join "", map { unpack "H*", chr(rand(256)) } (1..8);
		$database = join '_', ('gal_database', $time_stamp,
				      $extension);
		$self->warn(message => ("Incomplete Data Source Name (DSN) ",
					"given. ", __PACKAGE__,
					' created $database as a database ',
					'name for you.')
			   );
	}
	$self->{database} = $database if $database;
	return $self->{database};
}

#-----------------------------------------------------------------------------

=head2 driver

 Title   : driver
 Usage   : $a = $self->driver();
 Function: Get/Set the value of driver.
 Returns : The value of driver.
 Args    : A value to set driver to.

=cut

sub driver {
	my ($self, $driver) = @_;

	if (! $self->{driver} && ! $driver) {
		$driver = 'sqlite';
		$self->warn(message => ("Incomplete Data Source Name (DSN) ",
					"given. ", __PACKAGE__,
					' created $driver as a database ',
					'driver for you.')
			   );
	}
	$self->{driver} = $driver if $driver;
	return $self->{driver};
}

#-----------------------------------------------------------------------------

=head2 load_file

 Title   : load_file
 Usage   : $a = $self->load_file();
 Function: Parse and store all of the features in a file
 Returns : N/A
 Args    : file  => data_file_name
	   class => GAL::Parser::subclass.

=cut

sub load_file {

	my ($self, @files) = @_;
	$self->throw('Not Implimented : load_file');


	for my $file (@files) {

	  my $parser = $self->parser;

	  while (my $feature = $parser->next_feature_hash) {

	    $self->add_feature_to_buffer($feature);
	  }
	}
	$self->flush_feature_buffer;

# This all needs to be re-worked to not use DBIx::Class;

#	my $self = shift;
#	my $parser = $self->parser(@_);
#	my $feature_rs   = $self->schema->resultset('Feature');
#	my $attribute_rs = $self->schema->resultset('Attribute');
#
#	my @features;
#	my @attributes;
#	my $count = 1;
#	my $bulk_load_count = 10; #$self->bulk_load_count;
#	while (my $record = $parser->_read_next_record) {
#
#		my $feature_hash = $parser->parse_record($record);
#		next unless defined $feature_hash;
#		my ($feature, $attribute_array) =
#		  $self->_split_feature_and_attributes($feature_hash);
#		push @features, $feature;
#		push @attributes, @{$attribute_array};
#		if ($count++ >= $bulk_load_count) {
#			$feature_rs->populate(\@features);
#			$attribute_rs->populate(\@attributes);
#			$count = 1;
#			@features = ();
#			@attributes = ();
#		}
#	}
#	$feature_rs->insert_bulk(@features) if scalar @features;;
#	$attribute_rs->populate(\@attributes) if scalar @attributes;
#
#	return $self;
}

#-----------------------------------------------------------------------------

=head2 add_features_to_buffer

 Title   : add_features_to_buffer
 Usage   : $self->add_features_to_buffer();
 Function: Get/Set value of add_features_to_buffer.
 Returns : Value of add_features_to_buffer.
 Args    : Value to set add_feature to.

=cut

sub add_features_to_buffer {

	my ($self, $features) = @_;

	$features = ref $features ? $features : [$features];

	#$self->config('MAX_FEATURE_BUFFER')
	if (scalar @{$self->{_feature_buffer}} + scalar @{$features} > 10000) {
	  push @{$self->{_feature_buffer}}, @{$features};
	  $self->flush_feature_buffer;
	}
	else {
	  push @{$self->{_feature_buffer}}, @{$features};
	}
}

#-----------------------------------------------------------------------------

=head2 flush_feature_buffer

 Title   : flush_feature_buffer
 Usage   : $self->flush_feature_buffer();
 Function: Get/Set value of flush_feature_buffer.
 Returns : Value of flush_feature_buffer.
 Args    : Value to set add_feature to.

=cut

sub flush_feature_buffer {

	my $self = shift;

	if (scalar @{$self->{_feature_buffer}}) {
		$self->add_features($self->{_feature_buffer});
	}
}

#-----------------------------------------------------------------------------

=head2 prepare_features

 Title   : prepare_features
 Usage   : $self->prepare_features();
 Function: Normalizes feature hashes produced by the parsers
	   and seperates the attributes for bulk insert into the database;
 Returns : A feature hash reference and an array reference of hash references
	   of attributes.  Both normalized for insert statements
 Args    : A feature hash or array of feature hashes

=cut

sub prepare_features {

	my ($self, $feature_hashes) = @_;

	$feature_hashes = ref $feature_hashes ? $feature_hashes :
	  [$feature_hashes];

	my (@features, @attributes);

	for my $feature_hash (@{$feature_hashes}) {
		my $feature_id = $feature_hash->{feature_id};
		my @feature_row = @{$feature_id}{qw(feature_id seqid source
						    type start end score
						    strand phase)
					       };
		push @features, \@feature_row;
		for my $tag (keys %{$feature_hash->{attributes}}) {
			for my $value (@{$feature_hash->{attributes}{$tag}}) {
				push @attributes, [$feature_id,
						   $tag,
						   $value,
						  ];
			}
		}
	}
	return (\@features, \@attributes);
}

#-----------------------------------------------------------------------------

=head2 add_feature

 Title   : add_feature
 Usage   : $self->add_feature();
 Function: Get/Set value of add_feature.
 Returns : Value of add_feature.
 Args    : Value to set add_feature to.

=cut

sub add_features {
  my ($self, $features) = @_;

  $features = ref $features ? $features : [$features];

  my ($features, $attributes) = $self->prepare_features($features);
}

#-----------------------------------------------------------------------------

=head2 create_database

 Title   : create_database
 Usage   : $self->create_database();
 Function: Create the database if it doesn't exists.
 Returns : Success
 Args    : N/A

=cut

sub create_database {
	my $self = shift;

	my @databases = DBI->data_sources($self->driver,
					  {user     => $self->user,
					   password => $self->password,
					  }
					 );

	my $dsn = $self->dsn;
	my $database = $self->database;
	if (! grep {$_ eq $dsn} @databases) {
		my $drh = DBI->install_driver("mysql");
		my $host = ''; # Defaults to localhost, abstract this later.
		my $rc = $drh->func('createdb',
				    $database,
				    $host,
				    $self->user,
				    $self->password,
				    'admin');
		my $dbh = DBI->connect($self->dsn, $self->user,
				       $self->password);
		$dbh->do("DROP TABLE IF EXISTS feature");
		$dbh->do("DROP TABLE IF EXISTS attribute");
		my @feature_columns = (feature_id => 'VARCHAR(100),',
				       seqid      => 'VARCHAR(100),',
				       source     => 'VARCHAR(100),',
				       type       => 'VARCHAR(100),',
				       start      => 'INT,',
				       end        => 'INT,',
				       score      => 'varchar(20),',
				       strand     => 'VARCHAR(1),',
				       phase      => 'VARCHAR(1),',
				      );
		my $feature_columns_text = join ' ', @feature_columns;
		$feature_columns_text =~ s/,\s*$//;
		my $feature_create_stmt =
		  "CREATE TABLE feature ($feature_columns_text)";
		$dbh->do($feature_create_stmt);

		my @att_columns =
			       (attribute_id => 'INT NOT NULL AUTO_INCREMENT,',
				feature_id   => 'VARCHAR(100),',
				tag      => 'VARCHAR(100),',
				value    => 'TEXT,',
			       );
		my $att_columns_text = join ' ', @att_columns;
		my $att_create_stmt =
		  "CREATE TABLE attribute ($att_columns_text " .
		    "PRIMARY KEY (attribute_id))";
		#CREATE TABLE attribute (attribute_id INT NOT NULL
		# AUTO_INCREMENT, feature_id VARCHAR(100),
		# tag VARCHAR(100), value TEXT, PRIMARY KEY (attribute_id))
		$dbh->do($att_create_stmt);
	}
	else {
		$self->warn(message => "Using exsiting database $database");
	}

	return 1;
}

#-----------------------------------------------------------------------------

=head2 get_children

 Title   : get_children
 Usage   : $self->get_children();
 Function: Get/Set value of get_children.
 Returns : Value of get_children.
 Args    : Value to set get_children to.

=cut

sub get_children {
	my $self = shift;
	$self->throw('Not Implimented : get_children');
}

#-----------------------------------------------------------------------------

=head2 get_children_recursively

 Title   : get_children_recursively
 Usage   : $self->get_children_recursively();
 Function: Get/Set value of get_children_recursively.
 Returns : Value of get_children_recursively.
 Args    : Value to set get_children_recursively to.

=cut

sub get_children_recursively {
  my $self = shift;
  $self->throw('Not Implimented : get_children_recursively');
}

#-----------------------------------------------------------------------------

=head2 get_parents

 Title   : get_parents
 Usage   : $self->get_parents();
 Function: Get/Set value of get_parents.
 Returns : Value of get_parents.
 Args    : Value to set get_parents to.

=cut

sub get_parents {
  my $self = shift;
  $self->throw('Not Implimented : get_parents');
}

#-----------------------------------------------------------------------------

=head2 get_parents_recursively

 Title   : get_parents_recursively
 Usage   : $self->get_parents_recursively();
 Function: Get/Set value of get_parents_recursively.
 Returns : Value of get_parents_recursively.
 Args    : Value to set get_parents_recursively to.

=cut

sub get_parents_recursively {
  my $self = shift;
  $self->throw('Not Implimented : get_parents_recursively');
}

#-----------------------------------------------------------------------------

=head2 get_all_features

 Title   : get_all_features
 Usage   : $self->get_all_features();
 Function: Get/Set value of get_all_features.
 Returns : Value of get_all_features.
 Args    : Value to set get_all_features to.

=cut

sub get_all_features {
  my $self = shift;
  $self->throw('Not Implimented : get_all_features');
}

#-----------------------------------------------------------------------------

=head2 get_features_by_type

 Title   : get_features_by_type
 Usage   : $self->get_features_by_type();
 Function: Get/Set value of get_features_by_type.
 Returns : Value of get_features_by_type.
 Args    : Value to set get_features_by_type to.

=cut

sub get_features_by_type {
  my $self = shift;
  $self->throw('Not Implimented : get_features_by_type');
}

#-----------------------------------------------------------------------------

=head2 get_recursive_features_by_type

 Title   : get_recursive_features_by_type
 Usage   : $self->get_recursive_features_by_type();
 Function: Get/Set value of get_recursive_features_by_type.
 Returns : Value of get_recursive_features_by_type.
 Args    : Value to set get_recursive_features_by_type to.

=cut

sub get_recursive_features_by_type {
  my $self = shift;
  $self->throw('Not Implimented : get_recursive_features_by_type');
}

#-----------------------------------------------------------------------------

=head2 get_feature_by_id

 Title   : get_feature_by_id
 Usage   : $self->get_feature_by_id();
 Function: Get/Set value of get_feature_by_id.
 Returns : Value of get_feature_by_id.
 Args    : Value to set get_feature_by_id to.

=cut

sub get_feature_by_id {
  my $self = shift;
  $self->throw('Not Implimented : get_feature_by_id');
}

#-----------------------------------------------------------------------------

=head2 filter_features

 Title   : filter_features
 Usage   : $self->filter_features();
 Function: Get/Set value of filter_features.
 Returns : Value of filter_features.
 Args    : Value to set filter_features to.

=cut

sub filter_features {
  my $self = shift;
  $self->throw('Not Implimented : filter_features');
}

#-----------------------------------------------------------------------------

=head2 foo

 Title   : foo
 Usage   : $a = $self->foo();
 Function: Get/Set the value of foo.
 Returns : The value of foo.
 Args    : A value to set foo to.

=cut

sub foo {
	my ($self, $value) = @_;
	$self->{foo} = $value if defined $value;
	return $self->{foo};
}

#-----------------------------------------------------------------------------

=head1 DIAGNOSTICS

=for author to fill in:
     List every single error and warning message that the module can
     generate (even the ones that will "never happen"), with a full
     explanation of each problem, one or more likely causes, and any
     suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back

=head1 CONFIGURATION AND ENVIRONMENT

<GAL::Storage> requires no configuration files or environment variables.

=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to:
barry.moore@genetics.utah.edu

=head1 AUTHOR

Barry Moore <barry.moore@genetics.utah.edu>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2009, Barry Moore <barry.moore@genetics.utah.edu>.  All rights reserved.

    This module is free software; you can redistribute it and/or
    modify it under the same terms as Perl itself.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut

1;