# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
abscissa_core-0.5.2
abscissa_derive-0.5.0
addr2line-0.14.1
adler-1.0.2
aho-corasick-0.7.15
ansi_term-0.11.0
ascii-0.9.3
atty-0.2.14
autocfg-1.0.1
backtrace-0.3.57
base64-0.13.0
bitflags-1.2.1
bumpalo-3.6.1
byteorder-1.4.3
bytes-0.5.6
bytes-1.0.1
canonical-path-2.0.2
cargo-edit-0.7.0
cargo-lock-6.0.1
cargo_metadata-0.11.4
cc-1.0.67
cfg-if-0.1.10
cfg-if-1.0.0
chrono-0.4.19
clap-2.33.3
color-backtrace-0.3.0
combine-3.8.1
core-foundation-0.9.1
core-foundation-sys-0.8.2
crates-index-0.16.5
cvss-1.0.1
darling-0.10.2
darling_core-0.10.2
darling_macro-0.10.2
dirs-3.0.2
dirs-sys-0.3.6
either-1.6.1
encoding_rs-0.8.28
env_proxy-0.4.1
error-chain-0.12.4
failure-0.1.8
failure_derive-0.1.8
fixedbitset-0.2.0
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.0.1
fs-err-2.5.0
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-channel-0.3.14
futures-core-0.3.14
futures-io-0.3.14
futures-sink-0.3.14
futures-task-0.3.14
futures-util-0.3.14
generational-arena-0.2.8
getrandom-0.2.2
gimli-0.23.0
git2-0.13.18
glob-0.3.0
gumdrop-0.7.0
gumdrop_derive-0.7.0
h2-0.2.7
hashbrown-0.9.1
heck-0.3.2
hermit-abi-0.1.18
hex-0.4.3
home-0.5.3
http-0.2.4
httparse-1.4.0
http-body-0.3.1
httpdate-0.3.2
humantime-2.1.0
humantime-serde-1.0.1
hyper-0.13.10
hyper-tls-0.4.3
ident_case-1.0.1
idna-0.2.3
indexmap-1.6.2
iovec-0.1.4
ipnet-2.3.0
itoa-0.4.7
jobserver-0.1.22
js-sys-0.3.50
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.93
libgit2-sys-0.12.19+1.1.0
libssh2-sys-0.2.21
libz-sys-1.1.2
linked-hash-map-0.5.4
log-0.4.14
matchers-0.0.1
matches-0.1.8
maybe-uninit-2.0.0
memchr-2.3.4
mime-0.3.16
mime_guess-2.0.3
miniz_oxide-0.4.4
mio-0.6.23
miow-0.2.2
native-tls-0.2.7
net2-0.2.37
num_cpus-1.13.0
num-integer-0.1.44
num-traits-0.2.14
object-0.23.0
once_cell-1.7.2
openssl-0.10.33
openssl-probe-0.1.2
openssl-src-111.15.0+1.1.1k
openssl-sys-0.9.61
owning_ref-0.4.1
percent-encoding-2.1.0
pest-2.1.3
petgraph-0.5.1
pin-project-1.0.7
pin-project-internal-1.0.7
pin-project-lite-0.1.12
pin-project-lite-0.2.6
pin-utils-0.1.0
pkg-config-0.3.19
platforms-1.1.0
ppv-lite86-0.2.10
proc-macro2-1.0.26
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
quote-1.0.9
rand-0.8.3
rand_chacha-0.3.0
rand_core-0.6.2
rand_hc-0.3.0
redox_syscall-0.2.6
redox_users-0.4.0
regex-1.4.6
regex-automata-0.1.9
regex-syntax-0.6.23
remove_dir_all-0.5.3
reqwest-0.10.10
rustc-demangle-0.1.18
rustsec-0.23.3
ryu-1.0.5
schannel-0.1.19
secrecy-0.6.0
security-framework-2.2.0
security-framework-sys-2.2.0
semver-0.10.0
semver-0.11.0
semver-0.9.0
semver-parser-0.10.2
semver-parser-0.7.0
serde-1.0.125
serde_derive-1.0.125
serde_json-1.0.64
serde_urlencoded-0.7.0
signal-hook-0.1.17
signal-hook-registry-1.3.0
slab-0.4.3
smallvec-0.6.14
smartstring-0.2.6
smol_str-0.1.17
socket2-0.3.19
stable_deref_trait-1.2.0
static_assertions-1.1.0
strsim-0.8.0
strsim-0.9.3
structopt-0.3.21
structopt-derive-0.4.14
subprocess-0.2.6
syn-1.0.70
synstructure-0.12.4
tempfile-3.2.0
termcolor-1.1.2
textwrap-0.11.0
thiserror-1.0.24
thiserror-impl-1.0.24
time-0.1.43
tinyvec-1.2.0
tinyvec_macros-0.1.0
tokio-0.2.25
tokio-tls-0.3.1
tokio-util-0.3.1
toml-0.5.8
toml_edit-0.2.0
tower-service-0.3.1
tracing-0.1.25
tracing-attributes-0.1.15
tracing-core-0.1.17
tracing-futures-0.2.5
tracing-log-0.1.2
tracing-subscriber-0.1.6
try-lock-0.2.3
ucd-trie-0.1.3
unicase-2.6.0
unicode-bidi-0.3.5
unicode-normalization-0.1.17
unicode-segmentation-1.7.1
unicode-width-0.1.8
unicode-xid-0.2.1
unreachable-1.0.0
url-2.2.1
vcpkg-0.2.12
vec_map-0.8.2
version_check-0.9.3
void-1.0.2
wait-timeout-0.2.0
want-0.3.0
wasi-0.10.2+wasi-snapshot-preview1
wasm-bindgen-0.2.73
wasm-bindgen-backend-0.2.73
wasm-bindgen-futures-0.4.23
wasm-bindgen-macro-0.2.73
wasm-bindgen-macro-support-0.2.73
wasm-bindgen-shared-0.2.73
web-sys-0.3.50
winapi-0.2.8
winapi-0.3.9
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
winreg-0.7.0
ws2_32-sys-0.2.1
zeroize-1.3.0
"

inherit cargo

DESCRIPTION="Audit Cargo.lock for security vulnerabilities"
HOMEPAGE="https://github.com/rustsec/cargo-audit"
SRC_URI="https://github.com/RustSec/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="fix"

RDEPEND="
	dev-libs/openssl:0=
	dev-libs/libgit2:=
"
DEPEND="${RDEPEND}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

# requires checkout of vuln db/network
RESTRICT="test"

src_configure() {
	local myfeatures=( $(usev fix) )
	cargo_src_configure
}

src_install() {
	cargo_src_install
	einstalldocs
	dodoc audit.toml.example
}
