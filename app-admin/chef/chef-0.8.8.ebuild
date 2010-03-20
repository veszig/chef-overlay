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

ruby_add_rdepend "dev-ruby/amqp
	>=dev-ruby/bunny-0.6.0
	dev-ruby/erubis
	dev-ruby/extlib
	dev-ruby/json
	>=dev-ruby/mixlib-authentication-1.1.2
	>=dev-ruby/mixlib-cli-1.1.0
	>=dev-ruby/mixlib-config-1.1.0
	>=dev-ruby/mixlib-log-1.1.0
	dev-ruby/moneta
	>=dev-ruby/ohai-0.5.0"

all_ruby_install() {
	all_fakegem_install
	keepdir /etc/chef
	keepdir /var/lib/chef
	keepdir /var/log/chef
	keepdir /var/run/chef
	doinitd "${FILESDIR}/initd/chef-client"
	doconfd "${FILESDIR}/confd/chef-client"
	insinto /etc/chef
	doins "${FILESDIR}/client.rb"
}

pkg_postinst() {
	elog
	elog "You should edit /etc/chef/client.rb before starting the service with"
	elog "/etc/init.d/chef-client start"
	elog
}
