FROM ldap-overleaf-sl:latest

# Apply patches
COPY agdsn/ProjectGetter.js.patch /tmp/ProjectGetter.js.patch
RUN patch /overleaf/services/web/app/src/Features/Project/ProjectGetter.js < /tmp/ProjectGetter.js.patch
 
# IPA CA Cert
COPY agdsn/ipa-ca.crt /usr/local/share/ca-certificates/ipa-ca.crt
RUN update-ca-certificates

# nginx config
COPY agdsn/sharelatex.conf /etc/nginx/sites-enabled/sharelatex.conf

# TeX Full
RUN apt-get -y install texlive-full
