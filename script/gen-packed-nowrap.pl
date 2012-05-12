#!/usr/bin/env perl

use strict;
use warnings;

my $script = "script/nowrap.pl";
my $packed_script = "nowrap";
my $fatpack = "fatpack";

system "$fatpack trace $script";
system "$fatpack packlists-for `cat fatpacker.trace` >packlists";
system "$fatpack tree `cat packlists`";
my $packed_lib = scalar `$fatpack file`;

open SCRIPT, '<', $script;
open PACKED_SCRIPT, '>', $packed_script;
while (my $line = <SCRIPT>) {
    $line =~ s/.*__FATPACK__.*/$packed_lib/;
    print PACKED_SCRIPT $line;
}
close PACKED_SCRIPT;
close SCRIPT;
system "chmod +x $packed_script";

system "rm -f fatpacker.trace packlists"
