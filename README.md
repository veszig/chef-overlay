## chef-overlay

Portage overlay for [Chef][0].

This is a work in progress, please submit patches or pull requests.

The `net-misc/rabbitmq-server` ebuild comes from [Kenneth Kalmer's portage 
overlay][1]. The config files are from the [Opscode debian packages][2].

### Setup

To use this overlay, pull it down via GIT or download the [tarball][3] and add
it to `PORTDIR_OVERLAY` in your `make.conf`. You will probably need to add
some `package.keywords` for the various packages to be able to install them
([hint][4]).

[Currently][5] merb packages depend on the `json_pure` gem and the Opscode
gems on `json`. These two have conflicting files so you'll need to add
some files to `COLLISION_IGNORE` in your `make.conf`.

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
    # for dev-ruby/json and dev-ruby/json_pure
    COLLISION_IGNORE="${COLLISION_IGNORE} /usr/bin/prettify_json.rb /usr/bin/edit_json.rb"
    # for app-admin/chef* and dependencies
    PORTDIR_OVERLAY="${PORTDIR_OVERLAY} /usr/local/chef-overlay"
    EOF

    mkdir -p /etc/portage/package.keywords
    # chef-client and dependencies
    wget -q -O /etc/portage/package.keywords/chef \
      http://gist.github.com/raw/332188/581a1bcda07f2fb544055e5ed420e8e697d30a33/package.keywords.chef
    # chef-server and dependencies
    wget -q -O /etc/portage/package.keywords/chef-server \
      http://gist.github.com/raw/332188/38789fa949440681faa5561c7819846dea2226a8/package.keywords.chef-server

[0]: http://wiki.opscode.com/display/chef
[1]: http://github.com/kennethkalmer/portage-overlay/tree/master/net-misc/rabbitmq-server/
[2]: http://github.com/opscode/opscode-packages/tree/master/debian/chef/debian/etc/chef/
[3]: http://github.com/veszig/chef-overlay/tarball/master
[4]: http://gist.github.com/332188
[5]: http://tickets.opscode.com/browse/OHAI-95

### Client

Setting up a client is pretty straightforward:

    emerge chef

You may start using `chef-solo` or edit `/etc/chef/client.rb` (at least edit
`chef_server_url`) and start the client with it's init script.

    rc-update add chef-client default
    /etc/init.d/chef-client start

You will need to create the client in the server and copy it's cert to
`/etc/chef/client.pem` or copy the server's `validation.pem` to `/etc/chef` and
let the client register itself.

### Server

The server part is a bit more work:

    emerge chef-server

This will install [CouchDB][6] and [RabbitMQ][7] but you still need to create
a RabbitMQ `vhost` and `user` for Chef:

    /etc/init.d/rabbitmq start
    AMQP_PASS=$(dd if=/dev/urandom count=50 2>/dev/null | md5sum | awk '{print $1}')
    rabbitmqctl add_vhost /chef
    rabbitmqctl add_user chef ${AMQP_PASS}
    rabbitmqctl set_permissions -p /chef chef ".*" ".*" ".*"
    echo "amqp_pass '${AMQP_PASS}'" >> /etc/chef/server.rb
    echo "amqp_pass '${AMQP_PASS}'" >> /etc/chef/solr.rb

Start the server:

    rc-update add chef-server default
    /etc/init.d/chef-server start

You should be able to connect to port `4000` and get a nice `401 Unauthorized`
error from merb (congratulations!).

If you let the client create `client.pem`, the key will be only readable to
`root`. Chef-solr needs read permissions on the client key and runs as
`chef:chef`:

    chgrp chef /etc/chef/client.pem && chmod g+r /etc/chef/client.pem

You can now [start][8] using Chef-server with [knife][9] or install the web
interface:

    emerge chef-server-webui

Edit `web_ui_admin_default_password` in `/etc/chef/webui.rb` and start it:

    rc-update add chef-server-webui default
    /etc/init.d/chef-server-webui start

You can connect to port `4040` and log in with user `admin`.

[6]: http://couchdb.apache.org/
[7]: http://www.rabbitmq.com/
[8]: http://gist.github.com/354196
[9]: http://wiki.opscode.com/display/chef/Knife

### TODO

- install man pages
- syslog use flag
- logrotate use flag
