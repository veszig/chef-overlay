# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/rabbitmq-server/rabbitmq-server-1.5.4-r2.ebuild,v 1.1 2009/06/21 15:45:19 caleb Exp $

inherit eutils

DESCRIPTION="RabbitMQ is a high-performance AMQP-compliant message broker written in Erlang."
HOMEPAGE="http://www.rabbitmq.com/"
SRC_URI="http://www.rabbitmq.com/releases/rabbitmq-server/v${PV}/rabbitmq-server-${PV}.tar.gz"
LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Q: is RDEPEND-only sufficient for a binary package, since we don't compile?
DEPEND="dev-lang/erlang
	dev-python/simplejson"
RDEPEND="${DEPEND}"

src_install() {
	# erlang module
	local targetdir="/usr/$(get_libdir)/erlang/lib/${P}"

	einfo "Correcting additional Erlang code path in scripts"
	sed -i -e "s:\`dirname \$0\`\/..\/ebin:${targetdir}:g" scripts/* || die "sed failed"

	einfo "Installing Erlang module to ${targetdir}"
	dodir "${targetdir}"
	cp -dpR ebin include "${D}/${targetdir}"

	einfo "Installing server scripts to /usr/sbin"
	# Install server scripts to sbin
	dosbin scripts/rabbitmq-multi scripts/rabbitmq-server scripts/rabbitmq-env scripts/rabbitmq-activate-plugins scripts/rabbitmq-deactivate-plugins

	einfo "Installing rabbitmqctl to /usr/bin"
	# Install control script to bin
	dobin scripts/rabbitmqctl

	dosym /usr/sbin/rabbitmq-env /usr/bin/rabbitmq-env

	# Docs
	dodoc README

	# create the directory where our log file will go.
	diropts -m 0770 -o rabbitmq -g rabbitmq
	keepdir /var/log/rabbitmq

	# create the mnesia directory
	diropts -m 0770 -o rabbitmq -g rabbitmq
	dodir /var/lib/rabbitmq/mnesia

	# Install the init script
	newinitd "${FILESDIR}"/rabbitmq-server.init rabbitmq
}

pkg_setup() {
	enewgroup rabbitmq
	enewuser rabbitmq -1 -1 -1 rabbitmq
}
