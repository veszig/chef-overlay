## chef-overlay

Portage overlay for [chef][0].

Work in progress, please submit patches or pull requests.

The `net-misc/rabbitmq-server` ebuild comes from [Kenneth Kalmer's portage 
overlay][1].

### Setup

To use this overlay, pull it down via GIT and add it to PORTDIR_OVERLAY in your
`make.conf`. You will probably need to add some `package.keywords` for the
various packages to be able to install them ([hint][2]).

[Currently][3] `merb` packages depend on the `json_pure` gem and the Opscode
gems on `json`. These two have conflicting files so you'll need to add
something like this to your make.conf:

    # evil hack
    COLLISION_IGNORE="/usr/bin/prettify_json.rb /usr/bin/edit_json.rb"

[0]: http://wiki.opscode.com/display/chef
[1]: http://github.com/kennethkalmer/portage-overlay/tree/master/net-misc/rabbitmq-server/
[2]: http://gist.github.com/332188
[3]: http://tickets.opscode.com/browse/OHAI-95

### Install

This part needs a bit more polish but I hope you get the idea:

    # client
    emerge chef
    #sed -i 's,^\(127.0.0.1.*\)$,\1 chef,' /etc/hosts
    rc-update add chef-client default
    /etc/init.d/chef-client start
    
    # server
    emerge chef-server chef-server-webui
    
    /etc/init.d/rabbitmq start
    rabbitmqctl add_vhost /chef
    rabbitmqctl add_user chef testing
    rabbitmqctl set_permissions -p /chef chef ".*" ".*" ".*"
    
    rc-update add chef-server default
    rc-update add chef-server-webui default
    
    #FIXME the ebuild should do this
    chown -R chef: /var/{lib,log,run}/chef
    
    /etc/init.d/chef-server start
    /etc/init.d/chef-server-webui start

    #FIXME wtf
    chown chef: /etc/chef/*.pem /var/lib/chef/ca/*.pem

