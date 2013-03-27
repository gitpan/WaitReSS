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

package WaitReSS::App::Command::update;
{
  $WaitReSS::App::Command::update::VERSION = '0.001';
}
# ABSTRACT: Update feeds

use Parallel::ForkManager;

use WaitReSS::App -command;
use WaitReSS::Collection;


# -- public methods

sub description {
"Update feeds that WaitReSS watches."
}

sub opt_spec {
    my $self = shift;
    return (
        $self->opt_common,
    );
}

sub execute {
    my ($self, $opts, $args) = @_;
    $self->initialize($opts);

    my $pm   = Parallel::ForkManager->new(5);
    my $coll = WaitReSS::Collection->new;
    foreach my $feed ( $coll->feeds ) {
        my $pid = $pm->start and next;  # forking
        my $n = $feed->update;
        $pm->finish;                    # ends child process
    }
    $pm->wait_all_children;
}

1;

__END__

=pod

=head1 NAME

WaitReSS::App::Command::update - Update feeds

=head1 VERSION

version 0.001

=head1 DESCRIPTION

This command force an update of all registered feeds within WaitReSS.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
