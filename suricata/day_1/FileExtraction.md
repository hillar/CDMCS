# File Extraction

> File extraction depends on a lot of things to be fully done..


see

* https://redmine.openinfosecfoundation.org/projects/suricata/wiki/MD5

### config
```
- file-store:
    enabled: yes       # set to yes to enable
    log-dir: files    # directory to store the files
    force-magic: yes   # force logging magic on all stored files
    force-md5: yes    # force logging of md5 checksums
    #waldo: file.waldo # waldo file to store the file_id across runs

# output module to log files tracked in a easily parsable json format
- file-log:
    enabled: yes
    filename: files-json.log
    append: yes
    #filetype: regular # 'regular', 'unix_stream' or 'unix_dgram'

    force-magic: yes   # force logging magic on all logged files
    force-md5: yes     # force logging of md5 checksums

```

#### stream reassembly depth. Set this to 0 (unlimited)
```
stream:
  memcap: 32mb
  checksum-validation: yes      # reject wrong csums
  inline: auto                  # auto will use inline mode in IPS mode, yes or no set it statically
  reassembly:
    memcap: 128mb
    depth: 0 #1mb

```

#### http request / response body sizes. Set those to 0 (unlimited)
```

    libhtp:

       default-config:
         personality: IDS

         # Can be specified in kb, mb, gb.  Just a number indicates
         # it's in bytes.
         request-body-limit: 0 #100kb
         response-body-limit: 0 #100kb
```




#### rules that contain the "filestore" keyword.

```
# grep filestore /usr/local/etc/suricata/rules/* | grep -v "#"
/usr/local/etc/suricata/rules/files.rules:alert http any any -> any any (msg:"FILE store all"; filestore; noalert; sid:15; rev:1;)

```


### files

```
# ls /usr/local/var/log/suricata//files
file.1  file.1.meta
```


----

## no files ;(



### start from cmd

```
[51155] 20/1/2016 -- 14:54:53 - (detect.c:416) <Info> (ProcessSigFiles) -- Loading rule file: /usr/local/etc/suricata/rules/files.rules

[51066] 20/1/2016 -- 14:29:20 - (log-filestore.c:476) <Info> (LogFilestoreLogInitCtx) -- storing files in /usr/local/var/log/suricata//files
[51066] 20/1/2016 -- 14:29:20 - (util-logopenfile.c:298) <Info> (SCConfLogOpenGeneric) -- file-log output device (regular) initialized: files-js

[51067] 20/1/2016 -- 14:29:20 - (util-ioctl.c:202) <Info> (GetIfaceOffloading) -- NIC offloading on eth0: GRO: unset, LRO: unset

[51067] 20/1/2016 -- 14:29:41 - (util-checksum.c:86) <Info> (ChecksumAutoModeCheck) -- No packets with invalid checksum, assuming checksum offloading is NOT used

```


## no md5 ;(

### start from cmd
```
[51155] 20/1/2016 -- 14:55:17 - (log-filestore.c:473) <Info> (LogFilestoreLogInitCtx) -- md5 calculation requires linking against libnss
[51155] 20/1/2016 -- 14:55:17 - (log-file.c:431) <Info> (LogFileLogInitCtx) -- md5 calculation requires linking against libnss
```

```
root@secx:/usr/local/var/log/suricata/files# grep MD5 file.*.meta

root@secx:/usr/local/var/log/suricata/files# /usr/local/bin/suricata -c /usr/local/etc/suricata/suricata.yaml --dump-config | grep md5
outputs.1.eve-log.types.4.files.force-md5 = no
outputs.13.file-store.force-md5 = yes
outputs.14.file-log.force-md5 = yes
app-layer.protocols.smtp.mime.body-md5 = no

```


## push files to elasticsearch for content index

see

* http://tika.apache.org/1.11/formats.html#Full_list_of_Supported_Formats

```
curl -XDELETE http://localhost:9200/suricata
```

```
curl -XPOST http://localhost:9200/suricata -d '{
  "mappings": {
    "file": {
      "properties": {
        "content": { "type": "attachment" }
}}}}'
```

```
curl -XPOST http://localhost:9200/suricata/file/86601 -d "
{
  \"content\": \"$(openssl base64 -in file.86601)\"
}
"
```

```
curl -XPOST http://localhost:9200/suricata/file/_search -d '
{
  "query": {
    "query_string": {
      "query": "kustutatud"
}}}
'
```
