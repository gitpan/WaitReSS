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

package WaitReSS::App::Command::config;
{
  $WaitReSS::App::Command::config::VERSION = '0.004';
}
# ABSTRACT: Read/update WaitReSS configuration

use WaitReSS::App -command;


# -- public methods

sub description {
"Read / update WaitReSS configuration."
}

sub opt_spec {
    my $self = shift;
    return (
        $self->opt_common,
        [ "mode" => hidden => { one_of => [
            [ "get|g"    => "get the value" ],
            [ "set|s"    => "set the value" ],
            [ "delete|d" => "delete it" ],
        ] } ],
    );
}


1;

__END__

=pod

=head1 NAME

WaitReSS::App::Command::config - Read/update WaitReSS configuration

=head1 VERSION

version 0.004

=head1 DESCRIPTION

This command allows to read & update WaitRess' configuration.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
