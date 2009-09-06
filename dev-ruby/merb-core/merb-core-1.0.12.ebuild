# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gems

USE_RUBY="ruby18"

DESCRIPTION="Merb. Pocket rocket web framework."
HOMEPAGE="http://merbivore.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-ruby/webrat-0.3.1"
RDEPEND=">=dev-ruby/erubis-2.6.2
	>=dev-ruby/extlib-0.9.8
	dev-ruby/json_pure
	dev-ruby/mime-types
	dev-ruby/rack
	dev-ruby/rake
	dev-ruby/rspec
	>=dev-ruby/thor-0.9.9"
