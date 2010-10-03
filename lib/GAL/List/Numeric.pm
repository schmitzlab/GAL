package GAL::List::Numeric;

use strict;
use vars qw($VERSION);


$VERSION = '0.01';
use base qw(GAL::List);
use Statistics::Descriptive;

=head1 NAME

GAL::List::Numeric - Provide functions for lists of numbers

=head1 VERSION

This document describes GAL::List::Numeric version 0.01

=head1 SYNOPSIS

    use GAL::List::Numeric;

    @rand_list = map {int(rand(1000)) + 1} (1 .. 1000);
    $list_numeric = GAL::List::Numeric->new(list => \@rand_list);
    $stats = $list_numeric->stats;
    $mean  = $list_numerics->stats->mean;
    $bins  = $list_numeric->bins(\@bins);
    $bins  = $list_numeric->bin_range($min, $max, $step);
    $fd    = $list_numeric->fd($bin_value);
    $cfd   = $list_numeric->cfd;
    $rfd   = $list_numeric->relative_fd;
    $rcfd  = $list_numeric->relative_cfd;

    # The following methods are provided by <Statistics::Descriptive>, please see
    # documentation for that package.

    $list_numeric->stats->count();
    $list_numeric->stats->mean();
    $list_numeric->stats->sum();
    $list_numeric->stats->variance();
    $list_numeric->stats->standard_deviation();
    $list_numeric->stats->min();
    $list_numeric->stats->mindex();
    $list_numeric->stats->max();
    $list_numeric->stats->maxdex();
    $list_numeric->stats->sample_range();
    $list_numeric->stats->median();
    $list_numeric->stats->harmonic_mean();
    $list_numeric->stats->geometric_mean();
    $list_numeric->stats->mode();
    $list_numeric->stats->trimmed_mean($ltrim, $utrim);
    $list_numeric->stats->frequency_distribution($partitions);
    $list_numeric->stats->frequency_distribution(\@bins);
    $list_numeric->stats->frequency_distribution();
    $list_numeric->stats->least_squares_fit();

=head1 DESCRIPTION

    GAL::List::Nuimeric provides a collection of functions for lists
    of numbers.  It uses Statistics::Descriptive to provide basic
    descriptive statistics.  In addition it provides frequency
    distributions - as well as relative and cumulative frequency
    distributions - of binned values.

=head1 METHODS

=cut

#-----------------------------------------------------------------------------
#                                 Constructor
#-----------------------------------------------------------------------------

=head2 new

     Title   : new
     Usage   : GAL::List::Numeric->new()
     Function: Creates a GAL::List::Numeric object;
     Returns : A GAL::List::Numeric object
     Args    : list => \@list

=cut

sub new {
	my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args);
	return $self;
}

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
	my @valid_attributes = qw();
	$self->set_attributes($args, @valid_attributes);
	######################################################################
}

#-----------------------------------------------------------------------------
#                                 Attributes
#-----------------------------------------------------------------------------

# =head2 attribute
#
#  Title   : attribute
#  Usage   : $a = $self->attribute()
#  Function: Get/Set the value of attribute.
#  Returns : The value of attribute.
#  Args    : A value to set attribute to.
#
# =cut
#
# sub attribute {
#   my ($self, $attribute) = @_;
#   $self->{attribute} = $attribute if $attribute;
#   return $self->{attribute};
# }

#-----------------------------------------------------------------------------
#                                   Methods
#-----------------------------------------------------------------------------

=head2 stats

 Title   : stats
 Usage   : $stats = $self->stats()
 Function: Provides access to the Statistics::Descriptive object
 Returns : A Statistics::Descriptive object
 Args    : None

=cut

sub stats {
    my $self = shift;
    unless ($self->{stats}) {
	my $stats = Statistics::Descriptive::Full->new();
	$stats->add_data(@{$self->{list}});
	$self->{stats} = $stats;
    }
    return $self->{stats};
}

#-----------------------------------------------------------------------------

=head2 histogram

 Title   : histogram
 Usage   : $a = $self->histogram()
 Function:
 Returns :
 Args    :

=cut

sub histogram {
    my $self = shift;
    $self->throw(message => 'Metohd histogram not implimented yet');
}

#-----------------------------------------------------------------------------

=head2 bins

 Title   : bins
 Usage   : @bins = $self->bins($bin_count)
	   @bins = $self->bins($min, $max, $step)
	   @bins = $self->bins(\@bins)
 Function: Get/Set bin values
 Returns : A list or reference of the bin values.
 Args    : A reference to a list of bin values.

=cut

sub bins {
	my ($self, $min, $max, $step) = @_;
	if (ref $min eq 'ARRAY') {
	    my $bins = $min;
	    $self->{bins} = $bins;
	}
	else {
	    if ($min && ! defined $max && ! defined $step)  {
		my $bin_count = $min;
		$min  = $self->min unless defined $min;
		$max  = $self->max unless defined $max;
		$step = ($max - $min) / $bin_count;
	    }
	    $min  = $self->min unless defined $min;
	    $max  = $self->max unless defined $max;
	    $step = ($max - $min) / 10 unless defined $step;
	    $step = sprintf "%.1g", $step;
	    my @bins;
	    foreach (my $i = $min + $step; $i <= $max + $step; $i += $step) {
		push @bins, $i;
	    }
	    $self->{bins} = \@bins;
	}
	$self->bin_range unless $self->{bins};
	return wantarray ? @{$self->{bins}} : $self->{bins};
}

#-----------------------------------------------------------------------------

=head2 bin_range

 Title   : bin_range
 Usage   : @bins = $self->bin_range($min, $max, $step)
 Function: Get
 Returns :
 Args    :

=cut

sub bin_range {
	my ($self, $min, $max, $step) = @_;

	$min  = $self->min unless defined $min;
	$max  = $self->max unless defined $max;
	$step = ($max - $min) / 10 unless defined $step;
	$step = sprintf "%.1g", $step;
	my @bins;
	foreach (my $i = $min + $step; $i <= $max + $step; $i += $step) {
		push @bins, $i;
	}
	$self->{bins} = \@bins;
	return wantarray ? @bins : \@bins;
}

#-----------------------------------------------------------------------------

=head2 fd

 Title   : fd
 Usage   : $a = $self->fd()
 Function:
 Returns :
 Args    :

=cut

sub fd {
    my ($self, $bin_value) = @_;
    my @bins;
    my $min = $self->min;
    my $max = $self->max;

    if (! $self->{frequencey_distribution} || $bin_value) {
	if (ref $bin_value eq 'ARRAY') {
	    @bins = @{$bin_value};
	}
	elsif (ref $bin_value eq 'HASH') {
	    $self->bin_range(@{$bin_value}->{qw(min max step)});
	}
	elsif ($bin_value && $bin_value == int($bin_value)) {
	    my $step = ($max - $min) / $bin_value;
	    $self->bin_range(undef, undef, $step);
	}
	my @bins = $self->bins;
	my %fd;
	  DATUM:
	    for my $datum ($self->list) {
		my $min_bin = 0;
		my $max_bin = scalar @bins - 1;
		my $bindex =  int($max_bin / 2);
		while (1) {
		    next DATUM if ($bindex < $min_bin ||
				   $bindex > $max_bin);
		    my $upper = $bins[$bindex];
		    my $lower = $bindex - 1 >= 0 ? $bins[$bindex - 1] : $min - 1;
		    if ($self->float_le($datum, $upper)) {
			$max_bin = $bindex;
			if ($self->float_gt($datum, $lower)) {
			    $fd{$bins[$bindex]}++;
			    next DATUM;
			}
			else {
			    $bindex -= (int(($bindex - $min_bin) / 2) || 1);
			}
		    }
		    else {
			$min_bin = $bindex;
			$bindex += (int(($max_bin - $bindex) / 2) || 1);
		    }
		}
	    }
	map {$fd{$_} ||= 0} @bins;
	$self->{fd} = \%fd;
    }
    return wantarray ? %{$self->{fd}} : $self->{fd};
}

#-----------------------------------------------------------------------------

=head2 cfd

 Title   : cfd
 Usage   : $a = $self->cfd()
 Function:
 Returns :
 Args    :

=cut

sub cfd {
    my $self = shift;
    my %cfd = $self->fd;
    my $running_total;
    for my $key (sort {$a <=> $b} keys %cfd) {
	my $datum = $cfd{$key};
	$running_total += $datum;
	$cfd{$key} = $running_total;
    }
    return wantarray ? %cfd : \%cfd;
}

#-----------------------------------------------------------------------------

=head2 relative_fd

 Title   : relative_fd
 Usage   : $a = $self->relative_fd()
 Function:
 Returns :
 Args    :

=cut

sub relative_fd {
    my $self = shift;
    my %relative_fd = $self->fd;
    my $count = $self->count;
    map {$relative_fd{$_} /= $count} keys %relative_fd;
    return wantarray ? %relative_fd : \%relative_fd;
}

#-----------------------------------------------------------------------------

=head2 relative_cfd

 Title   : relative_cfd
 Usage   : $a = $self->relative_cfd()
 Function:
 Returns :
 Args    :

=cut

sub relative_cfd {
    my $self = shift;
    my %relative_cfd = $self->cfd;
    my $count = $self->count;
    map {$relative_cfd{$_} /= $count} keys %relative_cfd;
    return wantarray ? %relative_cfd : \%relative_cfd;
}

#-----------------------------------------------------------------------------

=head2 method

 Title   : method
 Usage   : $a = $self->method()
 Function:
 Returns :
 Args    :

=cut

sub method {
    my $self = shift;
    $self->throw('Metohd ? not implimented yet');
}

#-----------------------------------------------------------------------------

=head1 DIAGNOSTICS

=over

=item C<< Metohd histogram not implimented yet >>

There is a place holder for the histogram method, but the method has
not been written yet.

=back

=head1 CONFIGURATION AND ENVIRONMENT

<GAL::List::Numeric> requires no configuration files or environment variables.

=head1 DEPENDENCIES

<GAL::List>
<Statistics::Descriptive>

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