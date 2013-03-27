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

package WaitReSS::Logging;
{
  $WaitReSS::Logging::VERSION = '0.001';
}
# ABSTRACT: Centralized logging utilities

use DateTime;
use Exporter::Lite;
use Term::ANSIColor qw{ :constants };

our @EXPORT = qw{ debug info error };


# -- public subs


sub debug { _log( "@_" ); }
sub info  { _log( BOLD . "@_" . RESET ); }
sub error { _log( BOLD . RED . "@_" . RESET ); }

sub _log {
    my $now = DateTime->from_epoch( epoch => time() );
    my $ts = $now->hms;
    my $sub = (caller 2)[3]; $sub =~ s/SDLx::GUI/SxG/;
    warn "[$ts] [$sub] @_\n";
}

1;

__END__

=pod

=head1 NAME

WaitReSS::Logging - Centralized logging utilities

=head1 VERSION

version 0.001

=head1 DESCRIPTION

To facilitate debugging, this module provides some functions to log
traces.

=head1 METHODS

=head2 debug

=head2 info

=head2 error

    info( @stuff );
    debug( @stuff );
    error( @stuff );

Output C<@stuff> on C<STDERR> colored depending on the gravity, with a
timestamp and the caller sub. An automatic C<\n> is appended.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
