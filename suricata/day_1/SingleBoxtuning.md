@regit

# Tuning

## eth1

#### Verify that the offloading features are off
```bash
ethtool -k eth1
```

#### Verify the send and receive buffers are the same as the hardware maximum values
```bash
ethtool -g eth1
```

#### Verify the flow hash indirection table
```bash
ethtool -x eth1
bash
```

#### Verify that the IRQ affinity is set correctly, the output bellow shows only the first 4 CPU's
```bash
cat /proc/interrupts | grep 'CPU\|eth1'
```
----

### turn off offloading
```bash
ethtool -K eth1 rx off
ethtool -K eth1 tx off
ethtool -K eth1 sg off
ethtool -K eth1 tso off
ethtool -K eth1 gso off
ethtool -K eth1 gro off
ethtool -K eth1 lro off
ethtool -K eth1 rxvlan off
ethtool -K eth1 txvlan off
ethtool -K eth1 rxhash off
```

### set buffers

1. Get the hardware RX/TX maximum and current
```bash
PRESET=$(ethtool -g $1 | tr '\n' ' ' | sed 's/.*RX:\s\+\([0-9]\+\).*TX:\s\+\([0-9]\+\).*RX:\s\+\([0-9]\+\).*TX:\s\+\([0-9]\+\).*/\1 \2 \3 \4/g')
```
1. Set receive and transmit buffers to the hardware maximum
```bash
ethtool -G $1 rx $(echo $PRESET | cut -f 1 -d " ") tx $(echo $PRESET | cut -f 2 -d " ")
```

### balance flowhash

* Balance evenly per CPU

```bash
ethtool -X $1 equal $(cat /proc/cpuinfo | grep processor | wc -l)
```

### set affinity

```bash
MAX=$(cat /proc/cpuinfo | grep processor | wc -l)

# Since the receive/transmit interrupts name index starts at 0, subtract 1 from the maximum
let "MAX=$MAX-1"

# The mask that will define the affinity
MASK=1

for INDEX in $(seq 0 1 $MAX); do
    IRQ=$(cat /proc/interrupts | grep $1-rxtx-$INDEX"$" | sed 's/\s\([0-9]\+\)\(.*\)/\1/g')

    # Apply the mask to the current IRQ
    printf "%X" $MASK > /proc/irq/$IRQ/smp_affinity

    # Duplicate the next mask value
    let "MASK=$MASK+$MASK"
done
```

### make it persistent

Those configurations need to be persistent when the system is power cycled. To do that one can leverage the */sbin/ifup-local* script ;)

## Suricata configuration

...
