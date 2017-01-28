#!/usr/bin/env perl

use warnings;
use strict;

my $interval = 600;
my $temp = "/tmp/newmail";

sub getnewmails {
    open(WD,">$temp") or die "can't write into temporary file";
    open(PS,"/usr/bin/ssh vubuntu newmail /home/troydm/mail --total |") or die "can't open ps";

    while(<PS>){
        print WD time()."\n";
        print WD $_;
    }

    close(WD);
    close(PS);
}


if(!open(WD,$temp)){
    getnewmails;
    open(WD,$temp) or die "can't open newmail temporary data";
}

my $t = int(<WD>);

if((time()-$t) >= $interval){
    close(WD);
    getnewmails;
    open(WD,$temp);        
    $t = int(<WD>);
}

my $newmails = int(<WD>);

close(WD);

my $symbol = '✉ ';

if($newmails > 0){
    print $newmails." ".$symbol;
}
