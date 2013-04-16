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

package WaitReSS::App::Action::show;
{
  $WaitReSS::App::Action::show::VERSION = '0.003';
}
# ABSTRACT: Implementation of show command

use WaitReSS::Config;
use WaitReSS::Feeds;
use WaitReSS::Logging;
use WaitReSS::Users;


# -- public methods


sub run {
    my ($pkg, $opts, $args) = @_;

    # check which user is registering
    my $login = $opts->{user} // $config->get( "cli.default.user" );
    if ( ! defined $login ) {
        error( "Must specify a user for this command." );
        exit 1;
    }
    my $user = $users->by_login( $login );
    if ( ! defined $user ) {
        error( "User $login doesn't exist");
        exit 1;
    }

    # show unred items for the user
    my $id = shift @$args;
    my %items = $user->unread_items( $id );
    foreach my $id ( sort keys %items ) {
        my $feed = $feeds->by_id( $id );
        info( $feed->id . " " . $feed->url . " (" . $feed->title . ")"  );
        my @items = sort {$a->pub_date <=> $b->pub_date} @{ $items{$id} };
        foreach my $item ( @items ) {
            info( " "x4 . $item->as_string );
        }

    }
}


1;

__END__

=pod

=head1 NAME

WaitReSS::App::Action::show - Implementation of show command

=head1 VERSION

version 0.003

=head1 DESCRIPTION

This package implements the C<show> command. It is in a module of its
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
