# Rule Thresholding

see https://github.com/inliniac/suricata/blob/master/threshold.config

Thresholding feature is used to reduce the number of logged alerts for noisy rules.


```
threshold gen_id <gen_id>, sig_id <sig_id>, type <limit|threshold|both>, track <by_src|by_dst>, count <n>, seconds <t>
```
