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

ruby_add_rdepend "<=dev-ruby/json-1.4.2
	<dev-ruby/merb-assets-1.1.0
	<dev-ruby/merb-core-1.1.0
	<dev-ruby/merb-helpers-1.1.0
	<dev-ruby/merb-slices-1.1.0
	www-servers/thin
	dev-ruby/uuidtools"

each_ruby_install() {
	each_fakegem_install
	ruby_fakegem_doins -r app
	ruby_fakegem_doins -r config
	ruby_fakegem_doins -r public
	ruby_fakegem_doins -r stubs
}
