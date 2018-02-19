## Table of Contents
[Introduction](#introduction)

[Implementation Description](#implementation-description)

[Test Tools](#test-tools)

[Test Configuration](#test-configuration)

[Impact in regular case](#impact-in-regular-case)

# Introduction
RPL ([RFC6550](https://tools.ietf.org/html/rfc6550 "RPL")) is a routing protocol for Low power and lossy networks. This works tries to improve upon the route invalidation mechanism present in RPL which describes use of No-Path DAO (NPDAO) for route invalidation. Our [draft](https://tools.ietf.org/html/draft-ietf-roll-efficient-npdao-01) specifies change in this (NPDAO) signaling mechanism (both syntax and semantics) and introduces a new message called DCO (DODAG Cleanup Object) for more efficient route invalidation.

# Implementation description
The implementation is done in a fork of 
[Contiki-whitefield](https://github.com/whitefield-framework/contiki/tree/npdao "NPDAO Branch of contiki-whitefield") 
(done by [Rabi](https://github.com/rabinsahoo)).

Describe the cases when NPDAO is used and DCO is used?

Implementation Statistics (LOC, RAM, ROM)

# Test Tools
Tools used

# Test Configuration
Config

# Impact in regular case
Regular case refers to the scenario where parent switching happens not due to link unavailability but because the metrics deteoriarate i.e. the links are available such that NPDAO should still work. We wanted to understand the impact of control-traffic due to switching to DCO in such cases.

Please note, that 

1. If an implementation switches to DCO in place of NPDAO, what is the impact on RPL-control-traffic?
2. 
