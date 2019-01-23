#!/usr/bin/perl
 
use strict;
use warnings;
 
use MyDatabase::Main;
 
my $schema = MyDatabase::Main->connect('dbi:Pg:dbname=ip_pool');
 
my @ips;
my $i = 0;
push @ips, [sprintf('192.168.15.%d', $i)] while ++$i < 255;
$schema->populate('Ip', [
   [qw/ip/],
   @ips,
]);


my @names;
$i = 0;
push @names, [sprintf('Entity_%f', rand(1000))] while $i++ < 1000;
$schema->populate('Entity', [
  [qw/name/],
  @names,
]);
