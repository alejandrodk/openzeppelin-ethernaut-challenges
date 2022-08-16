# Token

## Problem

The goal of this level is for you to hack the basic token contract below.

You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens. Preferably a very large amount of tokens.

Things that might help:

- What is an odometer?

## Solution

The `transfer` function of the contract does not check the value of the `_value` property before performing operations and validations. This can be used to our advantage since it allows us to change the behavior of the numbers stored in the contract at our convenience.

In the hint given by the exercise it is mentioned *"What is an odometer? "*, the analogy helps to understand the problem.
The data type `uint` is an abbreviation of `uint256`, basically an unsigned integer variable can store a number between `0` and `2^256 - 1`. The problem with numeric data is that its behavior can be altered when storing values that exceed the range defined for that data type in some way, this is known as **integer underflow / overflow**.

If we do this operation: `0 - 1` with a **uint** data type, the result will be `2^255`, not `-1`. If we do `2^255 + 1` the result will be `0` and not `2^256`. Hence the analogy of the odometer.

When the contract is created, we start with a value of **20 tokens** stored in the **balances** variable.

```Sol
constructor(uint _initialSupply) public {
    balances[msg.sender] = totalSupply = _initialSupply;
}
```

Within the **transfer** function, a validation is performed on the balance.

```Sol
require(balances[msg.sender] - _value >= 0);
```

When creating the contract we were assigned a balance of **20** tokens, so `balances[msg. sender]` equals `20 tokens`, then we try to validate that our balance is greater or equal to the amount of the transfer, the problem is that if we subtract the amount of our balance (20 tokens) from the amount of the balance + 1 (20 + 1), the value would become `2^256` due to the **underflow** effect, so when the operation `balances[msg.sender] - _value >= 0` is performed, what ends up happening is:
`20 - 21` equals `2^256`.
`2^256 >= 0` equals `true`.

With this in mind, to pass validation we only need to send **21 tokens** in the transaction.

```js
await contract.transfer(player, 21);
```

Once the validation is done, the same problem occurs, we start with a balance of **20 tokens** so when we make
`balances[msg.sender] -= _value` the result is `20 - 21 = 2^256`, our balance should be `-1` or `0` depending on the intention of the contract, but it ends up being something like `115792089237316195423570985008687907853269984665640564039457584007913129639936` (even more than the totalSupply of the contract)

If we check the balance doing `contract.balanceOf(player)` we see that our balance is still `21`, this happens because the `msg.sender` and the `_to` argument correspond to the same address, so our balance is subtracted **21 tokens** and then added again, remaining exactly the same as in the beginning.

The solution is to send the transfer to an account different from ours, this way when doing `balances[_to] += _value` it adds the **21 tokens** to another contract, leaving ours with **2^256 tokens**.

```js
const _address = '0x0000000000000000000000000000000000000000';
await contract.transfer(_address, 21);
```

## Preventative Techniques

### Solidiy version < 8

Overflows are very common in solidity and must be checked for with control statements such as:

```Sol
if(a + c > a) {
  a = a + c;
}
```

An easier alternative is to use OpenZeppelin's SafeMath library that automatically checks for overflows in all the mathematical operators. The resulting code looks like this:

```Sol
a = a.add(c);
```

If there is an overflow, the code will revert.

### Solidity version >= 8

OpenZeppelin's SafeMath is already included since Solidity 8

## Usefull Links

[Integer underflow/overflow](https://docs.soliditylang.org/en/v0.6.0/security-considerations.html#two-s-complement-underflows-overflows)
