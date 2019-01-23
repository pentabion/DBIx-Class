#!/usr/bin/perl
 
use strict;
use warnings;
 
use IPPool::Main;
use Digest::MD5 qw/md5_hex/;

my $database = 'ip_pool'; 
my $schema = IPPool::Main->connect("dbi:Pg:dbname=$database");


# Drop all entries
$schema->resultset('Entity2Ip')->search()->delete;
$schema->resultset('Entity')->search()->delete;
$schema->resultset('Ip')->search()->delete;

# fill IPs with 253
my @ips;
my $i = 0;
push @ips, [sprintf('192.168.15.%d', $i)] while ++$i < 255;
$schema->populate('Ip', [
   [qw/ip/],
   @ips,
]);

# fill entities with random names
my @names;
$i = 0;
push @names, [sprintf('Entity_%f', rand(1000))] while $i++ < 1000;
$schema->populate('Entity', [
  [qw/name/],
  @names,
]);

$i = 1_000_000;
while($i-- > 0){
  my $random_eids = $schema->resultset('Entity')->find({},
    {
      order   => 'RAND()',
      columns => ['entity_id'],
      rows    => 5;
    });
  
  my $random_ips = $schema->resultset('Ip')->find({},
    {
      order   => 'RAND()',
      columns => ['ip_id'],
      rows    => 1;
    });

  while (my $entity = $random_eids->next) {
  }
}


# here we're filling link table with some random data by SQL
my $random_fill = <<'SQL';
INSERT INTO entity2ip (entity_id, ip_id)
SELECT t1.entity_id, t0.ip_id
  FROM (
    SELECT a.ip_id, count(a.ip_id) AS total
    FROM ip a
      LEFT JOIN entity2ip l ON a.ip_id=l.ip_id
    GROUP BY a.ip_id
    ORDER BY total, RANDOM()
    LIMIT 5) t0,

    (SELECT entity_id
    FROM entity
    ORDER BY random()
    LIMIT 1) t1;
SQL

# here we will fill ips column of entity table
my $fill_with_md5 = <<'SQL';
UPDATE entity
SET ips = t0.hexstr
FROM (
  SELECT entity_id, md5(array_to_string(array_agg(ip_id order by ip_id),':')) as hexstr
  FROM entity2ip
  GROUP BY entity_id) t0
WHERE entity.entity_id=t0.entity_id
SQL


# So normal process starts here:
# 1. Get next 5 ip less used by entities
# 2. Update appropriate entity with new hash first
# 3. Insert into IP's to given entity using link table

# Step 1: Get next 5 ip less used by entities
my $get_next5 = <<'SQL';
SELECT a.ip_id, a.ip, COUNT(a.ip_id) AS total
    FROM ip a
      LEFT JOIN entity2ip l ON a.ip_id=l.ip_id
    GROUP BY a.ip_id, a.ip
    ORDER BY total, random()
    LIMIT 5
SQL

my $fresh5_ips = []; # collect all IPs as array of int from previous request

my $sthRandomEntity = $schema->resultset('Entity')->find({}, {columns => ['entity_id'], rows => 1, order => 'random()'});
my $entity = $sthRandomEntity->next;

# Step 2: Update appropriate entity with new hash first
my $ips_hexstring = md5_hex join(':', sort { $a <=> $b } @fresh5_ips);
$schema->resultset('Entity')->find({entity_id => $entity->{entity_id})->update({ips => $ips_hexstring});


# 3. Insert into IP's to given entity using link table
my @newIPs;
push @newIPs, [$entity->{entity_id}, $_] foreach $fresh5_ips;

$schema->populate('Entity2Ip', [
  [qw/entity_id ip_id/],
  @newIPs,
]);

exit 0;
