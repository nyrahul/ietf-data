6Lo Fragment Forwarding Performance Report
==========================================

This document reports the performance of fragment forwarding vis-a-vis existing
per-hop reassembly in 802.15.4 networks.

Related Drafts
--------------

Fragment Forwarding drafts
``````````````````````````
1) `Virtual reassembly buffers in 6LoWPAN`_
2) `LLN Minimal Fragment Forwarding`_

Per-hop reassembly
``````````````````
RFC4944_ Transmission of IPv6 Packets over IEEE 802.15.4 Networks

Our use-case/motivation for fragment forwarding experimentation
---------------------------------------------------------------
We use 802.15.4 in single channel mode of operation for metering use-case. The
security solution is based on EAP-PANA for network authentication and the
headers in EAP-PANA are too bulky (for 802.15.4) resulting in packet
fragmentation during authentication phase. Our aim was to check the impact of
fragment forwarding on the authentication process which could possibly
impact/reduce network convergence/time.

Test Tools/Code
---------------
1. Whitefield_ Framework (with NS3 as AirLine and Contiki as Stackline) on Ubuntu 18.04 x86_64.
2. `Fragment Forwarding implementation`_ in Contiki by `Rabi Sahoo`_

Test Topology
-------------
1. Number of nodes: 50
2. Topology: Grid (10x5) [Sample1_], [Sample2_], [Sample3_]
3. Inter-Node distance in the grid: x=80m, y=100m
4. Wireless Configuration: 802.15.4 in 2.4GHz range with single channel (channel 26) unslotted CSMA mode of operation
5. Max retry at mac layer: 3 (with exp backoff)
6. Mac MTU = 127B

Data transmission scheme
------------------------
Every node sends data every X seconds, where X is 40s, 80s, and 160s. After X
seconds are elapsed, the node initiates transmission after a randomized delay
in the range of 1 to 10 seconds. This ensures that all the nodes do not start
transmitting at the same time.

The size of the payload is varied between 256, 512, and 1024 bytes. All the
nodes transmit the data with the destination as the border router when the
payload is finally accounted for.

Test observations/steps
-----------------------
1. Check the overall Packet Delivery Rate i.e. how many complete payloads finally reach the BR?
2. Check the min/max/avg latency i.e. time taken for payload to reach BR.
3. Check the number of retries/failures in the mac layer
4. Check the number of parent switches during the whole experiment
5. Run every experiment 3 times
6. Archive topology, pcap, config for every run

Data
----

Note:

1. Per hop reassembly refers to existing way of doing fragmentation/reassembly where every intermediate node does full reassembly before transmitting further.
2. Wih fragment forwarding refers to the new technique as proposed by the mentioned drafts.
3. Attempt 1/2/3 specifies attempts required for successful packet transmission at mac layer. The attempts are for all the nodes combined.
4. PrntSw = Number of RPL parent switches

Experiment1: Send Rate=40s, UDP Payload size=256B
`````````````````````````````````````````````````
+--------------------+---+-----+----------+----------+----------+---------+-------------------------+----------+
| Scenario           | # | PDR | Attempt1 | Attempt2 | Attempt3 | Failure | Latency(ms) min/max/avg | # PrntSw |
+====================+===+=====+==========+==========+==========+=========+=========================+==========+
| Per Hop Reassembly | 1 | 98% | 25398    | 393      | 46       | 42      | 20/424/120              | 27       |
|                    +---+-----+----------+----------+----------+---------+-------------------------+----------+
|                    | 2 | 98% | 25757    | 380      | 51       | 36      | 19/412/122              | 30       |
|                    +---+-----+----------+----------+----------+---------+-------------------------+----------+
|                    | 3 | 99% | 29492    | 414      | 58       | 34      | 18/423/122              | 30       |
+--------------------+---+-----+----------+----------+----------+---------+-------------------------+----------+
| With Frag Fwding   | 1 | 89% | 23106    | 2322     | 1047     | 297     | 16/370/118              | 32       |
| without pacing     +---+-----+----------+----------+----------+---------+-------------------------+----------+
|                    | 2 | 90% | 21393    | 2191     | 1002     | 271     | 14/365/120              | 32       |
|                    +---+-----+----------+----------+----------+---------+-------------------------+----------+
|                    | 3 | 91% | 29199    | 3036     | 1277     | 326     | 18/420/125              | 42       |
+--------------------+---+-----+----------+----------+----------+---------+-------------------------+----------+
| With Frag Fwding   | 1 | 97% | 25365    | 1419     | 309      | 84      | 50/332/145              | 16       |
| pacing interval    +---+-----+----------+----------+----------+---------+-------------------------+----------+
| of 50ms            | 2 | 96% | 24282    | 1318     | 326      | 95      | 43/353/140              | 14       |
|                    +---+-----+----------+----------+----------+---------+-------------------------+----------+
|                    | 3 | 96% | 23605    | 1366     | 296      | 98      | 30/553/137              | 21       |
+--------------------+---+-----+----------+----------+----------+---------+-------------------------+----------+

Experiment2: Send Rate=80s, UDP Payload size=512B
`````````````````````````````````````````````````
+--------------------+---+-----+----------+----------+----------+---------+-------------------------+----------+
| Scenario           | # | PDR | Attempt1 | Attempt2 | Attempt3 | Failure | Latency(ms) min/max/avg | # PrntSw |
+====================+===+=====+==========+==========+==========+=========+=========================+==========+
| Per Hop Reassembly | 1 | 97% | 26220    | 364      | 35       | 46      | 33/650/213              | 27       |
|                    +---+-----+----------+----------+----------+---------+-------------------------+----------+
|                    | 2 | 98% | 29468    | 414      | 53       | 42      | 32/569/218              | 26       |
|                    +---+-----+----------+----------+----------+---------+-------------------------+----------+
|                    | 3 | 97% | 29578    | 314      | 28       | 42      | 34/550/222              | 47       |
+--------------------+---+-----+----------+----------+----------+---------+-------------------------+----------+
| With Frag Fwding   | 1 | 70% | 19254    | 2341     | 1148     | 536     | 34/2723/228             | 38       |
| without pacing     +---+-----+----------+----------+----------+---------+-------------------------+----------+
|                    | 2 | 65% | 23051    | 2864     | 1318     | 684     | 28/545/230              | 60       |
|                    +---+-----+----------+----------+----------+---------+-------------------------+----------+
|                    | 3 | 66% | 23636    | 3128     | 1346     | 735     | 34/540/221              | 45       |
+--------------------+---+-----+----------+----------+----------+---------+-------------------------+----------+
| With Frag Fwding   | 1 | 90% | 28509    | 1547     | 409      | 247     | 176/514/284             | 49       |
| pacing interval    +---+-----+----------+----------+----------+---------+-------------------------+----------+
| of 50ms            | 2 | 94% | 31071    | 1874     | 372      | 102     | 187/498/285             | 22       |
|                    +---+-----+----------+----------+----------+---------+-------------------------+----------+
|                    | 3 | 92% | 31609    | 1832     | 405      | 163     | 135/2425/311            | 19       |
+--------------------+---+-----+----------+----------+----------+---------+-------------------------+----------+

Experiment3: Send Rate=160s, UDP Payload size=1024B
`````````````````````````````````````````````````
+--------------------+---+-----+----------+----------+----------+---------+-------------------------+----------+
| Scenario           | # | PDR | Attempt1 | Attempt2 | Attempt3 | Failure | Latency(ms) min/max/avg | # PrntSw |
+====================+===+=====+==========+==========+==========+=========+=========================+==========+
| Per Hop Reassembly | 1 | 92% | 30372    | 398      | 50       | 32      | 70/12533/385            | 22       |
|                    +---+-----+----------+----------+----------+---------+-------------------------+----------+
|                    | 2 | 95% | 30417    | 374      | 42       | 63      | 60/2173/410             | 20       |
|                    +---+-----+----------+----------+----------+---------+-------------------------+----------+
|                    | 3 | 96% | 30536    | 416      | 50       | 52      | 62/1156/367             | 19       |
+--------------------+---+-----+----------+----------+----------+---------+-------------------------+----------+
| With Frag Fwding   | 1 | 55% | 20737    | 2673     | 1230     | 818     | 64/4270/412             | 62       |
| without pacing     +---+-----+----------+----------+----------+---------+-------------------------+----------+
|                    | 2 | 52% | 21479    | 2880     | 1366     | 901     | 61/4898/393             | 60       |
|                    +---+-----+----------+----------+----------+---------+-------------------------+----------+
|                    | 3 | 52% | 21868    | 2969     | 1314     | 973     | 63/10987/421            | 87       |
+--------------------+---+-----+----------+----------+----------+---------+-------------------------+----------+
| With Frag Fwding   | 1 | 81% | 28669    | 1356     | 378      | 397     | 426/791/525             | 72       |
| pacing interval    +---+-----+----------+----------+----------+---------+-------------------------+----------+
| of 50ms            | 2 | 82% | 33214    | 1955     | 501      | 233     | 384/810/544             | 31       |
|                    +---+-----+----------+----------+----------+---------+-------------------------+----------+
|                    | 3 | 82% | 29958    | 1802     | 432      | 202     | 453/775/543             | 31       |
+--------------------+---+-----+----------+----------+----------+---------+-------------------------+----------+

Observations
------------

1) Fragment forwarding seems to have a negative impact on the overall performance.
2) The PDR is heavily impacted and the average latency is also reported to be higher in general.
3) In general with fragment forwarding, there are more failures reported at MAC layer.
4) The latency differences between two modes are statistically insignificant.
5) In general with fragment forwarding, there are more number of parent switches. This can be attributed to transmission failures.

Inferrence
----------

1. In general the number of mac attempts/failure seems to have drastically
increased in case of fragment forwarding. This is possibly because with
fragment forwarding it is possible that multiple nodes might be in a state of
transmission at the same time resulting in higher collisions.
2. While fragment forwarding seems to be an interesting feature, the usability
might be a problem especially with shared channels or shared cells in case of
6TiSCH. In case of dedicated cells, the performance of fragment forwarding
"might" be better than per hop reassembly, but this currently is pure
speculation and we do not have any data for 6TiSCH env.

Word about data reported by Yatch_ during IETF 101
-----------------------------------------------------------------------------
`Yatch experiment`_ (check slide 16) primarily checked the impact of buffer
unavailability on a bottleneck parent/grand-parent node. The 6TiSCH simulator
used in the experiment did not have realistic wireless simulation. Yatch's data
proved that fragment forwarding works much better when there is a bottleneck
parent node which cannot hold enough reassembly buffers and has to drop
previous uncompleted partially-reassembled payloads to make way for a new one.
Essentially the analysis was more towards memory implications where fragment
forwarding proved much better.

Links
-----
1. `Raw Data <https://github.com/rabinsahoo/pcap_topo>`_ for the experiments conducted (contains pcap, topology, config)
2. Whitefield_ Framework
3. Contiki with `Fragment Forwarding implementation`_
4. `Yatch experiment`_

.. _Virtual reassembly buffers in 6LoWPAN: https://datatracker.ietf.org/doc/draft-ietf-lwig-6lowpan-virtual-reassembly/
.. _LLN Minimal Fragment Forwarding: https://datatracker.ietf.org/doc/draft-watteyne-6lo-minimal-fragment/
.. _RFC4944: https://tools.ietf.org/html/rfc4944
.. _Whitefield: https://github.com/whitefield-framework/whitefield
.. _Rabi Sahoo: https://github.com/rabinsahoo
.. _Fragment Forwarding implementation: https://github.com/rabinsahoo/6lowpan_fragment_forwarding
.. _Sample1: https://github.com/rabinsahoo/pcap_topo/blob/master/FragmentForwardingSim/pos_1024_r1.png
.. _Sample2: https://github.com/rabinsahoo/pcap_topo/blob/master/FragmentForwardingSim/pos_1024_r2.png
.. _Sample3: https://github.com/rabinsahoo/pcap_topo/blob/master/FragmentForwardingSim/pos_1024_r3.png
.. _Yatch: https://github.com/yatch
.. _Yatch experiment: https://datatracker.ietf.org/meeting/101/materials/slides-101-6lo-fragmentation-design-team-formation-update-00.pdf
