# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gems

USE_RUBY="ruby18"

DESCRIPTION="MIME::Types for Ruby originally based on and synchronized with MIME::Types fo..."
HOMEPAGE="http://mime-types.rubyforge.org/"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-ruby/archive-tar-minitar-0.5
	>=dev-ruby/hoe-1.8.3
	>=dev-ruby/nokogiri-1.2
	>=dev-ruby/rcov-0.8"
RDEPEND=""
