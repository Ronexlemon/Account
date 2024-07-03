// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract BankAccount{

    //events 
    event CreateAccount(address _owner,uint256 _amount,uint256 _time);
    event Deposit(address _depositer,uint256 _amount,uint256 _time);
    event  Withdraw (address _withdrawer,uint256 _amount,uint256 _time);
    event  Send(address _from, address _to, uint256 _amount, uint256 _time);
    event  CloseAccount(address _owner,uint256 _balance,uint256 _time);

    //struct Account

    struct Account{
        address  owner;
        uint256  balance;
        uint256  createdTime;
        bool  isOpen;
    }

    //array to store Accounts
    Account[] public accounts;

    //mapping an account to owner
    mapping(address =>Account)public account;
    //mapping for account balances -> keeping track
    mapping(address => uint256)public userBalance;


    //function to create account
    function createAccount()public payable{
        require(msg.value >=0 ,"can't open with a negative balance");
        require(!account[msg.sender].isOpen,"already have an open account");
        account[msg.sender] = Account({owner:msg.sender,balance:msg.value,createdTime:block.timestamp,isOpen:true});
        accounts.push(account[msg.sender]);
        userBalance[msg.sender] += msg.value;
        emit CreateAccount(msg.sender,msg.value,block.timestamp);
    }

    //function to deposit
    function deposit(uint256 _amount)public payable {
       
        require(_amount > 0 ,"can't depoit zero balance balance");
        require(account[msg.sender].isOpen,"don't have an account");
        (bool success,) = payable(address(this)).call{value:_amount}("");
        require(success,"failed to depoit");
        userBalance[msg.sender] += _amount;
        account[msg.sender].balance = userBalance[msg.sender];
        emit Deposit(msg.sender, _amount, block.timestamp);

    }

    //function to withdraw
    function withdraw(uint256 _amount)public payable {
        require(account[msg.sender].balance >= _amount,"unsufficient balance");
        require(_amount > 0 ,"can't withdraw zero balance ");
        require(account[msg.sender].isOpen,"don't have an account");
        (bool success,) = payable(msg.sender).call{value:_amount}("");
        require(success,"failed to depoit");
        userBalance[msg.sender] -= _amount;
        account[msg.sender].balance = userBalance[msg.sender];
        emit Withdraw(msg.sender, _amount, block.timestamp);

    }


    //function to send
    function send(uint256 _amount,address  receiver)public payable {
        require(account[msg.sender].balance >= _amount,"unsufficient balance");
        require(_amount > 0 ,"can't send zero balance ");
        require(account[msg.sender].isOpen,"don't have an account");
        (bool success,) = payable(receiver).call{value:_amount}("");
        require(success,"failed to depoit");
        userBalance[msg.sender] -= _amount;
        account[msg.sender].balance = userBalance[msg.sender];
        emit Send(msg.sender,receiver ,_amount, block.timestamp);

    }

    //function to close account
    function close()public payable {
        
        require(account[msg.sender].isOpen,"don't have an account");
        (bool success,) = payable(msg.sender).call{value:userBalance[msg.sender]}("");
        require(success,"failed to depoit");
        userBalance[msg.sender] =0;
        account[msg.sender].balance = 0;
        account[msg.sender].isOpen = false;
        emit CloseAccount(msg.sender,0, block.timestamp);

    }
    

    receive() external payable { }


}