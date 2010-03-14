# Chef Client Config File

log_level              :info
log_location           '/var/log/chef/client.log'
ssl_verify_mode        :verify_none
chef_server_url        'http://chef:4000'
#chef_server_url       'https://chef'

validation_client_name 'chef-validator'
validation_key         '/etc/chef/validation.pem'
client_key             '/etc/chef/client.pem'

file_cache_path        '/var/lib/chef/cache'
pid_file               '/var/run/chef/chef-client.pid'

Mixlib::Log::Formatter.show_time = true
