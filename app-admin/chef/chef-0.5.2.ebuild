# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit gems

DESCRIPTION="A systems integration framework written in Ruby"
HOMEPAGE="http://wiki.opscode.com/display/chef/Home"
SRC_URI="http://gems.opscode.com/gems/${P}.gem"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	dev-ruby/json_pure
	dev-ruby/ruby-openid
	dev-ruby/erubis
	dev-ruby/extlib
	dev-ruby/ohai
	dev-ruby/stomp"


