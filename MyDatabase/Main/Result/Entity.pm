package MyDatabase::Main::Result::Entity;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('entity');
__PACKAGE__->add_columns(qw/entity_id name/);
__PACKAGE__->set_primary_key('entity_id');
 
1;
