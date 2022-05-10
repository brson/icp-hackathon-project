# Another look at Dfinity (Internet Computer)

It's been more than a year since my [last look at programming on Dfinity].
With their May 2022 hackathon it was a good opportunity to try again.


## 2022/05/10

Day 1 of the hackathon.
We have a few ideas for the project we want to make,
but are not sure of the capabilities of ICP,
so the first thing we are going to do is go through the tutorials,
create and deploy a simple canister with backend and frontend
that can read and write certified data.

[Certified data] seems to be the large-scale storage mechanism of ICP.
ICP is unique in existing blockchains in that it appears to incorprate
decentralized storage as a first-class feature &mdash; there should be
no need to leverage e.g. IPFS to store big blogs. In theory this
should open up new possibilities for the kinds of apps one might deploy,
but from perusing the documentation I don't understand how to use the feature.

ICP's other storage mechanism is [TODO], which is a kind of persistent RAM,
suitable for small state.

OK, let's do some tutorials.

