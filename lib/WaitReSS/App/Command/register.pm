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

package WaitReSS::App::Command::register;
{
  $WaitReSS::App::Command::register::VERSION = '0.003';
}
# ABSTRACT: Register a feed for a given user

use WaitReSS::App -command;


# -- public methods

sub description {
"Register a feed for a given user."
}

sub opt_spec {
    my $self = shift;
    return (
        $self->opt_common,
        [ "user|u=s", "the user registering a feed" ],
    );
}


1;

__END__

=pod

=head1 NAME

WaitReSS::App::Command::register - Register a feed for a given user

=head1 VERSION

version 0.003

=head1 DESCRIPTION

This command allows to register a feed for a given user. The feed is
created if needed.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
