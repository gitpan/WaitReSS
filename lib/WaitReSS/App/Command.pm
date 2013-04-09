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

package WaitReSS::App::Command;
{
  $WaitReSS::App::Command::VERSION = '0.002';
}
# ABSTRACT: Base class for sub-commands

use App::Cmd::Setup -command;
use Moose;
use MooseX::Has::Sugar;
use Path::Tiny;
use UNIVERSAL::require;

use WaitReSS::Config;
use WaitReSS::Logging qw{ :config };


# -- public methods


sub opt_common {
    return (
        [ 'config|C=s' => "configuration file" ],
        [],
        [ "Logging options" ],
        [ "verbose|v+"   => "be more verbose (can be repeated)",  {default=>0} ],
        [ "quiet|q+"     => "be less versbose (can be repeated)", {default=>0} ],
        [ "timestamp|t!" => "prefix logs with a timestamp (can be negated)", ],
        [ "trace|T!"     => "prefix logs with a trace (can be negated)",     ],
    );
}


sub execute {
    my ($self, $opts, $args) = @_;

    binmode(STDOUT, ":utf8");
    binmode(STDERR, ":utf8");

    # first initialize the config with the right path to config file
    $config->set_file( $opts->{config} ) if $opts->{config};

    # then initialize the logging options
    more_verbose() for 1 .. $opts->{verbose};
    less_verbose() for 1 .. $opts->{quiet};
    enable_timestamp( $opts->{timestamp} ) if exists $opts->{timestamp};
    enable_trace    ( $opts->{trace} )     if exists $opts->{trace};

    my $action = ref($self) =~ s/Command/Action/r;
    $action->require or die $@;
    $action->run($opts, $args);
}


no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
1;

__END__

=pod

=head1 NAME

WaitReSS::App::Command - Base class for sub-commands

=head1 VERSION

version 0.002

=head1 DESCRIPTION

This module is the base class for all sub-commands.

=head1 METHODS

=head2 opt_common

    my @opts = $self->opt_common;

Return an array of common options to be used in a command's C<opt_spec>
method.

=for Pod::Coverage::TrustPod description opt_spec execute

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
