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

package WaitReSS::App;
{
  $WaitReSS::App::VERSION = '0.003';
}
# ABSTRACT: WaitReSS's App::Cmd

use App::Cmd::Setup -app;

sub allow_any_unambiguous_abbrev { 1 }

1;

__END__

=pod

=head1 NAME

WaitReSS::App - WaitReSS's App::Cmd

=head1 VERSION

version 0.003

=head1 DESCRIPTION

This is the main application, based on the excellent L<App::Cmd>.
Nothing much to see here, see the various subcommands available for more
information, or run one of the following:

    magpie commands
    magpie help

Note that each subcommand can be abbreviated as long as the abbreviation
is unambiguous.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
