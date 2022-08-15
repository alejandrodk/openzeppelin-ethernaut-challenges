# Fal1out

## Problem

Claim ownership of the contract below to complete this level.

### Things that might help

- Solidity Remix IDE

## Solution

The first thing you can see is that the contract does not have a valid **constructor method**. Using the contract name as a constructor is deprecated. Additionally, although the Solidity version will support such constructors, the function has a **typo** in the name so it can be called like any other function.

1- by sending any amount of Ether to the `Fal1out` function of the contract the ownership is claimed.

```js
contract.Fal1out({ value: toWei('0.001', 'ether')})
```
