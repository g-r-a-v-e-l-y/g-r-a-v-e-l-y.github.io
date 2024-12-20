"""
Sniff UDP dns transactions with Scapy.
"""
__version__ = "$Revision: 1.0 $"
__date__ = "$Date: 2009/11/04 13:50:00 $"
__license__ = "Python"

from scapy import UDP
import time
import syslog
from optparse import OptionParser

def outputLog(logentry):
    if options.syslog == True:
        syslog.openlog(os.path.basename(sys.argv[0]), syslog.LOG_PID, syslog.LOG_MAIL)

        #syslog.openlog(options.ident, options.logopt, options.facility)
        syslog.syslog(options.logentry)
    if options.quiet == False:
        print logentry

def dns_callback(pkt):
    if DNSQR in pkt and pkt.dport == 53:
    # queries
        logentry = time.asctime(time.localtime(time.time())) + \
            " session-id: " + str(pkt[DNS].id) + \
            " UDP client: " +  pkt[IP].src + ":" +  str(pkt.sport) + \
            " server: " + pkt[IP].dst + ":" +  str(pkt.dport) + \
            " query: " + pkt[DNSQR].qname + \
            " class: " + pkt[DNSQR].sprintf("%qclass%") +\
            " type: " + pkt[DNSQR].sprintf("%qtype%")
        outputLog(logentry)
    elif DNSRR in pkt and pkt.sport == 53:
    # responses
        logentry = time.asctime(time.localtime(time.time())) + \
            " session-id: " + str(pkt[DNS].id) + \
            " UDP server: " + pkt[IP].src + ":" + str(pkt.sport) + \
            " client: " + pkt[IP].dst + ":" + str(pkt.dport) + \
            " response: " + `pkt[DNSRR].rdata` + \
            " class: " +  pkt[DNSRR].sprintf("%rclass%") + \
            " type: " + pkt[DNSRR].sprintf("%type%") + \
            " ttl: " + str(pkt[DNSRR].ttl) + \
            " len: " +  str(pkt[DNSRR].rdlen)
        outputLog(logentry)

def sniffDNS():
    sniff(iface=options.interface, prn=dns_callback, filter=options.filter, store=0)

if __name__ == "__main__":
    # Set up commands line options
    usage = "usage: %prog [options] arg1 arg2"
    parser = OptionParser()
    parser.add_option("-s", "--syslog", action="store_true", \
        dest="syslog", default=False, help="write to syslog")
    parser.add_option("-i", "--interface", action="store", \
        dest="interface", default=None, metavar="INTERFACE", \
        help="listen on INTERFACE")
    parser.add_option("-q", "--quiet", action="store_true", \
        dest="quiet", default=False, help="quiet output")
    parser.add_option("-f", "--filter", action="store", \
        dest="filter", default="port 53 and udp", metavar="BPF", \
        help="BPF to apply to scapy sniffer (defaults to 'port 53 and udp'")
    parser.add_option("-P", "--priority", action="store", \
        dest="priority", default="syslog.LOG_INFO", metavar="PRIORITY", \
        help="syslog priority, defaults to 'LOG_INFO', use with -s")
    parser.add_option("-I", "--ident", action="store", \
        dest="ident", default="dnssnarf", metavar="IDENT", \
        help="syslog priority, defaults to 'syslog', use with -s")
    parser.add_option("-L", "--logopt", action="store", \
        dest="logopt", default=0, metavar="LOGOPT", \
        help="syslog logopt bit field, defaults to '0', use with -s")
    parser.add_option("-F", "--facility", action="store", \
        dest="facility", default="syslog.LOG_USER", metavar="FACILITY", \
        help="syslog facility, defaults to 'LOG_USER, use with -s")
    (options, args) = parser.parse_args()

    # Go to work
    sniffDNS()
