package IPPool::Main::Result::Ip;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('ip');
__PACKAGE__->add_columns(qw/ip_id ip/);
__PACKAGE__->set_primary_key('ip_id');
__PACKAGE__->has_many(
    inAllLinks => 'IPPool::Main::Result::Ip',
    {
        'foreign.ip_id' => 'self.ip_id',
    }
);
1;
