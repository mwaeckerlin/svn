# svn
Docker Image for Subversion Server

Authentication can be read from LDAP. LDAP_BASE is extracted from LDAP_HOST.

In the following example, if a project configuration exists in the ldap under `ou=project,dc=user,dc=example,dc=org`, then access to the project is authenticated and restricted, otherwise it is public read, and write is restricted to any LDAP user. This way, you can maintain a site with private and public projects, where anyone can checkout public projects, but only registered users can checkin:

    docker run -p 3723:80 -d -v /tmp/svn:/svn \
        -e LDAP_HOST=user.example.org \
        -e LDAP_USER_BASE="ou=person,ou=people" \
        -e LDAP_BIND_DN="cn=bind,ou=system,ou=people" \
        -e LDAP_BIND_PWD="Hsqoa7sa" \
        -e LDAP_READ_DN="ou=project" \
        -e LDAP_WRITE_DN="user" \
        -e LDAP_CONFIG_VERBOSE=3 \
        mwaeckerlin/svn
