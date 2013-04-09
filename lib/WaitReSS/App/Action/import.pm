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

package WaitReSS::App::Action::import;
{
  $WaitReSS::App::Action::import::VERSION = '0.002';
}
# ABSTRACT: Implementation of import command

use XML::OPML::LibXML;

use WaitReSS::App -command;
use WaitReSS::Feeds;


# -- public methods


sub run {
    my ($pkg, $opts, $args) = @_;

    my $file = shift @$args;
    my $opml = XML::OPML::LibXML->new;
    my $doc  = $opml->parse_file($file);

    $doc->walkdown( sub {
        my $outline = shift;
        return if $outline->is_container;
        $feeds->register( $outline->xml_url );
    } );
}


1;

__END__

=pod

=head1 NAME

WaitReSS::App::Action::import - Implementation of import command

=head1 VERSION

version 0.002

=head1 DESCRIPTION

This package implements the C<import> command. It is in a module of its
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
