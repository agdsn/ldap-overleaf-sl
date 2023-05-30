FROM ldap-overleaf-sl:latest

# update texlive distribution
RUN  \
  tlmgr option repository https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2022/tlnet-final/ && \
  tlmgr update --self && \
  tlmgr install scheme-full

# Apply patches
COPY agdsn/ProjectGetter.js.patch /tmp/ProjectGetter.js.patch
RUN patch /overleaf/services/web/app/src/Features/Project/ProjectGetter.js < /tmp/ProjectGetter.js.patch
 
# IPA CA Cert
COPY agdsn/ipa-ca.crt /usr/local/share/ca-certificates/ipa-ca.crt
RUN update-ca-certificates

# nginx config
COPY agdsn/sharelatex.conf /etc/nginx/sites-enabled/sharelatex.conf

# Update TeXLive
# RUN tlmgr install scheme-full
RUN tlmgr path add