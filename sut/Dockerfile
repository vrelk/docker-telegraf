From appcelerator/alpine:3.4.0
RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://nl.alpinelinux.org/alpine/v3.4/community" >> /etc/apk/repositories 
RUN apk --update add docker bind-tools@edge
COPY ./test.sh /bin
COPY ./test-queue.sh /bin
CMD ["/bin/test.sh"]
