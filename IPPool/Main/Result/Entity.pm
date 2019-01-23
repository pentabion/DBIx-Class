package IPPool::Main::Result::Entity;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('entity');
__PACKAGE__->add_columns(qw/entity_id name ips/);
__PACKAGE__->set_primary_key('entity_id');
__PACKAGE__->has_many(
    inAllLinks => 'IPPool::Main::Result::Entity',
    {
        'foreign.entity_id' => 'self.entity_id',
    }
);
1;
