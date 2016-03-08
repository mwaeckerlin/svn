FROM ubuntu
MAINTAINER mwaeckerlin

ENV LDAP_DOMAIN ""
ENV LDAP_PATH "ou=people"
ENV LDAP_URL_QUERY "?uid?sub?(objectClass=posixAccount)"
ENV LDAP_BIND_DN "cn=apache-bind,ou=people"
ENV LDAP_BIND_PWD ""
ENV LDAP_MEMBER_UID ""
ENV LDAP_GROUP_ATTR_IS_DN ""

EXPOSE 80

RUN apt-get update
RUN apt-get install -y apache2 libapache2-mod-svn
ADD svn.conf /etc/apache2/mods-available/svn.conf
RUN a2enmod svn dav-svn

ADD start.sh /start.sh
CMD /start.sh

VOLUME /svn
