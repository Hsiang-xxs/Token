pragma solidity >=0.4.22 <0.7.0;

/**
 * The ERC-20 Token Standard is https://eips.ethereum.org/EIPS/eip-20
 * ERC20代币的标准API文档链接是https://eips.ethereum.org/EIPS/eip-20
 */

contract ERC20Interface{
    /**
     *The name of the token 
     *代币名称
     */
    string public constant name = 'Token Name';
    
    /**
     *The symbol of the token 
     *代币符号
     */
    string public constant symbol = 'SYM';
    
    /**
     * The number of decimals the token uses
     * 代币小数点位数，代币的最小单位
     * 18 is the most common number of decimal places
     */
    uint8 public constant decimals = 18;
    
    
    
    /**
     * The total token supply
     * 发行的代币总量
     */
    function totalSupply() external view returns (uint);
    
    /**
     * The account balance of another account with address tokenOwner
     * 每个账户地址的代币余额
     */
    function balanceOf(address tokenOwner) external view returns (uint balance);
    
    /**
     * Allows spender to withdraw from your account multiple times, up to the tokens amount
     * 批准被授权账户可以从自己的账户中转移的代币，可分多次进行
     */
    function approve(address spender, uint tokens) external returns (bool success);
    
    /**
     * The amount which spender is still allowed to withdraw from tokenOwner
     * 查看被授权的账户地址还能从代币拥有者那里转移的代币数
     */
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    
    /**
     * Transfers tokens amount of tokens to address to, and MUST fire the Transfer event
     * 从自己的账户交易转移代币到其他账户
     */
    function transfer(address to, uint tokens) external returns (bool success);
    
    /**
     * Transfers tokens amount of tokens from address from to address to, and MUST fire the Transfer event
     * 账户间的交易转移代币
     */
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    
    
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
