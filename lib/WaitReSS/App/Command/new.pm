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

package WaitReSS::App::Command::new;
{
  $WaitReSS::App::Command::new::VERSION = '0.004';
}
# ABSTRACT: Register a new feed

use WaitReSS::App -command;


# -- public methods

sub description {
"Register a new feed within WaitRess."
}

sub opt_spec {
    my $self = shift;
    return (
        $self->opt_common
    );
}


1;

__END__

=pod

=head1 NAME

WaitReSS::App::Command::new - Register a new feed

=head1 VERSION

version 0.004

=head1 DESCRIPTION

This command registers a new feed within WaitReSS. From now on, the feed
will be updated on a regular basis.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
