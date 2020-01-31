# ----------------------------------
# build the entrypoint binary
# ----------------------------------
FROM golang:1.13 AS go-build

RUN mkdir -p /src
WORKDIR /src
COPY . /src
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /entrypoint ./cmd/entrypoint 
#RUN go install -ldflags "-linkmode external -extldflags -static" ./cmd/entrypoint


# ----------------------------------
# dev-shell image
# ----------------------------------
FROM registry.postgun.com:5000/mailgun/pybuild:latest

RUN apt-get update && \
    apt-get install -y \
	openssh-server \
	vim \
	less \
	curl \
	iputils-ping \
	net-tools \
	build-essential \
	git \
	python \
	python-dev \
	python-pip \
	libyaml-dev \
	libffi-dev \
	libpython2.7-dev \
	libssl-dev \
	locales \
	vim \
	make && \
    curl -O https://dl.google.com/go/go1.13.7.linux-amd64.tar.gz && \
	mkdir -p /opt/golang && \
	tar -C /opt/golang -zxf go1.13.7.linux-amd64.tar.gz && \
	mv /opt/golang/go /opt/golang/1.13.7 && \
	ln -s /opt/golang/1.13.7 /opt/golang/current && \
	rm go*linux-amd64.tar.gz && \
	LC_ALL=C pip install virtualenv && \
	virtualenv ~/.venv && \
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
COPY --from=go-build /entrypoint /usr/sbin/entrypoint

# Cleanup
RUN rm /etc/ssh/ssh_host*
EXPOSE 22

CMD ["/usr/sbin/entrypoint"]
