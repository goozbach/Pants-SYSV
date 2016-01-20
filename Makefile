CC = gcc
ROOT_DIR ?= /
PANTS_DAEMON_BIN = pants-server
PANTS_DAEMON_SRC = pants-server.c 
INSTALL_DIR ?= ${ROOT_DIR}/usr/sbin
ETC_DIR = ${ROOT_DIR}/etc
SYSV_DIR ?= ${ETC_DIR}/init.d
VERSION ?= $(shell grep '^Version:' pants.spec | cut -d ' ' -f 2)
RELEASE ?= $(shell grep '^Release:' pants.spec | cut -d ' ' -f 2)
ARCH ?= x86_64

.PHONY: server all tarball nuke srpm rpm

all: server

server: ${PANTS_DAEMON_BIN}

${PANTS_DAEMON_BIN}: ${PANTS_DAEMON_SRC}
	${CC} ${PANTS_DAEMON_SRC} -o ${PANTS_DAEMON_BIN}

clean:
	rm -f ${PANTS_DAEMON_BIN}
	rm -f rpmbuild/${VERSION}.tar.gz

nuke: clean
	rm -rf rpmbuild/*

install:
	install -m0755 -D ./${PANTS_DAEMON_BIN} ${INSTALL_DIR}/pants
	install -m0755 -D ./pants.sysv ${SYSV_DIR}/pants
	install -m0644 -D ./pants.file ${ETC_DIR}/pants.file
	install -m0644 -D ./pants.sysconfig ${ETC_DIR}/sysconfig/pants

rpmbuild/${VERSION}.tar.gz:
	tar -czf rpmbuild/${VERSION}.tar.gz --transform s/./pants-sysv-${VERSION}/ --exclude=rpmbuild --exclude=scratch --exclude=.git .

tarball: rpmbuild/${VERSION}.tar.gz pants.spec

rpmbuild/pants-sysv-${VERSION}-${RELEASE}.src.rpm:
	mock --buildsrpm --resultdir=$(shell pwd)/rpmbuild --sources=$(shell pwd)/rpmbuild --spec=$(shell pwd)/pants.spec

srpm: rpmbuild/pants-sysv-${VERSION}-${RELEASE}.src.rpm tarball rpmbuild/${VERSION}.tar.gz

rpm: rpmbuild/pants-sysv-${VERSION}-${RELEASE}.${ARCH}.rpm srpm

rpmbuild/pants-sysv-${VERSION}-${RELEASE}.${ARCH}.rpm: rpmbuild/pants-sysv-${VERSION}-${RELEASE}.src.rpm
	mock --rebuild --resultdir=$(shell pwd)/rpmbuild rpmbuild/pants-sysv-${VERSION}-${RELEASE}.src.rpm 
