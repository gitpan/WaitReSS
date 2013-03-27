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

package WaitReSS::App::Command::list;
{
  $WaitReSS::App::Command::list::VERSION = '0.001';
}
# ABSTRACT: Register a new feed

use WaitReSS::App -command;
use WaitReSS::Collection;
use WaitReSS::Feed;
use WaitReSS::Logging;


# -- public methods

sub description {
"List registered feeds within WaitRess along with their status."
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

    my $coll = WaitReSS::Collection->new;
    foreach my $feed ( $coll->feeds ) {
        info( $feed->as_string );
    }
}

1;

__END__

=pod

=head1 NAME

WaitReSS::App::Command::list - Register a new feed

=head1 VERSION

version 0.001

=head1 DESCRIPTION

This command pauses according to the recommendation of Mageia
build-system. Indeed, instead of pushing all your packages to be
rebuilt, it's better to throttle them one at a time. Build-system
provides some recommendation on how much to pause between 2 packages -
and this command uses this hint to pause accordingly.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
