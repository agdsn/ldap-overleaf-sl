FROM ldap-overleaf-sl:latest

FROM registry.gitlab.com/islandoftex/images/texlive:latest as texlive

# TeX Full
# RUN apt-get -y install texlive-full

# Apply patches
COPY agdsn/ProjectGetter.js.patch /tmp/ProjectGetter.js.patch
RUN patch /overleaf/services/web/app/src/Features/Project/ProjectGetter.js < /tmp/ProjectGetter.js.patch
 
# IPA CA Cert
COPY agdsn/ipa-ca.crt /usr/local/share/ca-certificates/ipa-ca.crt
RUN update-ca-certificates

# nginx config
COPY agdsn/sharelatex.conf /etc/nginx/sites-enabled/sharelatex.conf

# Update TeXLive
COPY --from=texlive /usr/local/texlive /usr/local/texlive
RUN tlmgr path add

# Evil hack for hardcoded texlive 2021 path
RUN rm -r /usr/local/texlive/2021 && ln -s /usr/local/texlive/2022 /usr/local/texlive/2021