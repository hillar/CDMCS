# Generates a notice when a connection is established to an IP which is in a blacklist file.
# TODO: Different file/table for known malicious domains
#
# Thanks to SgtMalicious for initial functionality 
# https://gist.github.com/SgtMalicious/7a4b3524ba4de2e96801
#

@load base/frameworks/notice

module MalwareSite;


type Idx: record {
        ip: addr;
};


global addresses: set[addr];

event bro_init() {
	# get an example list from https://rules.emergingthreats.net/open/suricata/rules/compromised-ips.txt
	# remember to insert the table header into the file: #fields<TAB>ip
        Input::add_table([$source="/usr/local/bro/share/bro/site/compromised-ips.txt",$name="addresses",$idx=Idx,$destination=addresses]);
}


export {
        redef enum Notice::Type += {
                Connection_Detected,
                #Domain_Hit,
        };
}

function check(c: connection) {
        local id = c$id;

        local orig = id$orig_h;
        local resp = id$resp_h;

        if ( resp in addresses )
                NOTICE([$note=Connection_Detected,
                        $msg=fmt("Connection to known malware site %s from %s detected.", resp, orig)]);
}

event connection_established(c: connection) {
        MalwareSite::check(c);
}

#event dns_request(c: connection, msg: dns_msg, query: string, qtype: count, qclass: count) {
#        if ( query in domains ) {
#                NOTICE([$note=Domain_Hit,
#                        $conn=c,
#                        $msg=fmt("A domain from the MALWARE domains report seen: %s", query),
#                        $identifier=cat(query)]);
#        }
#}

