# Packages
If desired, dependent packages can be pre-fretched to speed up `docker build`, when working on a new agent image.

```
mkdir toolscache && \
wget -O azcopy.tar.gz https://aka.ms/downloadazcopylinux64 && \
azcopy --recursive \
       --source https://vstsagenttools.blob.core.windows.net/tools/hostedtoolcache/linux \
       --destination ./toolscache
```