# icinga2_list_checks

## Presentation

The script displays ALL the checks inside icinga2.  
The script shows in STDOUT :
- hostname
- servicename
- interpreted commands with plugin and args


## Requirement

- *inside icinga2* : enable the api feature (command : `icinga2 feature enable api`)
- api rest available locally or remotely
- perl

## Tested with

* Perl v5.24.1


## Utilization

```
./icinga2_list_checks.pl [--host <hostname> --login <login>] --password <pass>
                        [--verbose]
```
default hostname : `localhost`

default login : `root`

You can find the password here : `/etc/icinga2/conf.d/api-users.conf`

## Examples


**Example1 :**
```
./icinga2_list_checks.pl --password *************
host01;check_http_80_apache;/usr/lib/nagios/plugins/check_http --IP-address=host01 --port=80
host01;check_aspera_node;/usr/lib/nagios/plugins/check_aspera_node.sh -C snmpcommunity -H host01 -P 9092 -p
host01;check_http_s443_apache;/usr/lib/nagios/plugins/check_http --IP-address=host01 --port=443 --ssl
host1;check_nt_MessageQueuingCounters_Mailbox;/usr/lib/nagios/plugins/check_nt --hostname=host01 -l \\MSExchangeIS Mailbox(_Total)\\Messages Queued for Submission,msexch_tot_msgqueued,c --variable=COUNTER
host02;check_nt_cpu_load;/usr/lib/nagios/plugins/check_nt --hostname=host02 -l 1,80,90,5,80,90,15,80,90 --variable=CPULOAD
host02;check_nt_disk_usage_C;/usr/lib/nagios/plugins/check_nt --hostname=host02 -l C --variable=USEDDISKSPACE
host02;check_nt_disk_usage_E;/usr/lib/nagios/plugins/check_nt --hostname=host02-l E --variable=USEDDISKSPACE
host02;check_nt_disk_usage_H;/usr/lib/nagios/plugins/check_nt --hostname=host02 -l H --variable=USEDDISKSPACE
```

**Example2 (with filter) :**
```
./icinga2_list_checks.pl --password ************* | grep host2
host02;check_nt_cpu_load;/usr/lib/nagios/plugins/check_nt --hostname=host02 -l 1,80,90,5,80,90,15,80,90 --variable=CPULOAD
host02;check_nt_disk_usage_C;/usr/lib/nagios/plugins/check_nt --hostname=host02 -l C --variable=USEDDISKSPACE
host02;check_nt_disk_usage_E;/usr/lib/nagios/plugins/check_nt --hostname=host02-l E --variable=USEDDISKSPACE
host02;check_nt_disk_usage_H;/usr/lib/nagios/plugins/check_nt --hostname=host02 -l H --variable=USEDDISKSPACE
```

## Todo
