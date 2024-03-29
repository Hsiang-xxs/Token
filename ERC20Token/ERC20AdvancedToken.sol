pragma >=0.4.22 <0.7.0;

import "./owned.sol";
import "./BasicToken.sol";

contract ERC20AdvancedToken is owned, ERC20BasicToken {
    uint256 public sellPrice;
    uint256 public buyPrice;
    mapping (address => bool) public frozenAccount;
    event FrozenAccount(address target, bool frozen);
    
    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor (
        uint256 initialSupply,
        string memory tokenName,
        string memory tokenSymbol
    ) TokenERC20(initialSupply, tokenName, tokenSymbol) payable public {}
    
    function _transfer(address _from, address _to, uint _value) internal {
        require (_to != address(0x0));                      // Prevent transfer to 0x0 address. Use burn() instead
        require (balanceOf[_from] >= _value);               // Check if the sender has enough
        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
        require(!frozenAccount[_from]);                     // Check if sender is frozen
        require(!frozenAccount[_to]);                       // Check if recipient is frozen
        balanceOf[_from] -= _value;                         // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
        emit Transfer(_from, _to, _value);
    }
    
    /// @notice Create `mintedAmount` tokens and send it to `target`
    /// @param target Address to receive the tokens
    /// @param mintedAmount the amount of tokens it will receive
    function mintToken(uint256 mintedAmount, address target) public onlyOwner {
        require(mintedAmount >= 0);
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        emit Transfer(address(0), address(this), mintedAmount);
        emit Transfer(address(this), target, mintedAmount);
    } 
    
    /// @notice freeze Prevent | Allow `target` from sending & receiving tokens
    /// @param target Address to be frozen
    /// @param freeze either to freeze it or not
    function freezeAccount(address target, bool freeze) public onlyOwner {
        frozenAccount[target] = freeze;
        emit FrozenAccount(target, freeze);
    }
    
    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
    /// @param newSellPrice Price the users can sell to the contract
    /// @param newBuyPrice Price users can buy from the contract
    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }
    
    /// @notice Buy tokens from contract by sending ether
    function buy() public payble {
        uint amount = msg.value / buyPrice; // calculates the amount
        _transfer(address(this), msg.sender, amount);
    }
    
    /// @notice Sell `amount` tokens to contract
    /// @param amount amount of tokens to be sold
    function sell(uint amount) public {
        require(balanceOf[msg.sender] >= amount);
        require(address(this).balance >= amount * sellPrice); // checks if the contract has enough ether to buy
        _transfer(msg.sender, address(this), amount); 
        msg.sender.transfer(amount * sellPrice); // sends ether to the seller. It's important to do this last to avoid recursion attacks
    }
    
}
