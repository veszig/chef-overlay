# Chef Client Config File

log_level          :info
log_location       '/var/log/chef/chef-client.log'

interval           3600
splay              300

ssl_verify_mode    :verify_none
registration_url   'https://localhost'
openid_url         'https://localhost:444'
template_url       'https://localhost'
remotefile_url     'https://localhost'
search_url         'https://localhost'
role_url           'https://localhost'

file_store_path    '/var/lib/chef/file_store'
file_cache_path    '/var/lib/chef/cache'

pid_file           '/var/run/chef/chef-client.pid'

Chef::Log::Formatter.show_time = true
