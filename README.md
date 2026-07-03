# Docker Deploy Noble NodeBunPy

![Static Badge](https://img.shields.io/badge/License-Mulan_PSL_v2-_)
![Static Badge](https://img.shields.io/badge/NodeJS-V24_.18_.0-_)
![Static Badge](https://img.shields.io/badge/BunJS-V1_.3_.14-_)
![Static Badge](https://img.shields.io/badge/ElectronJS-V42_.4_.1-_)
![Static Badge](https://img.shields.io/badge/Python3-Latest-__?style=flat)
![Static Badge](https://img.shields.io/badge/OS-Ubunut_24.04-_?style=flat)

## Overview

A multi-runtime Docker image designed to deploy projects built with **Node.js**, **Bun**, or **Python 3** under root access. The image uses a Ubuntu 24.04 base to support Electron deb packaging with `electron-builder`, and manages services via `docker-entrypoint.sh` instead of s6-overlay.

The primary framework supported is **OricommJS** / **OricommJS_v2**, which renders HTML statements to the browser. Other frameworks may work with minor `docker-compose.yml` adjustments.

## Features

- **Multi-runtime**: Switch between Node.js, Bun, and Python 3 via environment variables
- **Root access**: Designed for deployments requiring root privileges
- **No s6-overlay**: Uses a pure `docker-entrypoint.sh` approach for service management
- **Electron support**: Ubuntu base enables `electron-builder` deb package creation
- **Combined build & deploy**: `docker-compose.yml` handles both image building and container deployment

## Stack

| Component  | Version        |
|------------|----------------|
| Node.js    | v24.18.0       |
| Bun        | v1.3.14        |
| Electron   | v42.4.1        |
| Python 3   | Latest         |
| Base OS    | Ubuntu 24.04   |

## Quick Start

```bash
# 1. Copy environment file
cp .env.example .env

# 2. Build the image
docker compose build

# 3. Deploy the container
docker compose up -d
```

## Environment Variables

### Build Arguments (`.env`)

| Variable | Description                          | Example         |
|----------|--------------------------------------|-----------------|
| `IMG`    | Image name                           | `noblenos6-nodebunpy-deploy` |
| `TAG`    | Node.js version                      | `24.18.0`       |
| `ARG1`   | Bun version                          | `1.3.14`        |

### Runtime Environment Variables

| Variable       | Description                                    | Default            |
|----------------|------------------------------------------------|--------------------|
| `PUID`         | User ID                                        | `1000`             |
| `PGID`         | Group ID                                       | `1000`             |
| `TZ`           | Timezone                                       | `Asia/Kuala_Lumpur`|
| `RUN_MODE`     | `debug` or `production`                        | `debug`            |
| `RUN_ENGINE`   | Runtime engine type                            | `webnodejs`        |
| `USER_NAME`    | Application user                               | `test`             |
| `USER_PASSWORD`| User password                                  | `test1234`         |
| `INTERPRETER`  | Runtime engine: `node`, `bun`, or `python`     | `node`             |
| `MAIN_APP`     | Entry script filename                          | `app.js`           |
| `PYVENV`       | Enable Python virtual environment (`YES`/`NO`) | Disabled           |
| `SYNO`         | Enable Synology-specific node_modules install  | Disabled           |

## Usage Scenarios

### 1. Node.js (Default)

```yaml
nodebun-deploy:
  image: "${IMG}:${TAG}-${ARG1}"
  container_name: nodebun_deploy
  environment:
    - PUID=1000
    - PGID=1000
    - TZ=Asia/Kuala_Lumpur
    - RUN_MODE=debug
    - RUN_ENGINE=webnodejs
    - USER_PASSWORD=test1234
    - USER_NAME=test
  volumes:
    - ./testapp/app:/app
  working_dir: /app
  ports:
    - 9820-9821:3000-3001
  shm_size: "2gb"
  restart: unless-stopped
```

### 2. Bun Runtime

Add `INTERPRETER=bun` and set `PYVENV=NO`:

```yaml
    environment:
      - INTERPRETER=bun
      - PYVENV=NO
```

### 3. Python Runtime

Set `INTERPRETER=python`, specify `MAIN_APP`, and optionally enable virtual environment:

```yaml
    environment:
      - INTERPRETER=python
      - MAIN_APP=app.py
      - PYVENV=YES
```

Ensure your project has a `requirements.txt` file for Python package installation on first run.

## Entrypoint Behavior

`docker-entrypoint.sh` handles:

1. **User setup** — Creates or adjusts the application user with the specified `PUID`/`PGID`
2. **Python venv** — If `PYVENV=YES`, creates a virtual environment and installs packages from `requirements.txt`
3. **Node modules** — Runs `bun install` (or Synology-specific `helper`) if `node_modules` is missing
4. **Script selection** — Chooses `app.js`, `app.js`, or `app.py` based on the `INTERPRETER` setting
5. **Fallback** — If the target script is missing from `/app`, falls back to `/scripts/`

## Notes

- **Build depends on `.env`** — Copy `.env.example` to `.env` before running `docker compose build`. Adjust the values as needed.
- **Default scripts** — If no project code is mounted to `/app`, the container runs the default `app.js` or `app.py` from `/scripts/` based on `INTERPRETER`.
- **Ubuntu base** — Required for `electron-builder` to produce `.deb` packages.

## References

- [LinuxServer.io](https://github.com/linuxserver) — Base image templates and Docker best practices
- [FIGlet](https://labex.io/tutorials/linux-crafting-striking-terminal-text-with-figlet-272383) — Terminal banner generation
- [SSH Warning Banner](https://www.tecmint.com/ssh-warning-banner-linux/) — Custom MOTD configuration
- [Bash variable check](https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash)
