pragma solidity ^0.8.26;

// SPDX-License-Identifier: GPL-3.0-or-later

contract bongo1 {

/* A fully onchain betting contract that doesn't pay out to
"the house". All funds go to miners or the winners. This is an
early version and will likely only be a hash stack checker.
The final game version will not have the cashout function, or
will disable it.

This version increases your score with each transaction where
you prove that you have another value from a "hash stack". You
can create these with ethers.js:

x=ethers.keccak256("0x434343")
0x2a696f0da6ad70d56f54aa53d0287d8d7fc5a236636c48db25d77485f1e76fb4
x=ethers.keccak256(x)
0x39290c9db6d526b6585c4cc8f3bd03bfe3f15edf420b8035a41b3c81c3985de2
x=ethers.keccak256(x)
0xef8429d00c4d8610d8b4fba3be3eb26d2f79e375cd42445fd40558536e924800
x=ethers.keccak256(x)
0xab5ab7d4522328706c0f09e36675e8c564b0804e1e6a58f9557325c7278906aa
x=ethers.keccak256(x)
0xd0e02433413f5bc6f89f623273f092aea8a233e7b93b0ad62f258b3b0a378242
x=ethers.keccak256(x)
0x1e8cae1808d8f5dafa457ab263a809e4eee57f22773fba0c76a3ffd16e9f103e

gas
71751
39939
22635
22635
71830

*/


mapping(address => bytes) public map;
mapping(address => uint16) public score;

bytes1 public gamehash;
bytes1 public left;
bytes1 public right;
address public lastAddress;

uint256 public thisblock;

uint256 public gas;

// event Logger(address addy);


function scoreTest (bytes1) view   private returns (uint16)
    {
       if(gamehash > 0xf0)
         return uint16(score[msg.sender]) + 9;
       if(gamehash > 0xe0)
         return uint16(score[msg.sender]) + 8;
       if(gamehash > 0xd0)
         return uint16(score[msg.sender]) + 7;
       if(gamehash > 0xc0)
         return uint16(score[msg.sender]) + 6;
       if(gamehash > 0xb0)
         return uint16(score[msg.sender]) + 5;
       if(gamehash > 0xa0)
         return uint16(score[msg.sender]) + 4;
       if(gamehash > 0x90)
         return uint16(score[msg.sender]) + 3;
       if(gamehash > 0x80)
         return uint16(score[msg.sender]) + 2;
       if(gamehash > 0x70)
         return uint16(score[msg.sender]) + 1;

    return uint16(score[msg.sender]);
    }

function hashStack (
     bytes memory hash
)  public 
    { 

/*  This game is meant to be played by Godot (but for now is just Javascript. Each block is a turn. Players will 
need to get their move going quickly. Their game engine would know how to sign
their message. They could miss a block if they wait too long and their play
would go into the next block. These factors should discourage front-runners. The game
should naturally lean into the discrepancy between tx, block, and play. I think
that a calculation should be done at the beginning of a new block. That is to say
that at the beginning of the first transaction in a block, a special check must be done
to trigger the action.     */

if(block.number != thisblock)
    {
    /* this must be the first tx of the block for this game */

   // emit Logger(msg.sender);
    /* set to not run again until the next block */
    thisblock = block.number;
    lastAddress = msg.sender;
    }
    
    // gamehash = blockhash(block.number-1)[3]; 
    // gamehash = hash % 16;
    gas = gasleft() % 16;
/* https://ethereum.stackexchange.com/questions/99340/error-comparing-two-bytes-memory */

    if(keccak256(abi.encodePacked(keccak256(hash))) == keccak256(abi.encodePacked(map[msg.sender])))
       {
       gamehash = keccak256(bytes.concat(blockhash(block.number-1),abi.encode(hash)))[3];
       score[msg.sender] = scoreTest(gamehash);
       left <<= 1;
       right >>= 1;
       }
    else
       score[msg.sender] = 0;

    map[msg.sender] = abi.encodePacked(hash);
    }

   fallback () external payable {}
   receive () external payable {}
}
