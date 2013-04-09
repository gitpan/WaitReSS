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

package WaitReSS::User;
{
  $WaitReSS::User::VERSION = '0.002';
}
# ABSTRACT: A WaitReSS user

use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;
use Path::Tiny;
use YAML::XS        qw{ Load Dump };

use WaitReSS::Logging;
use WaitReSS::Params;


# -- attributes


has login    => ( ro, required, isa=>"Str" );


# the private directory where the feed will store all its data.
has _private_dir => ( ro, lazy_build, isa=>"Path::Tiny" );


# -- initialization

sub _build__private_dir {
    my $self = shift;
    my $dir = $params->dir_users->child( $self->login );
    debug( "private user directory = $dir" );
    $dir->mkpath;
    return $dir;
}


# -- class methods


sub new_from_directory {
    my ($pkg, $dir) = @_;
    my $file = $dir->child( "user.yaml" );
    debug( "loading feed information from $file" );
    my $yaml = $file->slurp_utf8( $file->stringify );
    my $hash = Load( $yaml );
    return $pkg->new( $hash );
}


# -- public methods


sub save {
    my $self = shift;
    my %hash = (
        login => $self->login,
    );
    my $file = $self->_private_dir->child( "user.yaml" );
    debug( "saving user information to $file" );
    $file->spew_utf8( Dump(\%hash) );
}



sub delete {
    my $self = shift;
    $self->_private_dir->remove_tree;
}


# -- private methods

no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

WaitReSS::User - A WaitReSS user

=head1 VERSION

version 0.002

=head1 DESCRIPTION

This class represents a WaitReSS user.

=head1 ATTRIBUTES

=head2 login

The user login. Required, used as unique identifier.

=head1 METHODS

=head2 new_from_directory

    my $user = WaitReSS::User->new_from_directory( $dir );

Return a new L<WaitReSS::User> loaded with information located in
C<$dir> (a L<Path::Tiny> object).

=head2 save

    $user->save;

Save the user main information to be retrieved later on.

=head2 delete

Delete C<$user> and all its related information. Note that you should
also make sure L<WaitReSS::Users> is correctly updated.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
