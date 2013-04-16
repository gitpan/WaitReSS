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

package WaitReSS::Config;
{
  $WaitReSS::Config::VERSION = '0.004';
}
# ABSTRACT: WaitReSS configuration

use Exporter::Lite;
use File::HomeDir   qw{ my_dist_config my_dist_data };
use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;
use Path::Tiny;
use YAML::XS        qw{ Load Dump };

use WaitReSS::Types;


# -- module vars

our @EXPORT = qw{ $config };
our $config = __PACKAGE__->new;
my %default = (
    "data.directory"    => my_dist_data("WaitReSS", {create=>1}),
    "log.level"         => "info",
    "log.pid"           => 0,
    "log.timestamp"     => 0,
    "log.trace"         => 0,
    "cli.default.user"  => undef,
);


# -- attributes


has file  => ( rw, isa => 'Path::Tiny', coerce, lazy_build, trigger=>\&_on_set_file );
has _hash => ( rw, isa => 'HashRef', lazy_build );


# --  initializer

sub _build_file {
    my $configdir = path(my_dist_config( "WaitReSS", { create=>1 } ));
    return $configdir->child( "waitress.conf" );
}

sub _build__hash {
    my $self = shift;
    my $file = $self->file;
    #debug( "loading $file" );
    my $yaml = eval { Load( $file->slurp_utf8 ); };
    return $@ ? {} : $yaml;
}

sub _on_set_file {
    my ($self, $file, $old_file) = @_;
    #debug( "loading $file" );
    my $yaml = eval { Load( $file->slurp_utf8 ); };
    $self->_set_hash( $@ ? {} : $yaml );
}

# -- methods


sub save {
    my $self = shift;
    my $file = $self->file;
    my $hash = $self->_hash;
    $hash->{meta} = {
        schema_version => 1
    };
    #debug( "saving configuration to $file" );
    $file->spew_utf8( Dump( $hash ) );
}



sub get {
    my ($self, $key) = @_;
    my $hash = $self->_hash;
    $hash = $hash->{ $_ } for split /\./, $key;
    if ( ! defined $hash ) {
        $hash = $default{ $key };
        #debug( "no configuration for $key, using default ($hash)" );
    }
    return $hash;
}



sub set {
    my ($self, $key, $val) = @_;
    # prevent setting invalid keys
    return unless exists $default{$key};
    my $hash = $self->_hash;
    eval '$hash->{' . join( "}{", split /\./, $key ) . '} = $val';
}



sub delete {
    my ($self, $key, $val) = @_;
    my $hash = $self->_hash;
    eval 'delete $hash->{' . join( "}{", split /\./, $key ) . '}';
}



no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

WaitReSS::Config - WaitReSS configuration

=head1 VERSION

version 0.004

=head1 SYNOPSIS

    use WaitReSS::Config;
    # $config is automatically available
    my $val = $config->get( "foo.bar.baz" );
    $config->set( "foo.bar.baz", 42 );
    $config->save;

    # or you can create your config yourself, but what's the point?
    my $config = WaitRess::Config->new( file => "/path/to/file" );
    # or even
    $config->set_file( "/path/to/another/file" );

=head1 DESCRIPTION

This module implements a basic persistant configuration. The
configuration is stored as YAML, yet keys are flattened using dots -
eg, a C<foo.bar.baz> key will fetch at depth 3.

Loading this module will automatically import C<$config> in your module.

=head1 ATTRIBUTES

=head2 file

The configuration file path.

=head1 METHODS

=head2 save

    $config->save;

Save C<$config> to its on-disk file.

=head2 get

    my $value = $config->get( $key );

Return the C<$value> associated to C<$key> in C<$config>.

=head2 set

    $config->set( $key, $value );

Associate a given C<$value> to a C<$key> in C<$config>.

=head2 delete

    $config->delete( $key );

Remove a C<$key> from C<$config>.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
