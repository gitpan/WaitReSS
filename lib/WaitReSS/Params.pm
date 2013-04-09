#
# This file is part of WaitReSS
#
# This software is copyright (c) 2013 by Jerome Quelin.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use 5.016;
use warnings;

package WaitReSS::Params;
{
  $WaitReSS::Params::VERSION = '0.002';
}
# ABSTRACT: WaitReSS run-time parameters

use Exporter::Lite;
use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;
use Path::Tiny;

use WaitReSS::Config;
use WaitReSS::Logging;
use WaitReSS::Types;


# -- module vars

our @EXPORT = qw{ $params };
our $params = __PACKAGE__->new;


# -- attributes


has datadir   => ( rw, isa=>"Path::Tiny", coerce, lazy_build  );
has dir_feeds => ( rw, isa=>"Path::Tiny", lazy_build  );
has dir_users => ( rw, isa=>"Path::Tiny", lazy_build  );


# -- initialization

sub _build_datadir   {
    my $dir = path( $config->get( "data.directory" ) );
    debug( "data directory = $dir" );
    $dir->mkpath;
    return $dir;
}

sub _build_dir_feeds {
    my $self = shift;
    my $dir = $self->datadir->child( "feeds" );
    debug( "feeds directory = $dir" );
    $dir->mkpath;
    return $dir;
}

sub _build_dir_users {
    my $self = shift;
    my $dir = $self->datadir->child( "users" );
    debug( "users directory = $dir" );
    $dir->mkpath;
    return $dir;
}



no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

WaitReSS::Params - WaitReSS run-time parameters

=head1 VERSION

version 0.002

=head1 SYNOPSIS

    use WaitReSS::Params;
    # $params is automatically available
    my $dir = $params->dir_feeds;

=head1 DESCRIPTION

This module references all the run-time parameters of WaitReSS. That's
default values, overriden by configuration, itself overriden by
command-line options.

=head1 ATTRIBUTES

=head2 datadir

The directory where all WaitReSS data will be kept.

=head2 dir_feeds

The directory where feeds data will be stored.

=head2 dir_users

The directory where users data will be stored.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
