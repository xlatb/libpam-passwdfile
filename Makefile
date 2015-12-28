PAM_LIB_DIR = /lib/security
CC = gcc
LD = ld
INSTALL = /usr/bin/install
CFLAGS = -fPIC -O2 -c -g -Wall -Wformat-security
LDFLAGS = -x --shared 
PAMLIB = -lpam
CRYPTLIB = -lcrypt
CPPFLAGS =

all: pam_passwdfile.so

pam_passwdfile.so: pam_passwdfile.o bigcrypt.o md5_good.o md5_crypt_good.o md5_broken.o md5_crypt_broken.o
	$(LD) $(LDFLAGS) -o pam_passwdfile.so pam_passwdfile.o md5_good.o md5_crypt_good.o md5_broken.o md5_crypt_broken.o bigcrypt.o $(PAMLIB) $(CRYPTLIB)

pam_passwdfile.o: pam_passwdfile.c
	$(CC) $(CFLAGS) pam_passwdfile.c

bigcrypt.o: bigcrypt.c
	$(CC) $(CFLAGS) bigcrypt.c


md5_good.o: md5.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -DHIGHFIRST -D'MD5Name(x)=Good##x' -c $< -o $@

md5_broken.o: md5.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -D'MD5Name(x)=Broken##x' \
                 -c $< -o $@

md5_crypt_good.o: md5_crypt.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -D'MD5Name(x)=Good##x' \
                 -c $< -o $@

md5_crypt_broken.o: md5_crypt.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -D'MD5Name(x)=Broken##x' \
                 -c $< -o $@


install: pam_passwdfile.so
	$(INSTALL) -m 0755 -d $(PAM_LIB_DIR)
	$(INSTALL) -m 0755 pam_passwdfile.so $(PAM_LIB_DIR)

clean:
	rm -f pam_passwdfile.o pam_passwdfile.so *.o

spotless:
	rm -f pam_passwdfile.so pam_passwdfile.o *~ core
