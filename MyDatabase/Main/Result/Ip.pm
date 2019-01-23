package MyDatabase::Main::Result::Ip;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('ip');
__PACKAGE__->add_columns(qw/ip_id ip/);
__PACKAGE__->set_primary_key('ip_id');
 
1;
