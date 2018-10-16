#!/usr/bin/perl
#======================================================================
# Auteur : sgaudart@capensis.fr
# Date   : 08/10/2018
# But    : this script provides (from icinga2 server) the list:
#          - hosts
#          - services
#          - interpreted commands (with args)
#          ICINGA2 NEEDED !
#
# INPUT :
#          host group name or hosts file + specific service + [metric + start time & end time]
# OUTPUT :
#          list host + services + interpreted checks (CSV format)
#
#======================================================================

use Getopt::Long;

my $hostname="localhost";
my $login="root";
my $pass="";
my $servicefile="/tmp/services.json";
my ($line,$host,$service);
my $command="";
my $flag=0;

GetOptions (
"host=s" => \$hostname, # string
"login=s" => \$login, # string
"password=s" => \$pass, # string
"verbose" => \$verbose, # flag
"help" => \$help) # flag
or die("Error in command line arguments\n");

###############################
# HELP
###############################

if (($help) || ($pass eq "") || (($login eq "") && ($hostname eq "")))
{
	print"./icinga2_list_checks.pl [--host <hostname> --login <login>] --password <pass>
                         [--verbose]\n";
	exit;
}

my $curlcommand="curl -k -s -u $login:$pass  https://$hostname:5665/v1/objects/services | python -m json.tool";
print "[VERBOSE] curlcommand = $curlcommand\n" if $verbose;
system "$curlcommand > $servicefile";

open (SERVICEFD, "$servicefile") or die "Can't open servicefile : $servicefile\n" ; # reading
while (<SERVICEFD>)
{
	 $line=$_;
	 chomp($line); # delete the carriage return

	 if ($line =~ /^.*\"__name\": \"(.*)!(.*)\",$/)
   {
      $host=$1;
      $service=$2;
   }

   if ($flag eq 1) # we keep the interpreted command
   {
      if ($line =~ /^.*\],$/) { $command=substr $command, 1; print "$host;$service;$command\n"; $command=""; $flag=0; } # end of the command
      if ($line =~ /^.*\"(.*)\".*$/) { $command = $command . " " . $1; } # add line to the command
   }

   if ($line =~ /^.*\"command\": \[$/)
   {
      $flag=1;
   }

}
