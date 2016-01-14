# Evil bit

see

* https://www.ietf.org/rfc/rfc3514.txt
* https://github.com/regit/luaevilbit




####  0x0  

If the bit is set to 0, the packet has no evil intent.  Hosts,
       network elements, etc., SHOULD assume that the packet is
       harmless, and SHOULD NOT take any defensive measures.  (We note
       that this part of the spec is already implemented by many common
       desktop operating systems.)

####  0x1  

If the bit is set to 1, the packet has evil intent.  Secure
       systems SHOULD try to defend themselves against such packets.
       Insecure systems MAY chose to crash, be penetrated, etc.
