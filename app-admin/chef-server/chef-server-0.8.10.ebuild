# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Configuration management tool"
HOMEPAGE="http://wiki.opscode.com/display/chef"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-db/couchdb-0.10.0
	>=net-misc/rabbitmq-server-1.7.0"

ruby_add_rdepend "=app-admin/chef-server-api-0.8.10
	=app-admin/chef-solr-0.8.10
	=app-admin/chef-0.8.10
	dev-ruby/coderay
	dev-ruby/haml
	dev-ruby/json
	dev-ruby/merb-assets
	dev-ruby/merb-core
	dev-ruby/merb-haml
	dev-ruby/merb-helpers
	dev-ruby/ruby-openid
	www-servers/thin"

pkg_setup() {
	enewgroup chef
	enewuser chef -1 -1 /var/lib/chef chef
}

each_ruby_install() {
	each_fakegem_install
	ruby_fakegem_doins -r app
	ruby_fakegem_doins config-webui.ru
	ruby_fakegem_doins config.ru
	ruby_fakegem_doins -r config
	ruby_fakegem_doins -r public
}

all_ruby_install() {
	all_fakegem_install
	doinitd "${FILESDIR}/initd/chef-server"
	doconfd "${FILESDIR}/confd/chef-server"
	keepdir /etc/chef
	insinto /etc/chef
	doins "${FILESDIR}/server.rb"
	keepdir /etc/chef/certificates
	fperms 0700 /etc/chef/certificates
	fowners chef:chef /etc/chef/{,server.rb,certificates}
	keepdir /var/lib/chef
	keepdir /var/log/chef
	keepdir /var/run/chef
	fowners chef:chef /var/{lib,log,run}/chef
}

pkg_postinst() {
	elog
	elog "You should edit /etc/chef/server.rb before starting the service with"
	elog "/etc/init.d/chef-server start"
	elog
}
