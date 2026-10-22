# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2026-07-03

### Summary

- Security release for CVE-2026-111497 (Node.js Brotli decoder out-of-bounds write, HIGH). Node.js is pinned to the patched v24.22.1.

### Added

- Upgrade bun.js version to 1.3.14 and nodejs version 24.18.0. Completed on 2026-07-03
- Add `lsiown` script instead downloand from linuxserver.io due to github not found issue. Completed on 2026-07-09
- Upgrade nodejs version to 24.22.1 and bun.js version to 1.4.3. Completed on 2026-10-22

### Changed

### Deprecated

### Removed

### Fixed

### Security

- CVE-2026-111497 - Node.js Brotli decoder out-of-bounds write permits remote code execution (HIGH). Affects Node.js 26.x, 24.x and 22.x; fixed for the 24.x line in Node.js v24.22.1 (2026-10-21). `.env.example` now sets `TAG=24.22.1`, so images built from the previous `24.18.0` tag must be rebuilt — the patch is in the Node.js binary and cannot be applied by restarting a running container.
- Exposure is runtime-level: no code in this repo calls the Brotli decoder, so the risk comes from the application mounted at `/app` and its dependencies, for example `zlib.brotliDecompress*` or an outbound request that negotiates `accept-encoding: br` and decompresses an untrusted response.
- Node.js v24.22.1 also carries the other October 2026 fixes (CVE-2026-105481, CVE-2026-105482, CVE-2026-105483, CVE-2026-106069, CVE-2026-106073, CVE-2026-106074) and dependency updates: c-ares 1.34.9, ca-cert (NSS 3.131.1), OpenSSL 3.5.9, Undici 7.30.1. Bun is not covered by this advisory; the bump to 1.4.3 is a routine version upgrade.

[1.0.2]: https://github.com/wkloh76/docker-noblenos6-nodebunpy/releases/tag/1.0.2

## [1.0.1] - 2025-10-03

### Summary

- Design ubuntu docker images as root only which will able deploy the project in `NodeJS` , `BunJS` or `Python3` design.

### Added

- Upgrade bun.js version to 1.2.23 and nodejs version 24.9.0. Completed on 2025-10-03
- Upgrade bun.js version to 1.3.1 and nodejs version 24.11.0. Completed on 2025-11-05
- Upgrade bun.js version to 1.3.9 and nodejs version 24.13.1. Completed on 2026-02-11
- Add `node-gyp prebuild-install electron-builder @electron/rebuild @electron/packager` modules to global to allow direct call from application. Completed on 2026-02-11

### Changed

### Deprecated

### Removed

- Remove s6 overlay from Dockerfile. Completed on 2025-10-03

### Fixed

### Security

[1.0.1]: https://github.com/wkloh76/docker-noblenos6-nodebunpy/releases/tag/1.0.1

## [1.0.0] - 2025-08-19

### Summary

- Design ubuntu docker images as root which will able deploy the project in `NodeJS` , `BunJS` or `Python3` design.

### Added

- First commit. Completed on 2025-08-19
- Implement pure docker-entrypoint method manage service execution. Completed on 2025-09-11

### Changed

### Deprecated

### Removed

- Remove s6-overlay code. Completed on 2025-09-11

### Fixed

- Fix the environment variable PYVENV no declare. Completed on 2025-08-20

### Security

[1.0.0]: https://github.com/wkloh76/docker-noblenos6-nodebunpy/releases/tag/1.0.0
