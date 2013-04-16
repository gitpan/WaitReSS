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

package WaitReSS::Feeds;
{
  $WaitReSS::Feeds::VERSION = '0.004';
}
# ABSTRACT: Collection of feeds

use Exporter::Lite;
use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;
use Path::Tiny;
use YAML::XS qw{ Load Dump };

use WaitReSS::Feed;
use WaitReSS::Logging;
use WaitReSS::Params;


# -- module vars

our @EXPORT = qw{ $feeds };
our $feeds  = __PACKAGE__->new;


# -- attributes

# the list of feeds
has _feeds => (
    ro, lazy_build,
    isa     => 'HashRef[WaitReSS::Feed]',
    traits  => ['Hash'],
    handles => {
        list        => 'values',
        by_id       => 'get',
        _register   => 'set',
        _has_feed   => 'exists',
    },
);


# -- initialization

sub _build__feeds {
    my $self = shift;
    my $dir = $params->dir_feeds;
    my %feeds;
    foreach my $path ( $dir->children ) {
        my $feed = WaitReSS::Feed->new_from_directory( $path );
        $feeds{ $feed->id } = $feed;
    }
    return \%feeds;
}


# -- public methods


# defined in _feeds attribute



sub register {
    my ($self, $url) = @_;
    debug( "registering new feed: $url" );

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
    foreach my $feed ( $self->list ) {
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

WaitReSS::Feeds - Collection of feeds

=head1 VERSION

version 0.004

=head1 SYNOPSIS

    use WaitReSS::Feeds;
    # $feeds is automatically available
    my @feeds = $feeds->list;

=head1 DESCRIPTION

This class implements a collection of feeds. This list of feeds is
unordered wrt the user classification.

=head1 METHODS

=head2 list

    my @feeds = $feeds->list;

Return the list of feeds (L<WaitReSS::Feed> objects) currently existing
within WaitReSS.

=head2 register

    my $feed = $collection->register( $url );

Register C<$url> in the C<$collection> of feeds if it doesn't already
exist. Return a L<WaitReSS> feed.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
