// server.c -- Goozbach's echo server.
//             Cobbled together from crap found on the web.
//             Guaranteed to be broken and insecure.  Please don't run with /etc/passwd as the file.  :)
//
//             Ryan Erickson
//             ccoder@ericksonfamily.com
//             http://www.ericksonfamily.com
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// version 2 as published by the Free Software Foundation.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#define SIZE 1024

char buf [SIZE];
FILE *f;

int main (int argc, char *argv [])
{
    pid_t   pid, sid;
    int sockfd, client_sockfd;
    int nread, len;
    struct sockaddr_in serv_addr, client_addr;
    int c;

    int pants_port;
    char filename[255];


    pid = fork();

    if (pid < 0) {
        fprintf(stderr, "E: fork() failed\n");
        exit(1);
    } else if (pid > 0) {
        exit(0);
    }

    umask(0);

    sid = setsid();
    if (sid < 0) {
        fprintf(stderr, "E: sid() failed\n");
        exit(1);
    }

    if ((chdir("/")) < 0) {
        fprintf(stderr, "E: chdir() failed\n");
        exit(1);
    }

    pants_port = -1;
    filename[0] = 0x00;

    while (1)
    {
    	c = getopt(argc, argv, "p:f:");

	if (c == -1 ) break;
	if (c == 'p') pants_port = atoi(optarg);
	if (c == 'f') strcpy(filename, optarg);
    }

    if ((pants_port == -1) || (strlen(filename) == 0))
    {
	    printf("Usage: %s -p port -f filename\n", argv[0]);
	    exit(0);
    }

    /* create endpoint */
    if ((sockfd = socket (AF_INET, SOCK_STREAM, 0)) < 0) {
	perror (NULL);
	exit (2);
    }

    /* bind address */
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl (INADDR_ANY);
    serv_addr.sin_port = htons (pants_port);

    if (bind (sockfd, &serv_addr, sizeof (serv_addr)) < 0) {
	perror (NULL);
	exit (3);
    }

    /* specify queue */
    listen (sockfd, 5);
    for (;;) {
	len = sizeof (client_addr);
	client_sockfd = accept (sockfd, &client_addr, &len);
	if (client_sockfd == -1) {
	    perror (NULL);
	    continue;
	}

	/* transfer data */
	f=fopen(filename,"r");
	if (!f) return 1;

        while (fgets(buf,SIZE-1,f)!=NULL)
	{
	    len = strlen (buf);
	    write (client_sockfd, buf, len);
	}
	fclose(f);
	close (client_sockfd);
    }
}
