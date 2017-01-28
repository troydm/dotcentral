#!/usr/bin/env perl

use strict;
use warnings;

my %vms = ();

open(PS,'ps -ef | grep VBoxHeadless | grep -v grep |') or die "Couldn't list VBoxHeadless processes: $!";

while(<PS>){
    chomp;
    if(m/(\d+).* --comment (.*) --startvm/){
        my ($vmpid,$vm) = ($1,$2);
        $vms{ $vm } = $vmpid; 
    }
}

close(PS);

if(keys(%vms) > 0){
    my $pidlist = join(',',values %vms);
    open(PRS,"prstat -p $pidlist 1 1 |") or die "Couldn't prstat processes";

    my %vmls = ();

    while(<PRS>){
        chomp;
        if(m/(\d+) .* (\d?\.?\d+%) VBoxHeadless/){
            my ($vmpid,$load) = ($1,$2);
            $vmls { $vmpid } = $load;
        }
    }

    close(PRS);

    print "VM:";
    while(my ($vm,$vmpid) = each %vms){
        print " $vm:$vmls{$vmpid}";
    }
}
