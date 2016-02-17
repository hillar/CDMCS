# Tuning

## eth0

#### Verify that the offloading features are off

ethtool -k eth1

#### Verify the send and receive buffers, note how the current hardware values are the same as the pre-set maximum values

ethtool -g eth1

#### Verify the flow hash indirection table

ethtool -x eth1

#### Verify that the IRQ affinity is set correctly, the output bellow shows only the first 4 CPU's

cat /proc/interrupts | grep 'CPU\|eth1'
