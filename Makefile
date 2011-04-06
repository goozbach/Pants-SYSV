CC = gcc
ROOT_DIR ?= /
PANTS_DAEMON_BIN = server
PANTS_DAEMON_SRC = server.c 
INSTALL_DIR ?= ${ROOT_DIR}/usr/sbin
ETC_DIR = ${ROOT_DIR}/etc
SYSV_DIR ?= ${ETC_DIR}/init.d

all: server

server:
	${CC} ${PANTS_DAEMON_SRC} -o ${PANTS_DAEMON_BIN}

clean:
	rm -f ${PANTS_DAEMON_BIN}

install:
	install -m0755 -D ./server ${INSTALL_DIR}/pants
	install -m0755 -D ./pants ${SYSV_DIR}/pants
	install -m0644 -D ./pants.file ${ETC_DIR}/pants.file
	install -m0644 -D ./pants.sysconfig ${ETC_DIR}/sysconfig/pants
