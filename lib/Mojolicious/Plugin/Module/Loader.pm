package Mojolicious::Plugin::Module::Loader;
use v5.26;
use warnings;

# ABSTRACT: Automatically load mojolicious namespaces

=encoding UTF-8
 
=head1 NAME
 
Mojolicious::Plugin::Module::Loader - Automatically load mojolicious namespaces
 
=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

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
