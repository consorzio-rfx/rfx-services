
FROM php:5.6-apache-stretch

MAINTAINER Gianluca Moro <>

RUN set -x \
    && apt-get update \
    && apt-get install -y libldap2-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && apt-get purge -y --auto-remove libldap2-dev
RUN a2enmod rewrite
RUN apt-get update && apt-get install -q -y ssmtp mailutils && rm -rf /var/lib/apt/lists/* 

#    && echo localhost > /etc/hostname \
#    && sed -i 's/=mail/=rfxsmtp.igi.cnr.it/g' /etc/ssmtp/ssmtp.conf \
#    && sed -i 's/hostname=[a-zA-Z0-9]*/hostname=localhost/g' /etc/ssmtp/ssmtp.conf
#RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
#    && echo >> /usr/local/etc/php/php.ini \\
#    && echo "sendmail_path = /usr/sbin/sendmail -t -i -f webmaster@igi.cnr.it" >> /usr/local/etc/php/php.ini
#RUN echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf
#RUN sed -i -e 's/\/var\/www\/html/\/var\/www\/html\/web/g' /etc/apache2/sites-available/000-default.conf

