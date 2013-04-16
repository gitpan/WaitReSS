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

package WaitReSS::App::Action::user;
{
  $WaitReSS::App::Action::user::VERSION = '0.004';
}
# ABSTRACT: Implementation of user command

use WaitReSS::Logging;
use WaitReSS::Users;


# -- public methods


sub run {
    my ($pkg, $opts, $args) = @_;

    my $login = shift @$args;
    given ( $opts->mode ) {
        when ( "list" ) {
            foreach my $u ( $users->list ) {
                info( $u->login );
            }
        }
        when ( "create" ) {
            $users->register( $login );
        }
        when ( "delete" ) {
            $users->delete( $login );
        }
    }
}


1;

__END__

=pod

=head1 NAME

WaitReSS::App::Action::user - Implementation of user command

=head1 VERSION

version 0.004

=head1 DESCRIPTION

This package implements the C<user> command. It is in a module of its
own to minimize the amount of code loaded at runtime.

=head1 METHODS

=head2 run

    $pkg->run( $opts, $args );

Run the actual command implementation.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
