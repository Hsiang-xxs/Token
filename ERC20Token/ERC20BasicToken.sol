pragma solidity >=0.4.22 <0.7.0;

interface tokenRecipient{ function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;}

contract ERC20BasicToken {
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;
    //保存每个账户地址的代币余额
    mapping (address => uint256) public balanceOf;
    /**
     * 记录被授权的账户地址还能从代币拥有者那里转移的代币数
     * allowance[owner][spender]
     */
    mapping (address => mapping (address => uint256)) public allowance;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    
    /**
     * 初始化构造
     */
    constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
        //提供的代币总量，数量跟最小的代币单位有关
        totalSupply = initialSupply * 10 ** uint256(decimals); 
        //创建者拥有所有的代币
        balanceOf[msg.sender] = totalSupply;
        name = tokenName;
        symbol = tokenSymbol;
    }
    
    function tokenERC20(uint256 initSupply, string memory tokenName, string memory tokenSymbol) public {
        totalSupply = initSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        name = tokenName;
        symbol = tokenSymbol;
    }
    
    /**
     * 代币交易转移的内部实现
     */
    function _transfer(address _from, address _to, uint _value) internal {
        // 确保目标地址不为0x0，因为0x0地址代表销毁
        require(_to != address(0x0));
        // 检查发送者余额是否足够
        require(balanceOf[_from] >= _value);
        // 确保转移数量为正数个
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        
        //交易转移代币的具体操作
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        
        // 用assert来检查代码逻辑,经过以上交易操作后，代币数量流动是否正确
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
    
     /**
     * 从自己的账户交易转移代币到其他账户
     * 从创建交易者账号发送`_value`个代币到 `_to`账号
     *
     * @param _to 接收者地址
     * @param _value 转移数额
     */
    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }
    
     /**
     * 账号之间代币交易转移
     * 
     * @param _from 发送者地址
     * @param _to 接收者地址
     * @param _value 转移数额
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        //确保指定的发送者账户下交易创建者有足够的代币
        require(_value <= allowance[_from][msg.sender]);
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }
    
    /**
     * 批准被授权账户可以从自己的账户中转移的代币，可分多次进行
     * 允许被授权账户`_spender` 花费不多于 `_value` 个代币
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }
    
    /**
     * 把授权地址_spender变为被允许且可被调用的授权合约接口spender
     *
     * @param _spender 被授权的地址（合约）
     * @param _value 最大可花费代币数
     * @param _extraData 发送给合约的附加数据
     */
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns(bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, address(this), _extraData);
        }
        return true;
    }
    
    /**
     * 销毁交易创建者/自己的账号地址中指定个数的代币
     */
    function burn(uint256 _value) public returns (bool success){
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        emit Burn(msg.sender, _value);
        return true;
    }
    
    /**
     * 销毁指定用户账号里指定个数的代币
     */
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);
        require(allowance[_from][msg.sender] >= _value);
        balanceOf[_from] -= _value;
        allowance[_from][msg.sender] -= _value;
        totalSupply -= _value;
        emit Burn(_from, _value);
        return true;
    }
}
