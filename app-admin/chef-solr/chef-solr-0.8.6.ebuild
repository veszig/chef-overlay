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

RDEPEND=">=net-misc/rabbitmq-server-1.7.0
	=virtual/jre-1.6.0"

ruby_add_rdepend "=app-admin/chef-0.8.6
	>=dev-ruby/libxml-1.1.3
	>=dev-ruby/uuidtools-2.0.0"

pkg_setup() {
	enewgroup chef
	enewuser chef -1 -1 /var/lib/chef chef
}

all_ruby_prepare() {
	epatch "${FILESDIR}"/${P}-pidfile_option.patch
}

each_ruby_install() {
	each_fakegem_install
	ruby_fakegem_doins -r solr
}

all_ruby_install() {
	all_fakegem_install
	doinitd "${FILESDIR}/initd/chef-solr"
	doinitd "${FILESDIR}/initd/chef-solr-indexer"
	doconfd "${FILESDIR}/confd/chef-solr"
	doconfd "${FILESDIR}/confd/chef-solr-indexer"
	keepdir /etc/chef
	fowners -R chef:chef /etc/chef
	keepdir /var/lib/chef
	keepdir /var/log/chef
	keepdir /var/run/chef
	fowners -R chef:chef /var/{lib,log,run}/chef
}
