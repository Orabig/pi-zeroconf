#!/usr/bin/perl

use strict;
use warnings;

$\=$/;

my $arg = $ARGV[0] // '';
if ($arg=~/^--?h/) {
	print "Usage : $0 [-d] [-h]";
	print "  -d, --debug : Debug mode (check presence of /tmp/ping file, reduce 60s period to 4s)";
	print "  -h, --help  : This message";
	exit 0;
}

my $IP = '8.8.8.8';

my $debug = $arg=~/^--?d/;

my $period = $debug ? 2 : 60;

my $restart_network_at = 3; # If network is down 3 times, then try to restart

my $reboot_at = 5; # After 5 times, reboot

my $count = 0;

my $wifi = '';

while(1) {
	
	sleep $period;
	
	if ( network_ok() ) {
		print "Network ok";
		$wifi = detect_wifi() unless $wifi;
		$count=0;
		next;
	}
	
	$count++;
	print "Network ko : count=$count";
	
	if ($count==$restart_network_at) {
		print "restart_network";
		restart_network($wifi);
	}

	if ($count==$reboot_at) {
		print "reboot";
		reboot();
	}	
}

sub detect_wifi {
	$_ = qx!ifconfig!;
	return '' unless /^(\w+): flags=.*\W+inet 192.168/m;
	print "Wifi card detected : $1";
	return $1;
}

sub network_ok {
	if ($debug) {
		return -f '/tmp/ping';
	}
	$_ = qx!ping $IP -c 1!;
	return m/ 1 received/;
}

sub restart_network {
	return if $debug;
	qx!ifdown $wifi!;
	sleep 5;
	qx!ifup $wifi!;
	sleep 5;
}

sub reboot {
	return if $debug;
	qx!reboot!;
}
