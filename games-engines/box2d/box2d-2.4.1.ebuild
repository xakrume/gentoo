# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="C++ engine for simulating rigid bodies in 2D games"
HOMEPAGE="https://box2d.org/"
SRC_URI="https://github.com/erincatto/Box2D/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-doc/doxygen )"

src_configure() {
	local mycmakeargs=(
		-DBOX2D_BUILD_TESTBED=OFF # bundled libs, broken anyway right now
		-DBOX2D_BUILD_UNIT_TESTS=$(usex test)
		-DBOX2D_BUILD_DOCS=$(usex doc)
	)
	cmake_src_configure
}
