package Log::Dispatch::Handle;

use strict;
use warnings;

our $VERSION = '2.51';

use Log::Dispatch::Output;

use base qw( Log::Dispatch::Output );

use Params::Validate qw(validate SCALAR ARRAYREF BOOLEAN);
Params::Validate::validation_options( allow_extra => 1 );

sub new {
    my $proto = shift;
    my $class = ref $proto || $proto;

    my %p = validate( @_, { handle => { can => 'print' } } );

    my $self = bless {}, $class;

    $self->_basic_init(%p);
    $self->{handle} = $p{handle};

    return $self;
}

sub log_message {
    my $self = shift;
    my %p    = @_;

    $self->{handle}->print( $p{message} )
        or die "Cannot write to handle: $!";
}

1;

# ABSTRACT: Object for logging to IO::Handle classes

__END__

=for Pod::Coverage new log_message

=head1 SYNOPSIS

  use Log::Dispatch;

  my $log = Log::Dispatch->new(
      outputs => [
          [
              'Handle',
              min_level => 'emerg',
              handle    => $io_socket_object,
          ],
      ]
  );

  $log->emerg('I am the Lizard King!');

=head1 DESCRIPTION

This module supplies a very simple object for logging to some sort of
handle object. Basically, anything that implements a C<print()>
method can be passed the object constructor and it should work.

=head1 CONSTRUCTOR

The constructor takes the following parameters in addition to the standard
parameters documented in L<Log::Dispatch::Output>:

=over 4

=item * handle ($)

The handle object. This object must implement a C<print()> method.

=back

=cut
