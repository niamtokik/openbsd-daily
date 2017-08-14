#!/bin/sh

REPOSITORY="anoncvs@anoncvs.eu.openbsd.org:/cvs"
CVS_OPTS="-d ${REPOSITORY} -qz3"

_checkout_with_date() {
  local source date
  source="${1}"
  date="${2}"

  if [ "${date}" ]
  then
    cvs ${CVS_OPTS} checkout -D"${date}" "${source}"
  else
    echo "warning: checkout last release for ${source}" 1>&2 
    cvs ${CVS_OPTS} checkout "${source}"
  fi

  if [ "${CLEAN}" ]
  then
    _clean "${source%%/*}"
  fi
}

_clean() {
  local dir
  dir="${1}"
  echo "files to remove:"
  find "${dir}" -type d -name CVS 
}

_usage() {
  printf "Usage: %s source [date]\n" "${0}"
}

if [ "${*}" ]
then
  _checkout_with_date ${*}
else
  _usage
  exit 1
fi

