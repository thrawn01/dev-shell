# ----------------------------------
# build the entrypoint binary
# ----------------------------------
FROM golang:1.9 AS go-build

ENV GOPATH /go
RUN mkdir -p /go/src && mkdir -p /go/bin

WORKDIR /go/src/github.com/mailgun/dev-shell
COPY . .
RUN go install -ldflags "-linkmode external -extldflags -static" github.com/mailgun/dev-shell/cmd/entrypoint


# ----------------------------------
# dev-shell image
# ----------------------------------
FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y openssh-server vim less curl iputils-ping net-tools build-essential make && \
	curl -O https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz && \
	mkdir -p /opt/golang && \
	tar -C /opt/golang -zxf go1.9.1.linux-amd64.tar.gz && \
	mv /opt/golang/go /opt/golang/1.9.1 && \
	ln -s /opt/golang/1.9.1 /opt/golang/current && \
	rm go1.9.1.linux-amd64.tar.gz && \
	mkdir -p /var/run/sshd

ADD profile /root/.profile

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
&& sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
&& sed -ri 's/^StrictModes\s+.*/StrictModes no/' /etc/ssh/sshd_config \
&& sed -ri 's/HostKey \/etc\/ssh\//HostKey \/etc\/ssh\/hostKeys\//g' /etc/ssh/sshd_config \
&& echo "PasswordAuthentication no" >> /etc/ssh/sshd_config \
&& echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config \
&& echo "UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config

# Copy the entrypoint binary
COPY --from=go-build /go/bin/entrypoint /usr/sbin/entrypoint

# Cleanup
RUN rm /etc/ssh/ssh_host*
EXPOSE 22

CMD ["/usr/sbin/entrypoint"]
