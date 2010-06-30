## chef-overlay

Portage overlay for [Chef][chef].

This is a work in progress, please submit patches or pull requests.

The `net-misc/rabbitmq-server` ebuild comes from Kenneth Kalmer's portage
[overlay][kennethkalmer_overlay]. The config files are from the Opscode debian
[packages][opscode_debian_packages].

### Client setup

To use this overlay, pull it down via GIT or download the
[tarball][overlay_tarball] and add it to `PORTDIR_OVERLAY` in your `make.conf`.
You will probably need to add some `package.keywords` for the various packages
to be able to install them.

    # clone the GIT repository
    git clone git://github.com/veszig/chef-overlay.git /usr/local/chef-overlay

    # OR download the tarball
    mkdir /usr/local/chef-overlay && wget -q -O - \
      http://github.com/veszig/chef-overlay/tarball/master | \
      tar xz --strip 1 -C /usr/local/chef-overlay

    # add the overlay to your make.conf
    cat >> /etc/make.conf <<\EOF
    # for virtual/jdk
    ACCEPT_LICENSE="${ACCEPT_LICENSE} dlj-1.1"
    # for app-admin/chef* and dependencies
    PORTDIR_OVERLAY="${PORTDIR_OVERLAY} /usr/local/chef-overlay"
    EOF

    # create /etc/portage/package.keywords directory
    if [ -f /etc/portage/package.keywords ] ; then
      mv /etc/portage/package.keywords /etc/portage/package.keywords_
      mkdir /etc/portage/package.keywords
      mv /etc/portage/package.keywords_ /etc/portage/package.keywords/misc
    elif [ ! -d /etc/portage/package.keywords ] ; then
      mkdir /etc/portage/package.keywords
    fi

    # chef-client and dependencies
    cat >> /etc/portage/package.keywords/chef <<\EOF
    =app-admin/chef-0.9.4
    =dev-ruby/abstract-1.0.0
    =dev-ruby/bunny-0.6.0
    =dev-ruby/erubis-2.6.5
    =dev-ruby/extlib-0.9.15
    =dev-ruby/highline-1.5.2-r1
    =dev-ruby/mime-types-1.16-r2
    =dev-ruby/mixlib-authentication-1.1.2
    =dev-ruby/mixlib-cli-1.2.0
    =dev-ruby/mixlib-config-1.1.2
    =dev-ruby/mixlib-log-1.1.0
    =dev-ruby/moneta-0.6.0
    =dev-ruby/ohai-0.5.6
    =dev-ruby/rest-client-1.5.1
    =dev-ruby/rubygems-1.3.7-r1
    =dev-ruby/systemu-1.2.0
    =dev-ruby/uuidtools-2.1.1-r1
    EOF

Now you should be able to install the Chef client.

    emerge chef

You may start using `chef-solo` or edit `/etc/chef/client.rb` (at least edit
`chef_server_url`) and start the client with it's init script.

    rc-update add chef-client default
    /etc/init.d/chef-client start

You will need to create the client in the server and copy it's cert to
`/etc/chef/client.pem` or copy the server's `validation.pem` to `/etc/chef` and
let the client register itself.

[chef]: http://wiki.opscode.com/display/chef
[kennethkalmer_overlay]: http://github.com/kennethkalmer/portage-overlay/tree/master/net-misc/rabbitmq-server/
[opscode_debian_packages]: http://github.com/opscode/opscode-packages/tree/master/debian/chef/debian/etc/chef/
[overlay_tarball]: http://github.com/veszig/chef-overlay/tarball/master

### Server

The server part is a bit more work:

    # chef-server and dependencies
    cat >> /etc/portage/package.keywords/chef-server <<\EOF
    =app-admin/chef-server-0.9.4
    =app-admin/chef-server-api-0.9.4
    =app-admin/chef-server-webui-0.9.4
    =app-admin/chef-solr-0.9.4
    =dev-ruby/bundler-0.9.26
    =dev-ruby/coderay-0.9.3
    =dev-ruby/daemons-1.0.10-r1
    =dev-ruby/eventmachine-0.12.10-r2
    =dev-ruby/haml-2.2.24
    =dev-ruby/hpricot-0.8.2-r1
    =dev-ruby/libxml-1.1.4
    =dev-ruby/merb-assets-1.1.2
    =dev-ruby/merb-core-1.1.2
    =dev-ruby/merb-haml-1.1.2
    =dev-ruby/merb-helpers-1.1.2
    =dev-ruby/merb-param-protection-1.1.2
    =dev-ruby/merb-slices-1.1.2
    =dev-ruby/rack-1.1.0
    =dev-ruby/rake-0.8.7-r5
    =dev-ruby/rake-compiler-0.7.0-r1
    =dev-ruby/ruby-openid-2.1.7-r1
    =net-misc/rabbitmq-server-1.7.2-r2
    =www-servers/thin-1.2.5-r1
    EOF

    emerge chef-server

This will install [CouchDB][couchdb] and [RabbitMQ][rabbitmq] but you still
need to create a RabbitMQ `vhost` and `user` for Chef:

    /etc/init.d/rabbitmq start
    AMQP_PASS=$(dd if=/dev/urandom count=50 2>/dev/null | md5sum | awk '{print $1}')
    rabbitmqctl add_vhost /chef
    rabbitmqctl add_user chef ${AMQP_PASS}
    rabbitmqctl set_permissions -p /chef chef ".*" ".*" ".*"
    echo "amqp_pass '${AMQP_PASS}'" >> /etc/chef/server.rb
    echo "amqp_pass '${AMQP_PASS}'" >> /etc/chef/solr.rb
    #mkdir -m 0700 ~/private/ && echo ${AMQP_PASS} > ~/private/chef_amqp_pass

Start the server:

    rc-update add chef-server-api default
    /etc/init.d/chef-server-api start

You should be able to connect to port `4000` and get a nice `401 Unauthorized`
error from merb (congratulations!).

You can now [start][knife_101] using Chef-server with [knife][knife] or install
the web interface (if you emerged `chef-server` with the `webui` USE flag, you
already have this installed):

    emerge chef-server-webui

Edit `web_ui_admin_default_password` in `/etc/chef/webui.rb` and start it:

    rc-update add chef-server-webui default
    /etc/init.d/chef-server-webui start

You can connect to port `4040` and log in with user `admin`.

[couchdb]: http://couchdb.apache.org/
[rabbitmq]: http://www.rabbitmq.com/
[knife_101]: http://gist.github.com/354196
[knife]: http://wiki.opscode.com/display/chef/Knife

### Fog

You may also want to install [Fog][fog] a library that knife uses to
[interact][knife_cloud] with cloud providers.

    # fog and dependencies
    cat >> /etc/portage/package.keywords/fog <<\EOF
    =dev-ruby/excon-0.1.2
    =dev-ruby/fog-0.2.0
    =dev-ruby/formatador-0.0.14
    =dev-ruby/hoe-2.6.1
    =dev-ruby/net-ssh-2.0.23
    =dev-ruby/nokogiri-1.4.2
    =dev-ruby/rexical-1.0.4
    =dev-ruby/ruby-hmac-0.4.0
    EOF

    emerge fog

Be aware, that currently `knife` is only able too [bootstrap][knife_bootstrap]
ubuntu cloud servers (if you want to use gentoo servers, you may write your
[custom script][gentoo_chef_rackspace] with fog).

[fog]: http://github.com/geemus/fog
[knife_cloud]: http://wiki.opscode.com/display/chef/Knife#Knife-CloudComputingCommands
[knife_bootstrap]: http://github.com/opscode/chef/blob/master/chef/lib/chef/knife/bootstrap.rb
[gentoo_chef_rackspace]: http://gist.github.com/394812
