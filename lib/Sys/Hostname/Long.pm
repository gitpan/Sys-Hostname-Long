package Sys::Hostname::Long;

use strict;
use Carp;

require Exporter;
use Sys::Hostname;
@Sys::Hostname::Long::ISA     = qw/ Exporter Sys::Hostname /;

# Use perl < 5.6 compatible methods for now, change to our soon.
use vars qw(@EXPORT $VERSION $hostlong);
@EXPORT  = qw/ hostname_long /;
$VERSION = '1.0';

sub hostname_long {

	# Cached copy (takes a while to lookup sometimes)
	return $hostlong if defined $hostlong;

	# Method 1 - Generic

	# Method 2 - OS Specific
 
	if ($^O eq 'MacOS') {
		# http://bumppo.net/lists/macperl/1999/03/msg00282.html 
		#	suggests that it will work (checking localhost) on both
		#	Mac and Windows. 
		#	Personally this makes no sense what so ever as 
		$hostlong = gethostbyname('localhost');
	} elsif ($^O eq 'MSWin32') {
		$hostlong = gethostbyname('localhost');
	} else {
		# Default fall back
		#	- Most unix (have not tested them all)
		#		. Linux
		#		. FreeBSD
		#	- MacOS X (Rhapsody/Darwin)
		$hostlong = `hostname --fqdn`;
		$hostlong =~ tr/\0\r\n//d;
	}

	return $hostlong;
}

1;

__END__

=head1 NAME

Sys::Hostname::Long - Try every conceivable way to get full hostname

=head1 SYNOPSIS

    use Sys::Hostname::Long;
    $host_long = hostname_long;

=head1 DESCRIPTION

How to get the host full name in perl on multiple operating systems (mac,
windows, unix* etc)

Attempt via many methods to get the systems full name. The L<Sys::Hostname>
class is the best and standard way to get the system hostname. However it is
missing the long hostname.

Special thanks to B<David Sundstrom> and B<Greg Bacon> for the original
L<Sys::Hostname>

=head1 SUPPORT

List of platforms supported, tested etc.

	MacOS		Macintosh Classic		OK
	Win32		MS Windows (95,98,nt,2000...)	Not Tested
	MacOS X		Macintosh 10			OK
	Linux 		Linux UNIX OS			OK

=head1 LIMITATIONS

=head2 Unix

Most unix systems have trouble working out the fully quallified domain name as
it to be configured somewhere in the system correctly. For example in most
linux systems (debian, ?) the fully qualified name should be the first entry
next to the ip number in /etc/hosts

	192.168.0.1	fred.somwhere.special	fred

If it is the other way around, it will fail.

=head2 Mac

=head1 SEE ALSO

	L<Sys::Hostname>

=head1 AUTHOR

Scott Penrose E<lt>F<scottp@dd.com.au>E<gt>

=head1 COPYRIGHT

Copyright (c) 2001 Scott Penrose. All rights reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

