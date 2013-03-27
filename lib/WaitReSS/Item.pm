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

package WaitReSS::Item;
{
  $WaitReSS::Item::VERSION = '0.001';
}
# ABSTRACT: A RSS item

use Digest::MD5     qw{ md5_hex };
use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;


# -- attributes


has link        => ( ro, required, isa=>"Str" );
has title       => ( ro, required, isa=>"Str" );
has description => ( ro, isa=>"Str" );


# -- public methods


sub id {
    my $self = shift;
    return md5_hex( $self->link );
}



no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

WaitReSS::Item - A RSS item

=head1 VERSION

version 0.001

=head1 DESCRIPTION

This class represents a simple RSS item.

=head1 ATTRIBUTES

=head2 title

The item title. Required.

=head2 link

The url (a string) to which the RSS item is pointing to. Required.

=head2 description

The item description, usually the whole article or a summary.

=head1 METHODS

=head2 id

    my $id = $item->id;

Return a unique identifier for the item. Internally, it's a MD5 sum of
the url pointed by the item.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
