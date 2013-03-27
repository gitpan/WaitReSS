#
# This file is part of WaitReSS
#
# This software is copyright (c) 2013 by Jerome Quelin.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use 5.012;
use strict;
use warnings;

package WaitReSS::Feed;
{
  $WaitReSS::Feed::VERSION = '0.001';
}
# ABSTRACT: A RSS feed

use DateTime::Format::RSS;
use Digest::MD5     qw{ md5_hex };
use Fcntl;
use LWP::Simple     qw{ get };
use MLDBM           qw{ DB_File Storable };
use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;
use Path::Tiny;
use XML::Feed;
use YAML::XS        qw{ Load Dump };

use WaitReSS::Logging;
use WaitReSS::Item;
use WaitReSS::Params;
use WaitReSS::Types;


# -- attributes


has url    => ( ro, required, isa=>"Str" );
has status => ( rw, isa=>"FeedStatus", default=>"uninitialized" );



has title       => ( rw, isa=>"Str" );
has description => ( rw, isa=>"Str" );


# the private directory where the feed will store all its data.
has _private_dir => ( ro, lazy_build, isa=>"Path::Tiny" );

# _items is tied to the mldbm and contains all the rss items.
has _items => (
    ro, lazy_build,
    isa       => "HashRef[WaitReSS::Item]",
    traits    => ['Hash'],
    handles => {
        nb_items     => "count",
        _has_item    => "exists",
        _insert_item => "set",
    },
);



# -- initialization

sub _build__private_dir {
    my $self = shift;
    my $dir = WaitReSS::Params->new->dir_feeds->child( $self->id );
    debug( "private feed directory = $dir" );
    $dir->mkpath;
    return $dir;
}

sub _build__items {
    my $self = shift;
    my %items;
    my $dbfile = $self->_private_dir->child( "items.dbm" );
    debug( "opening $dbfile" );
    tie %items, 'MLDBM', $dbfile, O_CREAT|O_RDWR, 0640 or die $!;
    return \%items;
}


# -- class methods


sub new_from_directory {
    my ($pkg, $dir) = @_;
    my $file = $dir->child( "feed.yaml" );
    debug( "loading feed information from $file" );
    my $yaml = $file->slurp_utf8( $file->stringify );
    my $hash = Load( $yaml );
    return $pkg->new( $hash );
}


# -- public methods


sub as_string {
    my $self = shift;
    my $str  = join " ", $self->id, $self->status, $self->url;
    $str = join(" ", $str, $self->nb_items . " items", $self->title)
        if $self->status eq "ok";
    return $str;
}



sub id {
    my $self = shift;
    return md5_hex( $self->url );
}



# defined in _items attribute



sub save {
    my $self = shift;
    my %hash = (
        url    => $self->url,
        status => $self->status,
    );
    if ( $hash{status} eq "ok" ) {
        $hash{title} = $self->title;
        $hash{description} = $self->description;
    }
    my $file = $self->_private_dir->child( "feed.yaml" );
    debug( "saving feed information to $file" );
    $file->spew_utf8( Dump(\%hash) );
}



sub update {
    my $self = shift;
    info( "updating " . $self->url );

    # downloading url
    my $file = $self->_private_dir->child( "feed.xml" );
    my $ok   = $self->_download( $file );
    return unless $ok;

    # reading downloaded file
    my $content = $file->slurp_utf8;
    my $rss     = XML::Feed->parse( \$content );
    if ( ! defined $rss ) {
        error( "url is not a valid feed" );
        $self->set_status( "not_a_feed" );
        $self->save; # save feed status
        return;
    }

    #
    my $count = $rss->entries;
    debug( "found $count items" );
    my ($existing, $inserted) = (0,0);
    foreach my $i ( $rss->entries ) {
        my $pubdate = $i->issued
            ? $i->issued->epoch
            : time();
        my $item = WaitReSS::Item->new(
            link        => $i->link,
            title       => $i->title // '',
            description => $i->content->body // '',
            pub_date    => $pubdate,
        );
        $existing++, next if $self->_has_item( $item->id );
        debug( "inserting " . $item->link );
        $inserted++;
        $self->_insert_item( $item->id => $item );
    }
    info( "$existing existing items, $inserted new items" );

    # save new feed information
    $self->set_title( $rss->title // "" );
    $self->set_description( $rss->description // "" );
    $self->save;

    return $inserted;
}


# -- private methods

#
#    my $ok = $feed->_download( $file );
#
# Force a download of the feed in C<$file>. Return true if successful.
#
sub _download {
    my ($self, $file) = @_;
    my $url = $self->url;

    debug( "downloading $url" );
    my $ua = LWP::UserAgent->new( agent => "Mozilla/5.0 (X11; Linux x86_64)" );
    my $r  = $ua->get($self->url);

    # check success
    if ( $r->is_success ) {
        debug( "success" );
        $self->set_status( "ok" );
        $file->spew_utf8( $r->decoded_content );
        return 1;
    }

    #
    error( "error downloading $url" );
    $self->set_status( "no_such_url" );
    $self->save; # save feed status
    return;
}


no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

WaitReSS::Feed - A RSS feed

=head1 VERSION

version 0.001

=head1 DESCRIPTION

This class represents a RSS feed.

=head1 ATTRIBUTES

=head2 url

The url (a string) to which the RSS item is pointing to. Required.

=head2 status

The feed status.

=head2 title

The feed title.

=head2 description

The feed description.

=head2 icon

=head1 METHODS

=head2 new_from_directory

    my $feed = WaitReSS::Feed->new_from_directory( $dir );

Return a new L<WaitReSS::Feed> loaded with information located in
C<$dir> (a L<Path::Tiny> object).

=head2 as_string

    my $str = $feed->as_string;

Return a string representation of the feed, with its main information.

=head2 id

    my $md5sum = $feed->id;

Return a md5 sum of the feed url.

=head2 nb_items

    my $count = $feed->nb_items;

Return the C<$count> of items currently in the feed.

=head2 save

    $feed->save;

Save the feed main information to be retrieved later on.

=head2 update

    my $inserted = $feed->update;

Force C<$feed> to download its feed, parse it and store new items.
Return the number of new items stored.

=for Pod::Coverage O_CREAT O_RDWR

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
