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
  $WaitReSS::App::Command::import::VERSION = '0.001';
}
# ABSTRACT: Import feeds from OPML file

use XML::OPML::LibXML;

use WaitReSS::App -command;
use WaitReSS::Collection;


# -- public methods

sub description {
"Import some feeds from OPML file"
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

    my $file = shift @$args;
    my $opml = XML::OPML::LibXML->new;
    my $doc  = $opml->parse_file($file);

    my $coll = WaitReSS::Collection->new;
    $doc->walkdown( sub {
        my $outline = shift;
        return if $outline->is_container;
        $coll->register( $outline->xml_url );
    } );
}

1;

__END__

=pod

=head1 NAME

WaitReSS::App::Command::import - Import feeds from OPML file

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
