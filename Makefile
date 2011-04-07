CC = gcc
ROOT_DIR ?= /
PANTS_DAEMON_BIN = pants-server
PANTS_DAEMON_SRC = pants-server.c 
INSTALL_DIR ?= ${ROOT_DIR}/usr/sbin
ETC_DIR = ${ROOT_DIR}/etc
SYSV_DIR ?= ${ETC_DIR}/init.d

.PHONY: server all

all: server

server: ${PANTS_DAEMON_BIN}

${PANTS_DAEMON_BIN}: ${PANTS_DAEMON_SRC}
	${CC} ${PANTS_DAEMON_SRC} -o ${PANTS_DAEMON_BIN}

clean:
	rm -f ${PANTS_DAEMON_BIN}

install:
	install -m0755 -D ./${PANTS_DAEMON_BIN} ${INSTALL_DIR}/pants
	install -m0755 -D ./pants.sysv ${SYSV_DIR}/pants
	install -m0644 -D ./pants.file ${ETC_DIR}/pants.file
	install -m0644 -D ./pants.sysconfig ${ETC_DIR}/sysconfig/pants
