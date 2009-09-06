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
RDEPEND="dev-ruby/coderay
	dev-ruby/ruby-ferret
	dev-ruby/haml
	dev-ruby/json
	dev-ruby/merb-assets
	dev-ruby/merb-core
	dev-ruby/merb-haml
	dev-ruby/merb-helpers
	www-servers/mongrel
	dev-ruby/ruby-openid
	dev-ruby/stomp
	dev-ruby/stompserver
	>=app-admin/chef-server-slice-0.7.10"
