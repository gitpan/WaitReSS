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

package WaitReSS::Collection;
{
  $WaitReSS::Collection::VERSION = '0.001';
}
# ABSTRACT: Collection of feeds

use MooseX::Singleton;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;
use Path::Tiny;
use YAML::XS qw{ Load Dump };

use WaitReSS::Logging;
use WaitReSS::Params;


# -- attributes


# the list of feeds
has _feeds => (
    ro, lazy_build,
    isa     => 'HashRef[WaitReSS::Feed]',
    traits  => ['Hash'],
    handles => {
        feeds       => 'values',
        _register   => 'set',
        _has_feed  => 'exists',
    },
);


# -- initialization

sub _build__feeds {
    my $self = shift;
    my $dir = WaitReSS::Params->new->dir_feeds;
    my %feeds;
    foreach my $path ( $dir->children ) {
        my $feed = WaitReSS::Feed->new_from_directory( $path );
        $feeds{ $feed->id } = $feed;
    }
    return \%feeds;
}


# -- public methods



sub register {
    my ($self, $url) = @_;
    info( "registering new feed: $url" );

    my $feed = $self->_feed_by_url( $url );
    if ( defined $feed ) {
        info( "$url is already registered" );
        return $feed;
    }

    #
    debug( "creating new feed" );
    $feed = WaitReSS::Feed->new( url => $url );
    $feed->save;
    return $feed;
}


# --

#
# my $feed = $coll->_feed_by_url( $url );
#
# Return the C<$feed> pointing to C<$url> if it exists.
#
sub _feed_by_url {
    my ($self, $url) = @_;
    foreach my $feed ( $self->feeds ) {
        next if $feed->url ne $url;
        return $feed;
    }
    return;
}



no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

WaitReSS::Collection - Collection of feeds

=head1 VERSION

version 0.001

=head1 DESCRIPTION

This class implements a collection of feeds. This list of feeds is
unordered wrt the user classification.

The collection is implemented as a singleton, which loads the list of
feeds at build time.

=head1 METHODS

=head2 feeds

    my @feeds = $collection->feeds;

Return the list of feeds (L<WaitReSS::Feed> objects) currently existing
within WaitReSS.

=head2 register

    $collection->register( $url );

Register C<$url> in the C<$collection> of feeds if it doesn't already
exist.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
