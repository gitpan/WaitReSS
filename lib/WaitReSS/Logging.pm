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
  $WaitReSS::Logging::VERSION = '0.002';
}
# ABSTRACT: Centralized logging utilities

use DateTime;
use Exporter;
use Term::ANSIColor qw{ :constants };

use WaitReSS::Config;

use parent qw{ Exporter };


# -- module vars

our @EXPORT      = qw{ debug info error };
our @EXPORT_OK   = qw{ more_verbose less_verbose enable_pid enable_timestamp enable_trace };
our %EXPORT_TAGS = ( config => \@EXPORT_OK );

my $log_level;
my $do_timestamp;
my $do_trace;
my $do_pidify;
_init();


# -- public subs


sub more_verbose { $log_level++ }
sub less_verbose { $log_level-- }
sub enable_pid       { $do_pidify    = $_[0]; }
sub enable_timestamp { $do_timestamp = $_[0]; }
sub enable_trace     { $do_trace     = $_[0]; }



sub debug {
    return unless $log_level >= 2;
    _log( "@_" );
}
sub info  {
    return unless $log_level >= 1;
    _log( BOLD . "@_" . RESET );
}
sub error {
    return unless $log_level >= 0;
    _log( BOLD . RED . "@_" . RESET );
}


# -- private subs

sub _init {
    # log level
    my $level = $config->get( "log.level" );
    my %level = (
        error   => 0,
        info    => 1,
        debug   => 2,
    );
    $log_level = $level{ $level } // 1;

    # pid
    $do_pidify = $config->get( "log.pid" );

    # timestamp
    $do_timestamp = $config->get( "log.timestamp" );

    # trace
    $do_trace = $config->get( "log.trace" );
}

sub _log {
    my $prefix = "";

    if ( $do_timestamp ) {
        my $now = DateTime->from_epoch( epoch => time() );
        my $ts = $now->hms;
        $prefix .= "[$ts] ";
    }
    if ( $do_pidify ) {
        $prefix .= "[$$] ";
    }
    if ( $do_trace ) {
        my $sub = (caller 2)[3]; $sub =~ s/WaitReSS:://;
        $prefix .= "[$sub] ";
    }
    warn $prefix . "@_\n";
}

1;

__END__

=pod

=head1 NAME

WaitReSS::Logging - Centralized logging utilities

=head1 VERSION

version 0.002

=head1 DESCRIPTION

To facilitate debugging, this module provides some functions to log
traces.

=head1 METHODS

=head2 more_verbose

=head2 less_verbose

    more_verbose();
    less_verbose();

Adjust the logging verbosity.

=head2 enable_pid

    enable_pid( $bool );

Enable or disable the prefixing of pid in logs.

=head2 enable_timestamp

    enable_timestamp( $bool );

Enable or disable the timestamping of logs.

=head2 enable_trace

    enable_trace( $bool );

Enable or disable the tracing of logs.

=head2 debug

=head2 info

=head2 error

    info( @stuff );
    debug( @stuff );
    error( @stuff );

Output C<@stuff> colored depending on the gravity, with a potentially a
timestamp and the caller sub. An automatic C<\n> is appended.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
