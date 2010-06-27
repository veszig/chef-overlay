# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Configuration management tool (meta package)"
HOMEPAGE="http://wiki.opscode.com/display/chef"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-webui"

RDEPEND=">=dev-db/couchdb-0.10.0
	>=net-misc/rabbitmq-server-1.7.0"

ruby_add_rdepend "=app-admin/chef-server-api-${PV}
	=app-admin/chef-solr-${PV}
	webui? ( =app-admin/chef-server-webui-${PV} )"
