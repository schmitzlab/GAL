package GAL::Annotation;

use strict;
use vars qw($VERSION);


$VERSION = '0.01';
use base qw(GAL::Base);

=head1 NAME

Annotation::GAL - <One line description of module's purpose here>

=head1 VERSION

This document describes Annotation::GAL version 0.01

=head1 SYNOPSIS

     use Annotation::GAL;

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

=head2

     Title   : new 
     Usage   : Annotation::GAL->new();
     Function: Creates a Annotation::GAL object;
     Returns : A Annotation::GAL object
     Args    : 

=cut

sub new {
        my ($class, @args) = @_;
        my $self = $class->SUPER::new;
        $self->_initialize_args(@args);
        $self->parse;
        return $self;
}

#-----------------------------------------------------------------------------                                                                                                   

sub _initialize_args {
        my ($self, @args) = @_;

	my $args = $self->prepare_args(@args);

	my @valid_attributes = qw(parse_file
                                  add_feature
                                  get_all_features
                                  get_features_by_type
                                  get_recursive_features_by_type
                                  get_feature_by_id
                                  filter_features
                                 );

	$self->set_attributes($args, @valid_attributes);

	print '';

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

=head2 parse_file 

 Title   : parse_file 
 Usage   : $self->parse_file();
 Function: Get/Set value of parse_file.
 Returns : Value of parse_file.
 Args    : Value to set parse_file to.

=cut

sub parse_file {
  my ($self, $value) = @_;
  $self->{parse_file} = $value if defined $value;
  return $self->{parse_file};
}

#-----------------------------------------------------------------------------

=head2 add_feature 

 Title   : add_feature 
 Usage   : $self->add_feature();
 Function: Get/Set value of add_feature.
 Returns : Value of add_feature.
 Args    : Value to set add_feature to.

=cut

sub add_feature {
  my ($self, $value) = @_;
  $self->{add_feature} = $value if defined $value;
  return $self->{add_feature};
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
  my ($self, $value) = @_;
  $self->{get_all_features} = $value if defined $value;
  return $self->{get_all_features};
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
  my ($self, $value) = @_;
  $self->{get_features_by_type} = $value if defined $value;
  return $self->{get_features_by_type};
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
  my ($self, $value) = @_;
  $self->{get_recursive_features_by_type} = $value if defined $value;
  return $self->{get_recursive_features_by_type};
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
  my ($self, $value) = @_;
  $self->{get_feature_by_id} = $value if defined $value;
  return $self->{get_feature_by_id};
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
  my ($self, $value) = @_;
  $self->{filter_features} = $value if defined $value;
  return $self->{filter_features};
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

<Annotation::GAL> requires no configuration files or environment variables.

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





