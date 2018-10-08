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
#          average values report (ASCII)
#
#======================================================================


my $login="root";
my $pass="484804512a84d5b3";
my $servicefile="/tmp/services.json";
my ($line,$host,$service);
my $command="";
my $flag=0;

my $curlcommand="curl -k -s -u $login:$password  https://localhost:5665/v1/objects/services | python -m json.tool";

#system "$curlcommand > $servicefile";

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
