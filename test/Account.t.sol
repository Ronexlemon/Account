// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import {BankAccount} from "../src/Account.sol";

contract BankAccountTest is Test{
     event CreateAccount(address indexed _owner,uint256 indexed _amount,uint256  _time);
    event Deposit(address _depositer,uint256 _amount,uint256 _time);
    event  Withdraw (address _withdrawer,uint256 _amount,uint256 _time);
    event  Send(address _from, address _to, uint256 _amount, uint256 _time);
    event  CloseAccount(address _owner,uint256 _balance,uint256 _time);

    BankAccount public bankaccount;
    address public Alice = address(1);
    address public Bob = address(2);
    

    function setUp()public{
        bankaccount = new BankAccount();
        
    }

    function test_CreateAccount()public{
         uint256 currentTime = block.timestamp;
        vm.expectEmit(true, true, false, true);
        emit CreateAccount(address(this), 0.2 ether, currentTime);
        bankaccount.createAccount{value:0.2 ether}();
    }

    function test_CheckUserDetails()public{
        uint256 currentTime = block.timestamp;

             // Create account first
           
            
        bankaccount.createAccount{value: 0.2 ether}();

        // Get user details
       (address owner, uint256 balance,uint256 createdTime ,bool isopen) = bankaccount.account(address(this));

        // Check balance
        assertEq(owner, address(this));
         assertEq(balance, 0.2 ether);
         assertEq(createdTime,currentTime);
         assertEq(isopen,true);
        
    }

    


}

