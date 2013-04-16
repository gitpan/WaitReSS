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

package WaitReSS::App::Command::import;
{
  $WaitReSS::App::Command::import::VERSION = '0.003';
}
# ABSTRACT: Import feeds from OPML file

use WaitReSS::App -command;


# -- public methods

sub description {
"Import some feeds from OPML file"
}

sub opt_spec {
    my $self = shift;
    return (
        $self->opt_common,
        [ "user|u=s", "the user importing feeds" ],
    );
}


1;

__END__

=pod

=head1 NAME

WaitReSS::App::Command::import - Import feeds from OPML file

=head1 VERSION

version 0.003

=head1 DESCRIPTION

This command force an update of all registered feeds within WaitReSS.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
