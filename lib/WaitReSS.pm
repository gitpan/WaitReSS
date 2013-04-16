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

package WaitReSS;
{
  $WaitReSS::VERSION = '0.004';
}
# ABSTRACT: A server-side RSS aggregator


1;

__END__

=pod

=head1 NAME

WaitReSS - A server-side RSS aggregator

=head1 VERSION

version 0.004

=head1 DESCRIPTION

L<WaitReSS> is a server-side RSS feeds aggregator. It allows oneself to
host its feeds aggregator without depend on the cloud - which, as Google
Reader closure reminds us, is a simple question of common sense.

Its advantages over Tiny Tiny RSS or other PHP soft like it is that it
doesn't require a full blown MySQL database available.

=head1 SEE ALSO

You can find more information on this module at:

=over 4

=item * Search CPAN

L<http://search.cpan.org/dist/WaitReSS>

=item * See open / report bugs

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WaitReSS>

=item * Git repository

L<http://github.com/jquelin/waitress>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WaitReSS>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WaitReSS>

=back

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
