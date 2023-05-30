FROM ldap-overleaf-sl:latest

# update texlive distribution
# WORKAROUND: calling tmgr by abspath causes the nearby executables 
#  like `mtxrun` (necessary for post-processign the context installation)
#  to be called with the same absolute path first, working aronud the bug that
#  `tlmgr` tries to execute `mtxrun` even though we can only add it to the path
#  via `tlmgr path add` (creating symlinks in /usr/local/bin),
#  but this makes sense only after a successful installation of context.
ARG TLMGR=/usr/local/texlive/2022/bin/x86_64-linux/tlmgr
RUN  \
  ${TLMGR} option repository https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2022/tlnet-final/ && \
  ${TLMGR} update --self && \
  ${TLMGR} install scheme-full && \
  ${TLMGR} path add

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