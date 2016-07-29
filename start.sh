#!/bin/bash

if test -n "$LDAP_ENV_DOMAIN" -a -z "$LDAP_HOST"; then
    LDAP_HOST="ldap"
fi
LDAP_HOST=${LDAP_HOST:-$LDAP_DOMAIN}
LDAP_DOMAIN=${LDAP_DOMAIN:-${LDAP_ENV_DOMAIN:-$LDAP_HOST}}
LDAP_BASE=dc=${LDAP_BASE:-${LDAP_DOMAIN//./,dc=}}
LDAP_USER_BASE=${LDAP_USER_BASE:-ou=people},${LDAP_BASE}
LDAP_GROUP_BASE=${LDAP_GROUP_BASE:-ou=group},${LDAP_BASE}
LDAP_URL=${LDAP_URL:-ldap://${LDAP_HOST}:389}
if test -n "$LDAP_BIND_DN"; then
    LDAP_BIND_DN=${LDAP_BIND_DN},${LDAP_BASE}
fi

for f in /etc/apache2/conf-available/svn.conf /perltest.pl; do
sed -i \
    -e 's|BASEPATH|'"$BASEPATH"'|' \
    -e 's|LDAP_CONFIG_VERBOSE|'"$LDAP_CONFIG_VERBOSE"'|' \
    -e 's|LDAP_READ_DN|'"$LDAP_READ_DN"'|' \
    -e 's|LDAP_WRITE_DN|'"$LDAP_WRITE_DN"'|' \
    -e 's|LDAP_READ_DEFAULT|'"$LDAP_READ_DEFAULT"'|' \
    -e 's|LDAP_WRITE_DEFAULT|'"$LDAP_WRITE_DEFAULT"'|' \
    -e 's|LDAP_HOST|'"$LDAP_HOST"'|' \
    -e 's|LDAP_DOMAIN|'"$LDAP_DOMAIN"'|' \
    -e 's|LDAP_BASE|'"$LDAP_BASE"'|' \
    -e 's|LDAP_USER_BASE|'"$LDAP_USER_BASE"'|' \
    -e 's|LDAP_GROUP_BASE|'"$LDAP_GROUP_BASE"'|' \
    -e 's|LDAP_URL_QUERY|'"$LDAP_URL_QUERY"'|' \
    -e 's|LDAP_URL|'"$LDAP_URL"'|' \
    -e 's|LDAP_BIND_DN|'"$LDAP_BIND_DN"'|' \
    -e 's|LDAP_BIND_PWD|'"$LDAP_BIND_PWD"'|' \
    -e 's|LDAP_MEMBER_UID|'"$LDAP_MEMBER_UID"'|' \
    -e 's|LDAP_GROUP_ATTR_IS_DN|'"$LDAP_GROUP_ATTR_IS_DN"'|' \
    $f
#/etc/apache2/conf-available/svn.conf
done

if test -f /run/apache2/apache2.pid; then
    rm /run/apache2/apache2.pid;
fi;
apache2ctl -DFOREGROUND
