# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ADAMK
DIST_VERSION=1.10
inherit perl-module

DESCRIPTION="Extremely light weight SQLite-specific schema migration"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Params-Util-0.370.0
	>=dev-perl/IPC-Run3-0.42.0
	>=virtual/perl-File-Path-2.04
	>=dev-perl/DBD-SQLite-1.210.0
	>=dev-perl/ORLite-1.280.0
	>=dev-perl/File-pushd-1.0.0
	>=dev-perl/Probe-Perl-0.10.0
	>=virtual/perl-File-Spec-3.270.100
	>=dev-perl/File-Which-1.70.0
	>=dev-perl/DBI-1.580.0
"
BDEPEND="${RDEPEND}
"

PATCHES=("${FILESDIR}/${PN}-1.10-dot-in-inc.patch")

DIST_TEST="do" # Parallel tests broken, concurrent DB access
