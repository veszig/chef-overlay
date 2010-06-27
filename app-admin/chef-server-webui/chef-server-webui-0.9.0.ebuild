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

ruby_add_rdepend "dev-ruby/coderay
	dev-ruby/haml
	<=dev-ruby/json-1.4.2
	>=dev-ruby/merb-assets-1.0
	>=dev-ruby/merb-core-1.0
	>=dev-ruby/merb-haml-1.0
	>=dev-ruby/merb-helpers-1.0
	>=dev-ruby/merb-param-protection-1.0
	>=dev-ruby/merb-slices-1.1.0
	dev-ruby/ruby-openid
	www-servers/thin"

pkg_setup() {
	enewgroup chef
	enewuser chef -1 -1 /var/lib/chef chef
}

each_ruby_install() {
	each_fakegem_install
	ruby_fakegem_doins -r app
	ruby_fakegem_doins -r config
	ruby_fakegem_doins config.ru
	ruby_fakegem_doins -r public
}

all_ruby_install() {
	all_fakegem_install
	doinitd "${FILESDIR}/initd/chef-server-webui"
	doconfd "${FILESDIR}/confd/chef-server-webui"
	keepdir /etc/chef
	insinto /etc/chef
	doins "${FILESDIR}/webui.rb"
	fowners chef:chef /etc/chef/{,webui.rb}
	keepdir /var/lib/chef
	keepdir /var/log/chef
	keepdir /var/run/chef
	fowners chef:chef /var/{lib,log,run}/chef
}

pkg_postinst() {
	elog
	elog "You should edit or create /etc/chef/webui.rb before starting the service"
	elog "with /etc/init.d/chef-server-webui start"
	elog
}
