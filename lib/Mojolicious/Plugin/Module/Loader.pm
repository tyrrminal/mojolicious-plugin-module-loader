package Mojolicious::Plugin::Module::Loader;
use v5.26;
use warnings;

# ABSTRACT: Automatically load mojolicious namespaces

=encoding UTF-8
 
=head1 NAME
 
Mojolicious::Plugin::Module::Loader - Automatically load mojolicious namespaces
 
=head1 SYNOPSIS

    $app->plugin('Module::Loader' => {
      command_namespaces => ['MyApp::Command'],
      plugin_namespaces  => ['MyApp::Plugin']
    });

    # Or
    $app->plugin('Module::Loader');
    ...
    $app->add_command_namespace('Dynamically::Loaded::Module::Command');
    $app->add_plugin_namespace('Dynamically::Loaded::Module::Plugin');

=head1 DESCRIPTION

This module simply adds two mojolicious helpers, L</add_command_namespace> and
L</add_plugin_namespace>, and calls these automatically at registration time
on the contents of the C<command_namespaces> and C<plugin_namespaces> configuration
parameters, respectively.

=head1 METHODS

L<Mojolicious::Plugin::Cron::Scheduler> inherits all methods from 
L<Mojolicious::Plugin> and implements the following new ones

=head2 register( \%config )

Register plugin in L<Mojolicious> application. Accepts a HashRef of parameters
with two supprted keys:

=head4 command_namespaces

ArrayRef of namespaces to automatically call L</add_command_namespace> on

=head4 plugin_namespaces

ArrayRef of namespaces to automatically call L</add_plugin_namespace> on

=head2 add_command_namespace( $str )

Adds the given namespace to the Mojolicious Commands 
L<namespaces|https://metacpan.org/pod/Mojolicious::Commands#namespaces> array. 
Packages inheriting from L<Mojolicious::Command> in these namespaces are loaded
as runnable commands from the mojo entrypoint script.

=head2 add_plugin_namespace( $str )

Searches the given namespace for packages inheriting from L<Mojolicious::Plugin>
and loads them via L<https://metacpan.org/pod/Mojolicious#plugin>

=cut

use Mojo::Base 'Mojolicious::Plugin';
use Module::Find;

use experimental qw(signatures);

sub register($self, $app, $conf) {
  $app->helper(add_command_namespace => sub($c, $ns) {
    push($app->commands->namespaces->@*, $ns);
  });

  $app->helper(add_plugin_namespace => sub($c, $ns) {
    $app->plugin($_) foreach (map { Module::Find::findallmod($_) }  $ns);
  });

  $app->add_command_namespace($_) foreach(($conf->{command_namespaces}//[])->@*);
  $app->add_plugin_namespace($_) foreach(($conf->{plugin_namespaces}//[])->@*);
}

=head1 AUTHOR

Mark Tyrrell C<< <mark@tyrrminal.dev> >>

=head1 LICENSE

Copyright (c) 2024 Mark Tyrrell

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

=cut

1;

__END__
