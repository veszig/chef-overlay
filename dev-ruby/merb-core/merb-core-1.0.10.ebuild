# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gems
USE_RUBY="ruby18"

DESCRIPTION="The core of Merb, a lightweight, fast Ruby MVC framework"
HOMEPAGE="http://merbivore.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-ruby/rubygems-1.3.1"
RDEPEND="
	${DEPEND}
	>=dev-ruby/extlib-0.9.8
	>=dev-ruby/erubis-2.6.2
	dev-ruby/rake
	dev-ruby/json_pure
	dev-ruby/rspec
	dev-ruby/rack
	dev-ruby/mime-types
	>=dev-ruby/thor-0.9.7"

