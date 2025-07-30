#!/usr/bin/env bash

# Default PRAGMA_ROOT to "." if not set
if [ -z "${PRAGMA_ROOT}" ]; then
  PRAGMA_ROOT=".."
fi

"${PRAGMA_ROOT}/lib/render_raytracing" "$@"
