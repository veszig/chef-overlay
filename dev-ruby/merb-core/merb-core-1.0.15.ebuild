# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Pocket rocket web framework"
HOMEPAGE="http://merbivore.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend ">=dev-ruby/webrat-0.3.1"
ruby_add_rdepend ">=dev-ruby/erubis-2.6.2
	>=dev-ruby/extlib-0.9.8
	dev-ruby/json_pure
	dev-ruby/mime-types
	dev-ruby/rack
	dev-ruby/rake
	dev-ruby/rspec
	>=dev-ruby/thor-0.9.9"
