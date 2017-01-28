#!/usr/bin/env perl

use strict;
use warnings;

# azureus html webui url
my $url = 'http://server:6886';
# interval to refresh torrent info in seconds
my $interval = 5;
# temporary file to save torrent data into
my $temp = '/tmp/current_torrent';

sub get_torrent {
    open(PS,"curl -s \"$url\" |") or die "couldn't get torrent data";
    open(WD,">$temp") or die "can't write into temporary file";
    print WD time()."\n";

    my $i = 0;
    while(<PS>){
        if(m/<\/span>/){ 
            $i = 0;
        }
        if($i){
            if(m/down/){
                if(m/\s*(.*B\/s)\s*\[/){
                    print WD "$1\n";
                }
            }
            if(m/up/){
                if(m/\((.*B\/s)\)/){
                    print WD "$1\n";
                }
            }
        }
        if(m/class\=totals/){ 
            $i = 1;
        }
    }

    close(WD);
    close(PS);
}

if(!open(WD,$temp)){
    get_torrent;
    open(WD,$temp) or die "can't open weather temporary data";
}

my $t = int(<WD>);

if((time()-$t) >= $interval){
    close(WD);
    get_torrent;
    open(WD,$temp);        
    $t = int(<WD>);
}

my $down = <WD>;
chomp $down;
my $up = <WD>;
chomp $up;

print "Vuze:↓$down ↑$up";

close(WD);

