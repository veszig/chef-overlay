## chef-overlay

Portage overlay for [Chef][0].

This is a work in progress, please submit patches or pull requests.

The `net-misc/rabbitmq-server` ebuild comes from [Kenneth Kalmer's portage 
overlay][1].

### Setup

To use this overlay, pull it down via GIT or download the [tarball][2] and add
it to `PORTDIR_OVERLAY` in your `make.conf`. You will probably need to add
some `package.keywords` for the various packages to be able to install them
([hint][3]).

[Currently][4] merb packages depend on the `json_pure` gem and the Opscode
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
      http://gist.github.com/raw/332188/ddfd73dd910ac3a58cb23b62b2ccba6c7a0ac33a/package.keywords.chef
    # chef-server and dependencies
    wget -q -O /etc/portage/package.keywords/chef-server \
      http://gist.github.com/raw/332188/f6876e76e003a2f19a0b2dc4f9f5f8dc668db81d/package.keywords.chef-server

[0]: http://wiki.opscode.com/display/chef
[1]: http://github.com/kennethkalmer/portage-overlay/tree/master/net-misc/rabbitmq-server/
[2]: http://github.com/veszig/chef-overlay/tarball/master
[3]: http://gist.github.com/332188
[4]: http://tickets.opscode.com/browse/OHAI-95

### Client

Setting up a client is pretty straightforward:

    emerge chef

Now edit `/etc/chef/client.rb` (at least edit `chef_server_url`) and start the
client with it's init script.

    rc-update add chef-client default
    /etc/init.d/chef-client start

You will need to create the client in the server and copy it's cert to
`/etc/chef/client.pem`.

### Server

The server part is a bit more work:

    emerge chef-server

This will install [CouchDB][5] and [RabbitMQ][6] but you still need to create
a RabbitMQ `vhost` and `user` for Chef:

    /etc/init.d/rabbitmq start
    AMQP_PASS=$(dd if=/dev/urandom count=50 2>/dev/null | md5sum | awk '{print $1}')
    rabbitmqctl add_vhost /chef
    rabbitmqctl add_user chef ${AMQP_PASS}
    rabbitmqctl set_permissions -p /chef chef ".*" ".*" ".*"
    echo "amqp_pass '${AMQP_PASS}'" >> /etc/chef/server.rb

Start the server:

    rc-update add chef-server default
    /etc/init.d/chef-server start

You should be able to connect to port `4000` and get a nice `401 Unauthorized`
error from merb (congratulations!).

One problem I encountered was that chef creates the certs with wrong owners.
I'l try to fix the ebuilds to work around this but in the meantime you should
change them by hand:

    chown chef: /etc/chef/{validation,webui}.pem /var/lib/chef/ca/*.pem
    chown root:chef /etc/chef/client.pem
    chmod g+r /etc/chef/client.pem

You can now start using Chef with [knife][7] or install the web interface:

    emerge chef-server-webui

Edit `web_ui_admin_default_password` in `/etc/chef/server.rb` and start it:

    rc-update add chef-server-webui default
    /etc/init.d/chef-server-webui start

You can connect to port `4040` and log in with user `admin`.

[5]: http://couchdb.apache.org/
[6]: http://www.rabbitmq.com/
[7]: http://wiki.opscode.com/display/chef/Knife

### TODO

- find out why are the `pem` files created with `root` as the owner (services
  are dropping privileges to `chef`:`chef`)
- install man pages
