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
  $WaitReSS::App::Command::VERSION = '0.001';
}
# ABSTRACT: Base class for sub-commands

use App::Cmd::Setup -command;
use Moose;
use MooseX::Has::Sugar;
use Path::Tiny;


# -- public methods


sub opt_common {
    return (
        [ 'config|C=s' => "configuration file" ],
    );
}



sub initialize {
    my ($self, $opts) = @_;

    binmode(STDOUT, ":utf8");
    binmode(STDERR, ":utf8");

    # first initialize the config singleton with the right path to
    # configuration file.
    WaitReSS::Config->new( file=>$opts->{config} ) if $opts->{config};
}


no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
1;

__END__

=pod

=head1 NAME

WaitReSS::App::Command - Base class for sub-commands

=head1 VERSION

version 0.001

=head1 DESCRIPTION

This module is the base class for all sub-commands.

=head1 METHODS

=head2 opt_common

    my @opts = $self->opt_common;

Return an array of common options to be used in a command's C<opt_spec>
method.

=head2 initialize

    $cmd->initialize($opts);

Perform some various initializations.

=for Pod::Coverage::TrustPod description opt_spec execute

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
