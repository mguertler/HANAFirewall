#!/usr/bin/perl
#
# Little setup script, that creates 
# SUSE Firewall2 service files for a SAP HANA firewall
# by Markus Guertler @ SUSE
#
# GPL
#

use strict;
use warnings;

my $hana_firewall_d_dir = '../sysconfig/hana_firewall.d';

# Write service files
&write_service_files(&service_definitions);

sub service_definitions
{
my %services;	

$services{hana_database_client}=<<EOF;
## Name: HANA Database Client Access
## Description: (see SAP HANA Master Guide)
## Open ports for Application servers that use 
## SAP HANA as a database

# space separated list of allowed TCP ports
# xx = HANA Instance
# TCP="3xx15 3xx16"
TCP="3__INST_NUM__15 3__INST_NUM__17"
EOF

$services{hana_data_provisioning}=<<EOF;
## Name: HANA Data Provisioning
## Description: (see SAP HANA Master Guide)
## This connection is used for event streaming.
## The protocol is SQLDBC (ODBC/JDBC).

# space separated list of allowed TCP ports
# xx = HANA Instance
# TCP="3xx15 3xx17"
TCP="3__INST_NUM__15 3__INST_NUM__17"
EOF

$services{hana_http_client_access}=<<EOF;
## Name: HANA HTTP Client Access
## Description: (see SAP HANA Master Guide)
## Open ports for web browser client access to SAP HANA

# space separated list of allowed TCP ports
# xx = HANA Instance
# TCP="80xx 43xx"
TCP="80__INST_NUM__ 43__INST_NUM__"
EOF

$services{hana_sap_support}=<<EOF;
## Name: HANA SAP support
## Description: (see SAP HANA Master Guide)
## The connection is not active by default because it is required only in
## certain support cases. To find out how to open a support connection,
## see the SAP HANA Administration Guide

# space separated list of allowed TCP ports
# xx = HANA Instance
# TCP="3xx09"
TCP="3__INST_NUM__09"
EOF

$services{hana_studio}=<<EOF;
## Name: SAP HANA studio
## Description: (see SAP HANA Master Guide)
## "The connection to the instance agent acts as an administrative
## channel for low-level access to the SAP HANA instance to allow
## features such as starting or stopping of the SAP HANA database.
## The protocol used for this connection is SQLDBC (ODBC/JDBC)."

# space separated list of allowed TCP ports
# xx = HANA Instance
# TCP="5xx13 5xx14"
TCP="5__INST_NUM__13 5__INST_NUM__14"
EOF

$services{hana_studio_lifecycle_manager}=<<EOF;
## Name: SAP HANA studio lifecycle manager
## Description: (see SAP HANA Master Guide)
## "This is the connection to SAP HANA lifecycle manager via SAP Host
## Agent. For more information about SAP HANA lifecycle manager,
## see SAP HANA Update and Configuration Guide.
## The protocol used for this connection is SQLDBC (ODBC/JDBC)."

# space separated list of allowed TCP ports
# xx = HANA Instance
# TCP="1128 1129"
TCP="1128 1129"
EOF

$services{hana_distributed_systems}=<<EOF;
## Name: HANA Distributed Systems
## Description: (see SAP HANA Master Guide)
## Distributed scenarios
## Internal network communication takes place between the 
## hosts of a distributed system on one site. Certified
## SAP HANA hosts contain a separate network interface 
## card that is configured as part of a private network,
## using separate IP addresses and ports.
## 

# space separated list of allowed TCP ports
# xx = HANA Instance
# TCP="3xx00 3xx01 3xx02 3xx03 3xx04 3xx05 3xx07 3xx10 3xx40:3xx99"
TCP="3__INST_NUM__00 3__INST_NUM__01 3__INST_NUM__02 3__INST_NUM__03 3__INST_NUM__04 3__INST_NUM__05 3__INST_NUM__07 3__INST_NUM__10 3__INST_NUM__40:3__INST_NUM__99"
EOF

$services{hana_system_replication}=<<EOF;
## Name: HANA System Replication
## Description: (see SAP HANA Master Guide)
## Distributed scenarios
## Internal network communication takes place between the 
## hosts of a distributed system on one site. Certified
## SAP HANA hosts contain a separate network interface 
## card that is configured as part of a private network,
## using separate IP addresses and ports.
## 

# space separated list of allowed TCP ports
# xx = HANA Instance
# xy = HANA Instance number plus 1
# TCP="3xy01 3xy02 3xy03 3xy04 3xy05 3xy07 3xy40:3xy99"
TCP="3__INST_NUM+1__01 3__INST_NUM+1__02 3__INST_NUM+1__03 3__INST_NUM+1__04 3__INST_NUM+1__05 3__INST_NUM+1__07 3__INST_NUM+1__40:3__INST_NUM+1__99"
EOF

return (\%services);
}

# Write service files to disk
sub write_service_files
{
	my $services_ptr = shift;
	
	print "\nWriting firewall service files:\n";
	
	foreach my $service (keys %$services_ptr)
	{
		
		my $filename = $hana_firewall_d_dir."/".uc($service);
		print " -> $filename\n";
		open SERVICE, ">$filename" or die "Couldn't open file $filename for writing!";
		print SERVICE $services_ptr->{$service};
		close SERVICE;
	}
}
