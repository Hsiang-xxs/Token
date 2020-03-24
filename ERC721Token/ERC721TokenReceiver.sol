pragma solidity >=0.4.20 <0.7.0;

import "./ERC721TokenReceiverInterface.sol";

contract ERC721TokenReceiver is ERC721TokenReceiverInterface {
    /**
     * @dev Magic value to be returned upon successful reception of an NFT
     *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
     *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
     */
  bytes4 constant ERC721_RECEIVED = bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
  
  function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4) {
      return ERC721_RECEIVED;
  }
}
