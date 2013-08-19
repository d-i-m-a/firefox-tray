#!/usr/bin/perl

# Whitelist firefox's system tray icon into Ubuntu 11.04's Unity Panel

# author: Brian Evans
# license: zlib License

use strict;
use warnings;
use Data::Dumper;

my $current = `gsettings get com.canonical.Unity.Panel systray-whitelist 2>/dev/null`;
die ("Looks like you don't need this script.\n") unless ($current);

# gsettings doesn't exactly return valid perl, but in this case, the array
# looks like a perl array reference
my $result = eval $current;
die ("This does not look right: $current\n") if ($@);
unless (ref($result) && ref($result) eq 'ARRAY') {
die "The returned value is not an array: $current\n";
}

# check each current whitelist to make sure firefox not already in there
foreach (@$result) {
if ($_ eq 'firefox') {
die "firefox is already whitelisted for Unity's panel\n";
}
}

# add whitelist entry for 'firefox' to existing ones
push @$result, 'firefox';

# convert back into string form for array
my $d = Data::Dumper->new([$result], [qw(unitypanel)]);
$d->Terse(1); # just the array ref potion, no perl syntax
$d->Indent(0); # one line, no spaces

if (system('gsettings','set','com.canonical.Unity.Panel','systray-whitelist',$d->Dump) == 0) {
print "firefox has been whitelisted for Unity's panel.\n";
print "Log out and back into your account.\n";
}
else {
die "Unity whitelist unable to be changed\n"
}

