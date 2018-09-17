# 6Lo Fragment Forwarding Performance Report

## Related Drafts:

[Virtual reassembly buffers in 6LoWPAN](https://datatracker.ietf.org/doc/draft-ietf-lwig-6lowpan-virtual-reassembly/)

[LLN Minimal Fragment Forwarding](https://datatracker.ietf.org/doc/draft-watteyne-6lo-minimal-fragment/)

## Our use-case/motivation for fragment forwarding experimentation
We use 802.15.4 in single channel mode of operation for metering use-case. The security is based on EAP-PANA and the headers are too bulky resulting in packet fragmentation during authentication phase. Our aim was to check the impact of fragment forwarding on the authentication process which could possibly impact network convergence.

## Test Tools/Code
1. [Whitefield Framework](https://github.com/whitefield-framework/whitefield) (with NS3 as AirLine and Contiki as Stackline) on Ubuntu 18.04 x86_64.
2. Fragment Forwarding [implementation](https://github.com/rabinsahoo/6lowpan_fragment_forwarding) in Contiki by [Rabi Sahoo](https://github.com/rabinsahoo)

## Test Topology
1. Number of nodes: 50
2. Topology: Grid (10x5) [Sample1](https://github.com/rabinsahoo/pcap_topo/blob/master/FragmentForwardingSim/pos_1024_r1.png), [Sample2](https://github.com/rabinsahoo/pcap_topo/blob/master/FragmentForwardingSim/pos_1024_r2.png), [Sample3](https://github.com/rabinsahoo/pcap_topo/blob/master/FragmentForwardingSim/pos_1024_r3.png)
3. Inter-Node distance: x=TODOm, y=TODOm
4. Wireless Configuration: 802.15.4 in 2.4GHz range with single channel (channel 26) mode of operation
5. Max retry at mac layer: 3 (with exp backoff)
6. Mac MTU = 127B

### Data transmission scheme
Every node sends data every X seconds, where X is 40s, 80s, and 160s. After X seconds are elapsed, the node initiates transmission after a randomized delay in the range of 1 to 10 seconds. This ensures that all the nodes do not start transmitting at the same time.

The size of the payload is varied between 256, 512, and 1024 bytes. All the nodes transmit the data with the destination as the border router when the payload is finally accounted for.

### Test observations/steps
1. Check the overall Packet Delivery Rate i.e. how many complete payloads finally reach the BR?
2. Check the min/max/avg latency i.e. time taken for payload to reach BR.
3. Check the number of retries/failures in the mac layer
4. Check the number of parent switches during the whole experiment
5. Run every experiment 3 times
6. Archive topology, pcap, config for every run

## Data

Note:
1. Per hop reassembly refers to existing way of doing fragmentation/reassembly where every intermediate node does full reassembly before transmitting further.
2. Wih fragment forwarding refers to the new technique as proposed by the mentioned drafts.
3. Attempt 1/2/3 specifies attempts required for successful packet transmission at mac layer. The attempts are for all the nodes combined.
4. PrntSw = Number of RPL parent switches

### Experiment1: Send Rate=40s, UDP Payload size=256B
| Scenario | sr# | PDR | Attempt1 | Attempt2 | Attempt3 | Failure | Latency(ms) min/max/avg | # PrntSw |
|----------|-----|-----|----------|----------|----------|---------|-------------------------|----------|
| Per hop reassembly | 1 | 98% | 25398 | 393 | 46 | 42 | 20/424/120 | 27 |
| Per hop reassembly | 2 | 98% | 25757 | 380 | 51 | 36 | 19/412/122 | 30 |
| Per hop reassembly | 3 | 99% | 29492 | 414 | 58 | 34 | 18/423/122 | 30 |
| With Frag Fwding   | 1 | 89% | 23106 | 2322 | 1047 | 297 | 16/370/118 | 32 |
| With Frag Fwding   | 2 | 90% | 21393 | 2191 | 1002 | 271 | 14/365/120 | 32 |
| With Frag Fwding   | 3 | 91% | 29199 | 3036 | 1277 | 326 | 18/420/125 | 42 |

### Experiment2: Send Rate=80s, UDP Payload size=512B
| Scenario | sr# | PDR | Attempt1 | Attempt2 | Attempt3 | Failure | Latency(ms) min/max/avg | # PrntSw |
|----------|-----|-----|----------|----------|----------|---------|-------------------------|----------|
| Per hop reassembly | 1 | 97% | 26220 | 364 | 35 | 46 | 33/650/213 | 27 |
| Per hop reassembly | 2 | 98% | 29468 | 414 | 53 | 42 | 32/569/218 | 26 |
| Per hop reassembly | 3 | 97% | 29578 | 314 | 28 | 42 | 34/550/222 | 47 |
| With Frag Fwding   | 1 | 70% | 19254 | 2341 | 1148 | 536 | 34/2723/228 | 38 |
| With Frag Fwding   | 2 | 65% | 23051 | 2864 | 1318 | 684 | 28/545/230 | 60 |
| With Frag Fwding   | 3 | 66% | 23636 | 3128 | 1346 | 735 | 34/540/221 | 45 |

### Experiment3: Send Rate=160s, UDP Payload size=1024B
| Scenario | sr# | PDR | Attempt1 | Attempt2 | Attempt3 | Failure | Latency(ms) min/max/avg | # PrntSw |
|----------|-----|-----|----------|----------|----------|---------|-------------------------|----------|
| Per hop reassembly | 1 | 92% | XXXXX | XXX | XX | XX | XXX | XX |
| Per hop reassembly | 2 | 95% | 30417 | 374 | 42 | 63 | 60/2173/410 | 20 |
| Per hop reassembly | 3 | 96% | 30536 | 416 | 50 | 52 | 62/1156/367 | 19 |
| With Frag Fwding   | 1 | 55% | 20737 | 2673 | 1230 | 818 | 64/4270/412 | 62 |
| With Frag Fwding   | 2 | 52% | 21479 | 2880 | 1366 | 901 | 61/4898/393 | 60 |
| With Frag Fwding   | 3 | 52% | 21868 | 2969 | 1314 | 973 | 63/10987/421 | 87 |

## Links
1. [Raw Data](https://github.com/rabinsahoo/pcap_topo)
2. Whitefield Framework
3. Contiki Implementation with Fragment Forwarding
