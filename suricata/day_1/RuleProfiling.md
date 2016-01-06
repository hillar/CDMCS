# Rule Profiling

see:
 * https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Rule_Profiling
 * https://github.com/inliniac/suricata/blob/master/src/util-profiling-rules.c


Profiling can be disabled in config, but it will still have a performance impact if compiled in.


```
rules:
  enabled: yes
  filename: rule_perf.log
  append: yes
  # Sort options: ticks, avgticks, checks, matches, maxticks
  sort: avgticks
  json: true

```
