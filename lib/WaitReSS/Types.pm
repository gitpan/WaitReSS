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

package WaitReSS::Types;
{
  $WaitReSS::Types::VERSION = '0.001';
}
# ABSTRACT: Types used in the distribution

use Moose::Util::TypeConstraints;
use Path::Tiny;

# feed status
enum "FeedStatus" => qw{ uninitialized ok no_such_url not_a_feed };

# coercion from string to Path::Tiny
class_type 'Path::Tiny';
coerce 'Path::Tiny',
    from 'Str',
    via { path($_) };



1;

__END__

=pod

=head1 NAME

WaitReSS::Types - Types used in the distribution

=head1 VERSION

version 0.001

=head1 DESCRIPTION

This module implements the specific types used by the distribution, and
exports them (exporting is done by L<Moose::Util::TypeConstraints>).

Current types defined:

=over 4

=item * C<FeedStatus> - a simple enumeration, allowing C<uninitialized>,
C<ok>, C<no_such_url> or C<not_a_feed>.

=back

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
