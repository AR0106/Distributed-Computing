#include <stdio.h>
#include <unistd.h>

#include <arpa/inet.h>
#include <net/if.h>
#ifdef __FreeBSD__
#include <net/if_var.h>
#endif
#include <netinet/in.h>
#include <string.h>
#include <sys/errno.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/types.h>

#include "net.h"

char *getLocalNetworkAddress(char *interface) {
  int fd;
  struct ifreq ifr;

  fd = socket(AF_INET, SOCK_DGRAM, 0);
  ifr.ifr_addr.sa_family = AF_INET;

  strncpy(ifr.ifr_name, interface, IFNAMSIZ - 1);

  ioctl(fd, SIOCGIFADDR, &ifr);

  close(fd);

  char *address = inet_ntoa(((struct sockaddr_in *)&ifr.ifr_addr)->sin_addr);

  if (!strcmp(address, "0.0.0.0")) {
    char error_msg[256];
    snprintf(error_msg, sizeof(error_msg),
             "IPv4 Address Not Found For Specified Interface: %s", interface);
    perror(error_msg);
  }

  return address;
}
