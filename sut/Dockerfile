From appcelerator/alpine:3.4.0
RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://nl.alpinelinux.org/alpine/v3.4/community" >> /etc/apk/repositories 
RUN apk --update add docker bind-tools@edge
RUN apk update && apk upgrade && \
    apk add go>1.6 git && \
    export GOPATH=/go && \
    go get -v github.com/nats-io/nats && \
    cd $GOPATH/src/github.com/nats-io/nats && \
    cp examples/*.go /bin/
COPY ./test*.sh /bin/
CMD ["/bin/test.sh"]
