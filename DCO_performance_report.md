## Table of Contents
[Introduction](#introduction)

[Implementation Description](#implementation-description)

[Test Tools](#test-tools)

[Test Configuration](#test-configuration)

[Scenario 1: Parent Switch due to metric deterioration](#scenario-1-parent-switch-due-to-metric-deterioration)

[Scenario 2: Parent Switch because of connectivity loss](#scenario-2-parent-switch-because-of-connectivity-loss)

# Introduction
RPL ([RFC6550](https://tools.ietf.org/html/rfc6550 "RPL")) is a routing protocol for Low power and lossy networks. This works tries to improve upon the route invalidation mechanism present in RPL which describes use of No-Path DAO (NPDAO) for route invalidation. Our [draft](https://tools.ietf.org/html/draft-ietf-roll-efficient-npdao-01) specifies change in this (NPDAO) signaling mechanism (both syntax and semantics) and introduces a new message called DCO (DODAG Cleanup Object) for more efficient route invalidation.

This page explains the performance impact of choosing DCO over NPDAO for route invalidation purpose.

# Implementation description
The implementation is done in a fork of 
[Contiki-whitefield](https://github.com/whitefield-framework/contiki/tree/npdao "NPDAO Branch of contiki-whitefield") 
(done by [Rabi](https://github.com/rabinsahoo)).

The implementation retains the NPDAO mechanism as it is and builds DCO on top of it. DCO is used only when parent-switching procedure is initiated by the node. In other cases, such as, on route lifetime expiry or other internal error scenarios the node would still use NPDAO messaging.

Implementation Statistics (LOC, RAM, ROM)
1. Lines of Code: ~50
2. Additional RAM: 0 ... The implementation adds use of Path-Sequence which is defined in base RPL and is currently missing in Contiki. Thus RAM-increase due to Path-Sequence addition is not considered. Addition of Path-Sequence results in 1 extra byte per routing entry.
3. Flash: XX KB

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

# Scenario 1: Parent Switch due to metric deterioration
Regular case refers to the scenario where parent switching happens not due to link unavailability but because the metrics deteoriarate i.e. the links are available such that NPDAO should still work. We wanted to understand the impact of control-traffic due to switching to DCO in such cases.

1. If an implementation switches to DCO in place of NPDAO, what is the impact on RPL-control-traffic?

Rationale for reduced control traffic in this scenario:

DCO usually flows between its subDODAG only.

# Scenario 2: Parent Switch because of connectivity loss
Parent switching can happen because the nodes lose connectivity to its parent node. In such cases, NPDAO won't work at all. DCO will continue to work in such cases and will reduce the impact of stale entries in the network.

