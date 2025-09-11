#!/bin/sh
PUID=${PUID:-911}
PGID=${PGID:-911}
BUNUSER=${USER_NAME:-bunadmin};
FPYVENV="/app/pyvenv"
RTXT="/app/requirements.txt"
NUSER=""
RUNENGINE="bun"
PRJDIR="/app"
script="app.js"

if [ "$BUNUSER" = "bunadmin" ]; then
  groupmod -o -g "$PGID" bunadmin
  usermod -o -u "$PUID" bunadmin
else
  echo "Create new user"
  useradd \
      -u ${PUID} -U \
      -d /home/$BUNUSER \
      -s /bin/bash $BUNUSER && \
      echo "$BUNUSER:$USER_PASSWORD" | chpasswd && \
      usermod -G users $BUNUSER && \
      # usermod -aG sudo $BUNUSER && \
      mkdir -p /home/$BUNUSER && \
      chown -R ${PUID}:${PGID} /home/$BUNUSER \
        /build \
        /deployment
  groupmod -o -g "$PGID" $BUNUSER
  usermod -o -u "$PUID" $BUNUSER
fi

GL="NO" 
if [ ! -z ${PYVENV} ];then
  GL=$PYVENV  
fi

if [ "$GL" = "YES" ]  && [ ! -d ${FPYVENV} ]; then

    uv venv ${FPYVENV} && source ${FPYVENV}/bin/activate
    if [[ -f ${RTXT} ]]; then      
      uv pip install -r ${RTXT}
    fi
    if [ ! -z ${USER_NAME+x} ]; then
      chown -R ${PUID}:${PGID} ${FPYVENV}
    fi
    echo "Python virtual environment setup done!"
fi

PJSON="/app/package.json"
NMODULES="/app/node_modules"
if [ ! -d ${NMODULES} ] && [ -f ${PJSON} ]; then
  if [ ! -z ${USER_NAME+x} ]; then
    if $SYNO ; then
      helper --proc=install --dir="/app" --target="/app"  && \
      chown -R ${PUID}:${PGID} /nodepath && \
      cp -r /nodepath/app/node_modules /app && \
      chown -R ${PUID}:${PGID} /app/node_modules
      echo "Install nodepath done!"
    else
      cd /app &&  bun install --no-save --no-lockfile && chown -R ${PUID}:${PGID} node_modules
    fi    
  else
    if $SYNO ; then
      helper --proc=install --dir="/app" --target="/app"
    else
      cd /app &&  bun install --no-save --no-lockfile
    fi    
  fi
  echo "Install node_modules done!"
fi

echo “init-project-config done!”

FPYVENV="/app/pyvenv"
if [ ! -z ${PYVENV} ] && [ -d ${FPYVENV} ]; then
    echo "Activate python virtual environment"
    source ${FPYVENV}/bin/activate                
fi

if [ ! -z ${INTERPRETER} ]; then
    RUNENGINE=$INTERPRETER
fi

if [ "$RUNENGINE" = "python" ]; then    
    script="app.py"
fi

# Trigger internal dummny web server if the script no exists
if [ ! -f "${PRJDIR}/${script}" ]; then
    PRJDIR="/scripts"
    if [[ "$RUNENGINE" == "python" ]]; then
        script="app.py"
    else 
        script="app.js"
    fi    
fi

set -e
set -- "${RUNENGINE}" "${script}" "--user=${USER_NAME}" "--homedir=/home/${USER_NAME}" "--mode=${RUN_MODE}" "--engine=${RUN_ENGINE}"

echo "$@"
exec "$@"
