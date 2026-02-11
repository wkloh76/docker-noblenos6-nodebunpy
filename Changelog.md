# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
