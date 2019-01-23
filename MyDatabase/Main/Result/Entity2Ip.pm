package MyDatabase::Main::Result::Entity2Ip;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('entity2ip');
__PACKAGE__->add_columns(qw/id entity_id ip_id/);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('entity_id' => 'MyDatabase::Main::Result::Entity');
__PACKAGE__->belongs_to('ip_id' => 'MyDatabase::Main::Result::Ip');
 
1;
