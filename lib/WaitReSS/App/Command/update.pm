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
  $WaitReSS::App::Command::update::VERSION = '0.002';
}
# ABSTRACT: Update feeds

use WaitReSS::App -command;


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


1;

__END__

=pod

=head1 NAME

WaitReSS::App::Command::update - Update feeds

=head1 VERSION

version 0.002

=head1 DESCRIPTION

This command force an update of all registered feeds within WaitReSS.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
