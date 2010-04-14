use 5.008;
use strict;
use warnings;

package DB::Pluggable::TypeAhead;
BEGIN {
  $DB::Pluggable::TypeAhead::VERSION = '1.101050';
}
# ABSTRACT: Debugger plugin to add type-ahead
use DB::Pluggable::Constants ':all';
use base 'Hook::Modular::Plugin';

sub register {
    my ($self, $context) = @_;
    $context->register_hook($self, 'db.afterinit' => $self->can('afterinit'),);
}

sub afterinit {
    my $self = shift;
    my $type = $self->conf->{type};
    die "TypeAhead: need 'type' config key\n" unless defined $type;
    die "TypeAhead: 'type' must be an array reference of things to type\n"
      unless ref $type eq 'ARRAY';
    
    if (my $env_key = $self->conf->{ifenv}) {
        return unless $ENV{$env_key};
    }
    no warnings 'once';
    push @DB::typeahead, @$type;
}
1;


__END__
=pod

=for stopwords typeahead afterinit

=for test_synopsis 1;
__END__

=head1 NAME

DB::Pluggable::TypeAhead - Debugger plugin to add type-ahead

=head1 VERSION

version 1.101050

=head1 SYNOPSIS

    $ cat ~/.perldb

    use DB::Pluggable;
    use YAML;

    $DB::PluginHandler = DB::Pluggable->new(config => Load <<EOYAML);
    global:
      log:
        level: error

    plugins:
      - module: TypeAhead
        config:
            type: 
                - '{l'
                - 'c'
        ifenv: DBTYPEAHEAD
    EOYAML

    $DB::PluginHandler->run;

=head1 DESCRIPTION

If you use the debugger a lot, you might find that you enter the same commands
after starting the debugger. For example, suppose that you usually want to
list the next window of lines before the debugger prompt - so you would enter
C<{l> - and that you usually have a breakpoint when running the debugger - so
you would enter C<c>. So you could use a plugin configuration as shown in
the synopsis.

If you want to control whether this typeahead is applied, you can use the
optional C<ifenv> configuration key. If specified, its value is taken to be
the name of an environment variable. When the plugin runs, the typeahead will
only be applied if that environment variable has a true value.

So to continue the example from the synopsis, if you wanted to enable the
typeahead, you would run your program like this:

    DBTYPEAHEAD=1 perl -d ...

The inspiration for this plugin came from Ovid's blog post at
L<http://blogs.perl.org/users/ovid/2010/02/easier-test-debugging.html>.

=head1 METHODS

=head2 register

Registers the hooks.

=head2 afterinit

Hook handler for the C<db.afterinit> hook.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org/Public/Dist/Display.html?Name=DB-Pluggable>.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see
L<http://search.cpan.org/dist/DB-Pluggable/>.

The development version lives at
L<http://github.com/hanekomu/DB-Pluggable/>.
Instead of sending patches, please fork this project using the standard git
and github infrastructure.

=head1 AUTHOR

  Marcel Gruenauer <marcel@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Marcel Gruenauer.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

