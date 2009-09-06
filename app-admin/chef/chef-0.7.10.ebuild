# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gems

USE_RUBY="ruby18"

DESCRIPTION="A systems integration framework, built to bring the benefits of configuration..."
HOMEPAGE="http://wiki.opscode.com/display/chef"
SRC_URI="http://gems.opscode.com/gems/${P}.gem"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-ruby/erubis
	dev-ruby/extlib
	dev-ruby/json
	dev-ruby/mixlib-cli
	>=dev-ruby/mixlib-config-1.0.12
	dev-ruby/mixlib-log
	dev-ruby/ohai
	dev-ruby/ruby-openid
	dev-ruby/stomp"

pkg_setup() {
	enewgroup chef
	enewuser chef -1 -1 /var/lib/chef chef
}

src_install() {
	gems_src_install
	doinitd "${FILESDIR}/initd/chef"
	keepdir /etc/chef
	insinto /etc/chef
	doins "${FILESDIR}/client.rb"
	fowners -R chef:chef /etc/chef
	keepdir /var/lib/chef
	keepdir /var/log/chef
	keepdir /var/run/chef
	fowners -R chef:chef /var/{lib,log,run}/chef
}

pkg_postinst() {
	elog
	elog "You should edit /etc/chef/client.rb before starting the service with"
	elog "/etc/init.d/chef start"
	elog
}
