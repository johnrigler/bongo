This image shows my work flow. I open up the javascript console and use it
as a REPL (Read Eval Print Loop) to create a structure of functions and data
which I then eventually ship over to the screen. Everything is 100% Web3/IPFS
ready immediately because of how I do this.

<img src="Screen Shot 2024-10-03 at 9.24.57 PM.png">

The main idea behind this project is pseudo-randomness through a commitment to what 
I call the "hash stack". That is literally what it is. In this early version of the
game, we are simply interating down through each players hash and manipulating a
number. When we are done (probably after only 3 rounds instead of 10) someone will be
declared the winner. If a Sybil attack is possible, it should be manifested here. 

When this is inevitably moved from "couch game" mode to a fully functioning on-chain
game of change (with money built in), it will not use some browser extension like metamask.
Instead, each player will paste their private key into the trusted resource. It can be trusted
because it either lives entirely on their computer or in IPFS and can be audited and
understood not to change. The question of a Sybil attack will of course arise in that 
version as well. The solution is to have all players write to each sequential block. As I 
said, this won't be done with Metamask, and thus can be better timed.

With all players writing to the same block, the first transaction of the game in each block can
be calculated and any winning from the previous round will be awarded. In this way, I believe
that no player (even in collaboration with miners) could understand the final winning hand. This is
because each player introduces a new PRAND element with their turn. This element is the next value
from the hash stack. I call it the previous element's "hash root" as it is what the previously 
revealed hash was created from. This has the unique characteristic of being pre-determined (after the
first round), verifyable within Solidity (with the keccak256 function), and unknown to the potential
cohort of Sybil attackers.

I have done some work on the Solidity side of this and will include that contract as well. The two
pieces do not attach yet, but are simply Riskiest Assumption Tests.
