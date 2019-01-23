#!/usr/bin/perl
 
use strict;
use warnings;
 
use IPPool::Main;

my $database = 'ip_pool'; 
my $schema = IPPool::Main->connect("dbi:Pg:dbname=$database");
 
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

# get 5 fresh less allocated IP's
$schema->sea


# select ip_id from ip order by random() limit 5;
# select a.ip_id, count(*) as total from ip a left join entity2ip l on a.ip_id=l.ip_id group by a.ip_id order by total desc limit 5; 
# insert into entity2ip (entity_id, ip_id) select t1.entity_id, t0.ip_id from (select a.ip_id, count(l.ip_id) as total from ip a left join entity2ip l on a.ip_id=l.ip_id group by a.ip_id order by total desc limit 5) t0, (select entity_id from entity where name = 'Entity_131.713656' limit 1) t1
