## Table of Contents
[Introduction](#introduction)

[Implementation Description](#implementation-description)

[Test Tools](#test-tools)

[Test Configuration](#test-configuration)

[Data Collection Method](#data-collection-method)

[Scenario 1: Parent Switch due to metric deterioration](#scenario-1-parent-switch-due-to-metric-deterioration)

[Scenario 2: Parent Switch because of connectivity loss](#scenario-2-parent-switch-because-of-connectivity-loss)

# Introduction
RPL ([RFC6550](https://tools.ietf.org/html/rfc6550 "RPL")) is a routing protocol for Low power and lossy networks. This works tries to improve upon the route invalidation mechanism present in RPL which describes use of No-Path DAO (NPDAO) for route invalidation. Our [draft](https://tools.ietf.org/html/draft-ietf-roll-efficient-npdao-01) specifies change in this (NPDAO) signaling mechanism (both syntax and semantics) and introduces a new message called DCO (DODAG Cleanup Object) for more efficient route invalidation.

This page explains the performance impact of choosing DCO over NPDAO for route invalidation purpose.

# Implementation description
The implementation is done in a fork of 
[Contiki-whitefield](https://github.com/whitefield-framework/contiki/tree/npdao "NPDAO Branch of contiki-whitefield") 
(done by [Rabi](https://github.com/rabinsahoo)).

The implementation retains the NPDAO mechanism as it is and builds DCO on top of it. DCO is used only when parent-switching procedure is initiated by the node. In other cases, such as, on route lifetime expiry or other internal error scenarios the node would still use NPDAO messaging to invalidate the route.

## Implementation Statistics:
1. Lines of Code: ~120 [contiki-changes-for-DCO](https://github.com/contiki-os/contiki/commit/e8ea7790640f96c4a48ca1f8d95e1b7f7ac017f9)
2. Additional RAM: 0 ... The implementation adds use of Path-Sequence which is defined in base RPL and is currently missing in Contiki. Thus RAM-increase due to Path-Sequence addition is not considered. Addition of Path-Sequence results in 1 extra byte per routing entry.
3. Flash: XX KB

The implementation has further scope to be optimized by combining APIs needed to construct DAO and DCO since most of the buffer encoding/decoding remains same in both cases.

# Test Tools
* Simulation Framework: [Whitefield](https://github.com/whitefield-framework/whitefield "Whitefield-Framework") (Internally using [NS3 lr-wpan](https://github.com/nsnam/ns-3-dev-git/tree/master/src/lr-wpan) module in 2.4Ghz mode with single channel unslotted CSMA mode of operation)
* Contiki as the network stack

# Test Configuration
All the tests were done on a laptop [HP 820 G2](https://support.hp.com/in-en/document/c04543486)

1. cfg_n50_udp30

Config | Value
------ | -----
#nodes | 50
UDP Send Time | 30sec
Formation | Grid
Sample Topology | [TODO](...)

# Data Collection Method
1. Start the network
2. Wait pre-determined time for network to form
3. [optional] Start a thread to [change_node_location](#thread-change_node_location) dynamically
4. For n in total_samples (scripts:[get_connectivity_snapshot.sh](https://github.com/nyrahul/whitefield/blob/npdao/scripts/get_connectivity_snapshot.sh)):
    1. Get connectivity snapshot i.e. unconnected nodes, stale entries, RPL control traffic stats, UDP send/recv stats, elapsed time
    2. wait for inter-sample-interval

### Thread change_node_location:
The aim of this thread is to move the 6LR nodes such that dependent (sub)child nodes start realigning to new parents resulting in route invalidation procedure been initiated.
1. Get connected node cardinality for the 6LR node. Cardinality refers to the number of child nodes connected through this 6LR. Note that we do not use routing table size because it may contain stale entries.
2. Get the node with highest cardinality.
3. Change this node's location such that the wireless range is out of reach
4. Will result in (sub)child nodes in switching parent nodes causing NPDAO or DCO been initiated.

# Scenario 1: Parent Switch due to metric deterioration
In case where the parent switch happens due to metric deterioration, the old parent is still reachable albeit with bad metrics. NPDAO which is required to be sent through old parent might still work in this case. We wanted to check following in this context:
1. How does DCO fares (in terms of stale routes retained on old path) in comparison to NPDAO?
    * Use of DCO resulted in less number of stale routes consistently. But the percentage difference was not much since NPDAO also would have succeeded in most cases.
2. Impact on control overhead of using DCO in place of NPDAO
    * DCO showed consistenly reduced control overhead. This was attributed to the fact the DCO traversed only the subDODAG rooted at the common ancestor.
3. Impact on packet delivery rate
    * There was no marked difference in the packet delivery rate.


# Scenario 2: Parent Switch because of connectivity loss
Parent switching can happen because the nodes lose connectivity to its parent node. In such cases, NPDAO won't work at all. DCO will continue to work in such cases and will reduce the impact of stale entries in the network.

