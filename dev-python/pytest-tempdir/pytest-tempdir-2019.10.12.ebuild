# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Pytest plugin to support for a predictable and repeatable temporary directory"
HOMEPAGE="https://github.com/saltstack/pytest-tempdir"
SRC_URI="https://github.com/saltstack/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

distutils_enable_tests --install pytest
