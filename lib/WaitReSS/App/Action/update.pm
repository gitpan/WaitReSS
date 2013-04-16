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

package WaitReSS::App::Action::update;
{
  $WaitReSS::App::Action::update::VERSION = '0.003';
}
# ABSTRACT: Implementation of update command

use Parallel::ForkManager;

use WaitReSS::Feeds;
use WaitReSS::Logging qw{ enable_pid };


# -- public methods


sub run {
    my ($pkg, $opts, $args) = @_;

    enable_pid(1);
    my $pm = Parallel::ForkManager->new(5);
    foreach my $feed ( $feeds->list ) {
        my $pid = $pm->start and next;  # forking
        my $n = $feed->update;
        $pm->finish;                    # ends child process
    }
    $pm->wait_all_children;
    enable_pid(0);
}


1;

__END__

=pod

=head1 NAME

WaitReSS::App::Action::update - Implementation of update command

=head1 VERSION

version 0.003

=head1 DESCRIPTION

This package implements the C<update> command. It is in a module of its
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
