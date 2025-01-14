package Thruk::Utils::CLI::Cache;

=head1 NAME

Thruk::Utils::CLI::Cache - Cache CLI module

=head1 DESCRIPTION

The cache handles the internal thruk cache.

=head1 SYNOPSIS

  Usage: thruk [globaloptions] cache <command>

=head1 OPTIONS

=over 4

=item B<help>

    print help and exit

=item B<command>

    Available commands are:

        - dump                  displays the internal cache
        - clean                 drop the internal cache

=back

=cut

use warnings;
use strict;
use Thruk::Utils::Log qw/_error _info _debug _trace/;
use Data::Dumper;

##############################################
# no backends required for this command
our $skip_backends = 1;

##############################################

=head1 METHODS

=head2 cmd

    cmd([ $options ])

=cut
sub cmd {
    my($c, $action, $commandoptions, $data) = @_;
    $c->stats->profile(begin => "_cmd_cache($action)");

    if(!$c->check_user_roles('authorized_for_admin')) {
        return("ERROR - authorized_for_admin role required", 1);
    }

    # cache actions
    my $command = shift @{$commandoptions} || 'help';
    if($command eq 'dump') {
        $data->{'rc'} = 0;
        $data->{'output'} = Dumper($c->cache->dump);
    }
    elsif($command eq 'clear' || $command eq 'clean' || $command eq 'drop') {
        $data->{'rc'} = 0;
        unlink($c->config->{'tmp_path'}.'/thruk.cache');
        $data->{'output'} = "cache cleared\n";
    } else {
        return(Thruk::Utils::CLI::get_submodule_help(__PACKAGE__));
    }

    $c->stats->profile(end => "_cmd_cache($action)");
    return($data);
}

##############################################

=head1 EXAMPLES

Display cache

  %> thruk cache dump

Drop cache

  %> thruk cache clean

=cut

##############################################

1;
