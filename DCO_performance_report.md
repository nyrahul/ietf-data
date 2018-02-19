## Table of Contents
[Introduction](#introduction)

[Implementation Description](#implementation-description)

[Test Tools](#test-tools)

[Test Configuration](#test-configuration)

[Impact in regular case](#impact-in-regular-case)

[Parent Switch because of lost-connectivity](#impact-in-cases-where-link-connectivity-is-lost)

# Introduction
RPL ([RFC6550](https://tools.ietf.org/html/rfc6550 "RPL")) is a routing protocol for Low power and lossy networks. This works tries to improve upon the route invalidation mechanism present in RPL which describes use of No-Path DAO (NPDAO) for route invalidation. Our [draft](https://tools.ietf.org/html/draft-ietf-roll-efficient-npdao-01) specifies change in this (NPDAO) signaling mechanism (both syntax and semantics) and introduces a new message called DCO (DODAG Cleanup Object) for more efficient route invalidation.

This page explains the performance impact of choosing DCO over NPDAO for route invalidation purpose.

# Implementation description
The implementation is done in a fork of 
[Contiki-whitefield](https://github.com/whitefield-framework/contiki/tree/npdao "NPDAO Branch of contiki-whitefield") 
(done by [Rabi](https://github.com/rabinsahoo)).

Describe the cases when NPDAO is used and DCO is used?

Implementation Statistics (LOC, RAM, ROM)
Path-Sequence was not handled in Contiki. We had to add it. We do not consider that as part of this new signalling changes.

# Test Tools
Tools used

# Test Configuration
Config

# Impact in regular case
Regular case refers to the scenario where parent switching happens not due to link unavailability but because the metrics deteoriarate i.e. the links are available such that NPDAO should still work. We wanted to understand the impact of control-traffic due to switching to DCO in such cases.

1. If an implementation switches to DCO in place of NPDAO, what is the impact on RPL-control-traffic?

Rationale for reduced control traffic in this scenario:

DCO usually flows between its subDODAG only.

# Impact in cases where link connectivity is lost
Parent switching can happen because the nodes lose connectivity to its parent node. In such cases, NPDAO won't work at all. DCO will continue to work in such cases and will reduce the impact of stale entries in the network.

