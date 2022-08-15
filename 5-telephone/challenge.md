# Fal1out

## Problem

Claim ownership of the contract below to complete this level.

## Solution

According to [Solidity by Example](https://solidity-by-example.org/hacks/phishing-with-tx-origin/), the easiest way to
understand the difference between `msg.sender` and `tx.origin` is with this simply example:

If contract **A** calls **B**, and **B** calls **C**, in **C** `msg.sender` is **B** and `tx.origin` is **A**.

Keeping this in mind, to be able to use the `changeOwner` method with success an bypass the **if** statement, is necessary call the function from a different contract.

## Explanation

While this example may be simple, confusing tx.origin with msg.sender can lead to phishing-style attacks, such as [this](https://blog.ethereum.org/2016/06/24/security-alert-smart-contract-wallets-created-in-frontier-are-vulnerable-to-phishing-attacks/).

An example of a possible attack is outlined below.

1. Use `tx.origin` to determine whose tokens to transfer, e.g.

```Solidity
function transfer(address _to, uint _value) {
  tokens[tx.origin] -= _value;
  tokens[_to] += _value;
}
```

2. Attacker gets victim to send funds to a malicious contract that calls the transfer function of the token contract, e.g.

```Solidity
function () payable {
  token.transfer(attackerAddress, 10000);
}
```

3. In this scenario, tx.origin will be the victim's address (while msg.sender will be the malicious contract's address), resulting in the funds being transferred from the victim to the attacker.

## Preventative Techniques

Use `msg.sender` insted of `tx.origin`

```Solidity
function transfer(address payable _to, uint256 _amount) public {
  require(msg.sender == owner, "Not owner");

  (bool sent, ) = _to.call{value: _amount}("");
  require(sent, "Failed to send Ether");
}
```

## Usefull Links

[Pishing with tx.origin](https://solidity-by-example.org/hacks/phishing-with-tx-origin/)
