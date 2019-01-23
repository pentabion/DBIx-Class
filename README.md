# Especially for .masterhost

Nothing interesing inside :)

I skipped full realization in DBIx::Class cuz I never used it before and it will take a lot of time to re-write all the queries in ORM style. So the most important queries supposed to by executed "AS IS".

Field `ips` being added to `entity` allows to reduce amount of queries to find out non-unique IP sets for other entities. This field could be also updated by some stored routines/triggers (I'm *not sure* it's safe enough for production amount of data).

Also a whole piece of code could be moved directly to DB:
`start transaction;
insert into entity2ip (entity_id, ip_id)
select t1.entity_id, t0.ip_id
  from (
    select a.ip_id, a.ip, count(a.ip_id) as total
    from ip a
      left join entity2ip l on a.ip_id=l.ip_id
    group by a.ip_id, a.ip
    order by total, random()
    limit 5) t0,
    (select entity_id from entity order by random() limit 1) t1;

-- transaction will be rolled back in case of non-unique hexstr
update entity
set ips = t0.hexstr
from (
  select entity_id, md5(array_to_string(array_agg(ip_id order by ip_id),':')) as hexstr
  from entity2ip
  where name = @entity_id
  group by entity_id) t0
where entity.entity_id=t0.entity_id;

commit;
`
