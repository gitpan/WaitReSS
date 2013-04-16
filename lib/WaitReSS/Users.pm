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

package WaitReSS::Users;
{
  $WaitReSS::Users::VERSION = '0.003';
}
# ABSTRACT: List of users

use Exporter::Lite;
use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;
use Path::Tiny;
use YAML::XS qw{ Load Dump };

use WaitReSS::Logging;
use WaitReSS::Params;
use WaitReSS::User;


# -- module vars

our @EXPORT = qw{ $users };
our $users  = __PACKAGE__->new;


# -- attributes

# the list of users
has _users => (
    ro, lazy_build,
    isa     => 'HashRef[WaitReSS::User]',
    traits  => ['Hash'],
    handles => {
        list      => "values",
        by_login  => "get",
        exists    => "exists",
        _delete   => "delete",
        _register => "set",
    },
);


# -- initialization

sub _build__users {
    my $self = shift;
    my $dir = $params->dir_users;
    my %users;
    foreach my $path ( $dir->children ) {
        my $user = WaitReSS::User->new_from_directory( $path );
        $users{ $user->login } = $user;
    }
    return \%users;
}


# -- public methods


# implemented in _users attribute



# implemented in _users attribute



# implemented in _users attribute



sub register {
    my ($self, $login) = @_;
    debug( "registering new user $login" );

    if ( $self->exists($login) ) {
        error( "$login is already registered" );
        return $self->by_login($login);
    }

    #
    info( "creating new user $login" );
    my $user = WaitReSS::User->new( login => $login );
    $user->save;
    $self->_register( $login => $user );
    return $user;
}



sub delete {
    my ($self, $login) = @_;

    if ( ! $self->exists($login) ) {
        error( "$login doesn't exist" );
        return;
    }

    #
    info( "deleting user $login" );
    my $user = $self->by_login( $login );
    $user->delete;
    $self->_delete( $login );
}

# --

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

WaitReSS::Users - List of users

=head1 VERSION

version 0.003

=head1 SYNOPSIS

    use WaitReSS::Users;
    # $users is automatically available
    my $user = $users->by_login( $login );

=head1 DESCRIPTION

This class implements a collection of users.

=head1 METHODS

=head2 list

    my @users = $users->list;

Return the list of users (L<WaitReSS::User> objects) currently existing
within WaitReSS.

=head2 exists

    my $bool = $users->exists( $login );

Return true if C<$login> already exists.

=head2 by_login

    my $user = $users->by_login( $login );

Return the C<WaitReSS::User> object matching C<$login> if it exists.

=head2 register

    $users->register( $login );

Register C<$login> in the C<$users> list if it doesn't already exist.

=head2 delete

    $users->delete( $login );

Delete C<$login> from WaitReSS with all its related information.

=head1 AUTHOR

Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
