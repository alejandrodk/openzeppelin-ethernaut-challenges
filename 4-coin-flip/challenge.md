# Coin Flip

## Problem

This is a coin flipping game where you need to build up your winning streak by guessing the outcome of a coin flip. To complete this level you'll need to use your psychic abilities to guess the correct outcome 10 times in a row.

Things that might help

- See the Help page above, section "Beyond the console"

## Solution

The problem with the contract is that it tries to get a random result using the **current block number**, but this is not random at all, since the result is based on the **current block number**, we just need to copy the contract logic to replicate the result in each execution.

We need to create an Smart Contract that interact with CoinFlip contract (See */4-coin-flip/solution.sol*).

1- We copy the execution of the original contract

```Solidity
uint256 blockValue = uint256(blockhash(block.number - 1));

if (lastHash == blockValue) revert();

lastHash = blockValue;
uint256 coinFlip = blockValue / FACTOR;
bool side = coinFlip == 1;
```

2- Send result to the contract.

```Solidity
bool isRight = ICoinFlip(_contractTarget).flip(side);
```

It's necessary to await a few seconds after each transaction due to the `if (lastHash == blockValue) revert()` validation. This statement will revert the transaction if block number was the same as the last invocation.

[Workshop contract (Rinkeby)](https://rinkeby.etherscan.io/address/0xd991431d8b033ddcb84dad257f4821e9d5b38c33)

## Usefull links

[Interact with external contracts](https://solidity-by-example.org/interface)