#!/usr/bin/perl -w

use IO::Socket::INET;
my $SOCKET = IO::Socket::INET->new(
        PeerAddr => "mailserverhost",
        PeerPort => 25,
        Proto   => 'tcp') || die "Error in create socket!";

$SOCKET->autoflush= 0;

# Suck down the greeting and discard it
my $RESPONSE = <$SOCKET>;
print $RESPONSE;

print "HELO server";
print $SOCKET "HELO server";
$RESPONSE = <$SOCKET>;
print $RESPONSE;

print "RSET";
print $SOCKET "RSET";
$RESPONSE = <$SOCKET>;
print $RESPONSE;

print "MAIL FROM:<spamtest@somedomain.com>";
print $SOCKET "MAIL FROM:<spamtest@somedomain.com>";
$RESPONSE = <$SOCKET>;
print $RESPONSE;


print "RCPT TO:<to@domain.com>";
print $SOCKET "RCPT TO:<to@domain.com>";
$RESPONSE = <$SOCKET>;
print $RESPONSE;

# goodbye
print $SOCKET "QUIT";
# eat any response
$RESPONSE = <$SOCKET>;
print $RESPONSE;
# kill socket
close($SOCKET);
