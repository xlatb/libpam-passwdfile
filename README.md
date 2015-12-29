This is a PAM module for authenticating users against a password file in
the traditional Unix /etc/passwd or /etc/shadow format. This is also the format
used by the Apache htpasswd command.

It is a fork of pam_pwdfile version 0.99, originally by
Charl P. Botha <cpbotha@ieee.org> and released under the
[modified 3-clause BSD license](http://opensource.org/licenses/BSD-3-Clause).

This pam module can be used for the authentication service only, in cases
where one wants to use a different set of passwords than those in the main
system password database.  E.g. in our case we have an imap server running,
and prefer to keep the imap passwords different from the system passwords
for security reasons.

The /etc/pam.d/imap looks like this (e.g.):

    #%PAM-1.0
    auth       required	/lib/security/pam_passwdfile.so pwdfile /etc/imap.passwd
    account    required	/lib/security/pam_pwdb.so

At the moment the only parameters that pam_passwdfile.so parses for is
"pwdfile", followed by the name of the ASCII password database, as in the
above example.  Also, thanks to Jacob Schroeder <jacob@quantec.de>,
pam_passwdfile now supports password file locking.  Adding a "flock" parameter
activates this feature: pam_passwdfile uses and honours flock() file locking on
the specified password file.  Specifying "noflock" or no flock-type
parameter at all deactivates this feature.

Example:

    auth  required /lib/security/pam_passwdfile.so pwdfile /etc/blah.passwd flock

Like other PAM modules, pam_passwdfile causes a 2 second delay when an
incorrect password is supplied.  This is too discourage brute force testing;
however, this behaviour can be disabled with a "nodelay" parameter.  Thanks
to Ethan Benson for this patch.

The ASCII password file is simply a list of lines, each looking like this:
username:crypted_passwd[13] in the case of vanilla crypted passwords and
username:crypted_passwd[34] in the case of MD5 crypted passwords.  The
latter is thanks to Warwick Duncan <warwick@chemeng.uct.ac.za>.  pam_passwdfile
also handles bigcrypt passwords.

# Notes

* Also have a look at the files in the contrib subdirectory.
  Especially if you're having trouble building paw_passwdfile, the
  Makefile.standalone could be your new friend.

* Warwick has also written a utility for managing the password files that
  pam_passwdfile uses.  The website has disappeared, but I've mirrored the
  source code here: http://cpbotha.net/files/mirror/chpwdfile-0.24.tar.gz

* Note that we still expect users to have accounts in the usual place, as we
  make use of the pam_pwdb.so module for the account service.  This module is
  just so that one can have multiple sets of passwords for different services,
  e.g. with our /etc/imap.passwd.  It is however possible with certain
  applications patched for pam (Cyrus IMAP server e.g.) that one does not need
  the users to exist in the system database.
