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

package WaitReSS::App::Command::user;
{
  $WaitReSS::App::Command::user::VERSION = '0.004';
}
# ABSTRACT: Manage WaitReSS users

use WaitReSS::App -command;


# -- public methods

sub description {
"Manage WaitReSS users."
}

sub opt_spec {
    my $self = shift;
    return (
        $self->opt_common,
        [ "mode" => hidden => { one_of => [
            [ "list|l"   => "list users" ],
            [ "create|c" => "create a user" ],
            [ "delete|d" => "delete it" ],
        ] } ],
    );
}


1;

__END__

=pod

=head1 NAME

WaitReSS::App::Command::user - Manage WaitReSS users

=head1 VERSION

version 0.004

=head1 DESCRIPTION

This command allows to manage WaitRess' users.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
