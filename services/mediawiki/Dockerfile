FROM mediawiki:latest

RUN apt -y update; \ 
    apt -y install libmediawiki-api-perl \
        libdatetime-format-iso8601-perl \
        liblwp-protocol-https-perl \
        git


# install GIT-MW
RUN git clone https://github.com/git-mediawiki/git-mediawiki /git-mediawiki; \
    ln -s /git-mediawiki/git-remote-mediawiki /usr/lib/git-core/; \
    ln -s /git-mediawiki/git-mw /usr/lib/git-core/; \
    ln -s /git-mediawiki/Git/Mediawiki.pm /usr/share/perl5/Git/;

RUN apt -y install mariadb-client
