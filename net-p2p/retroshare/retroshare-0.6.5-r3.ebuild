# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop edos2unix qmake-utils xdg-utils

DESCRIPTION="P2P private sharing application"
HOMEPAGE="https://retroshare.cc"
SRC_URI="https://github.com/RetroShare/RetroShare/releases/download/v${PV}/RetroShare-v${PV}-source-with-submodules.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3 Apache-2.0 CC-BY-SA-4.0 GPL-2 GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="autologin +gui +jsonapi +service +sqlcipher"

REQUIRED_USE="
	|| ( gui service )
	service? ( jsonapi )"

RDEPEND="
	app-arch/bzip2
	dev-libs/openssl:0=
	>=dev-libs/rapidjson-1.1.0
	net-libs/miniupnpc:=
	sys-libs/zlib
	autologin? ( app-crypt/libsecret )
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtscript:5
		dev-qt/qtxml:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		x11-libs/libX11
		x11-libs/libXScrnSaver
	)
	service? ( dev-qt/qtcore:5 )
	sqlcipher? ( dev-db/sqlcipher )
	!sqlcipher? ( dev-db/sqlite:3 )"

DEPEND="${RDEPEND}
	dev-qt/qtcore:5
	gui? ( dev-qt/designer:5 )"

BDEPEND="dev-util/cmake
	virtual/pkgconfig
	jsonapi? ( app-doc/doxygen )"

PATCHES=( "${FILESDIR}/${P}-qt-5.15.patch" )

S="${WORKDIR}"/RetroShare

src_prepare() {
	# CRLF endings break patch...
	edos2unix retroshare-gui/src/gui/elastic/elnode.h
	default
}

src_configure() {
	local qConfigs=()

	qConfigs+=( $(usex autologin '' 'no_')rs_autologin )
	qConfigs+=( $(usex gui '' 'no_')retroshare_gui )
	qConfigs+=( $(usex jsonapi '' 'no_')rs_jsonapi )
	qConfigs+=( $(usex service '' 'no_')retroshare_service )
	qConfigs+=( $(usex sqlcipher '' 'no_')sqlcipher )
	qConfigs+=( no_retroshare_nogui )
	qConfigs+=( no_libresapi )
	qConfigs+=( no_libresapi_settings )
	qConfigs+=( no_libresapilocalserver )
	qConfigs+=( no_libresapihttpserver )

	eqmake5 CONFIG+="${qConfigs[*]}" \
		RS_MAJOR_VERSION=$(ver_cut 1) RS_MINOR_VERSION=$(ver_cut 2) \
		RS_MINI_VERSION=$(ver_cut 3) RS_EXTRA_VERSION="-gentoo-${PR}" \
		RS_UPNP_LIB=miniupnpc
}

src_compile() {
	use jsonapi && {
		nonfatal emake ||
			elog "Due to a bug in RetroShare-v0.6.5 build system when JSON API is enabled, failure at first emake is normal"
	}

	emake
}

src_install() {
	use gui && dobin retroshare-gui/src/retroshare
	use service && dobin retroshare-service/src/retroshare-service

	insinto /usr/share/retroshare
	doins libbitdht/src/bitdht/bdboot.txt

	dodoc README.md
	make_desktop_entry retroshare

	for i in 24 48 64 128 ; do
		doicon -s ${i} "data/${i}x${i}/apps/retroshare.png"
	done
}

pkg_pretend() {
	if ! use sqlcipher; then
		ewarn "You have disabled GXS database encryption, ${PN} will use SQLite"
		ewarn "instead of SQLCipher for GXS databases."
		ewarn "Builds using SQLite and builds using SQLCipher have incompatible"
		ewarn "database format, so you will need to manually delete GXS"
		ewarn "database (loosing all your GXS data and identities) when you"
		ewarn "toggle sqlcipher USE flag."
	fi
}

pkg_preinst() {
	local ver
	for ver in ${REPLACING_VERSIONS}; do
		if ver_test ${ver} -lt 0.5.9999; then
			ewarn "You are upgrading from Retroshare 0.5.* to ${PV}"
			ewarn "Version 0.6.* is backward-incompatible with 0.5 branch"
			ewarn "and clients with 0.6.* can not connect to clients that have 0.5.*"
			ewarn "It's recommended to drop all your configuration and either"
			ewarn "generate a new certificate or import existing from a backup"
			break
		fi
		if ver_test ${ver} -ge 0.6.0 && ver_test ${ver} -lt 0.6.4; then
			elog "Main executable has been renamed upstream from RetroShare06 to retroshare"
			break
		fi
	done
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
