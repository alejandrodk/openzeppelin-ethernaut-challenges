// SPDX-License-Identifier: MIT
pragma solidity >0.7.0;

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract Telephone {
    function changeOwner(address _contract, address newOwner) external {
        ITelephone(_contract).changeOwner(newOwner);
    }
}
