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

package WaitReSS::App::Command::show;
{
  $WaitReSS::App::Command::show::VERSION = '0.004';
}
# ABSTRACT: Show a given user's feeds

use WaitReSS::App -command;


# -- public methods

sub description {
"Show a given user's feeds."
}

sub opt_spec {
    my $self = shift;
    return (
        $self->opt_common,
        [ "user|u=s", "the user whose feeds to show" ],
    );
}


1;

__END__

=pod

=head1 NAME

WaitReSS::App::Command::show - Show a given user's feeds

=head1 VERSION

version 0.004

=head1 DESCRIPTION

This command allows to show a given user's feeds.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
