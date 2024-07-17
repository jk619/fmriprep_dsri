FROM nipreps/fmriprep:latest
COPY /license.txt /tmp/license.txt
ENTRYPOINT ["/usr/bin/env"]
#CMD [sub="$(cat /tmp/subject.txt)"]

ADD start.sh /
ADD 3dMean /
ADD libmri.so /
ADD libf2c.so /



RUN chmod +x /start.sh

CMD ["/start.sh"]



