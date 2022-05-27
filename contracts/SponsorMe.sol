//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SponsorMe {
  struct Memo {
    string message;
    uint256 credits;
  }
  address payable public owner;
  address payable public factoryAddress;
  mapping(address => Memo) public memos;

  constructor(address payable _owner) {
    owner = _owner;
    factoryAddress = payable(msg.sender);
  }

  modifier isOwner(address _address) {
    require(_address == owner, "Only Owner can make this call!");
    _;
  }

  modifier isFactoryAddress() {
    require(msg.sender == factoryAddress, "Only factoryContract can make this call!");
    _;
  }

  function sendCredits(string memory _message) public payable {
    require(msg.value > 0, "Cannot send zero funds!");

    memos[msg.sender] = Memo(_message, msg.value);
  }

  function withdrawCredits(address _sender) public isFactoryAddress isOwner(_sender) {
    require(address(this).balance > 0, "Not enough balance to withdraw!");

    uint256 totalBalance = address(this).balance;
    uint256 percentageCut = address(this).balance / 10;
    uint256 remainingBalance = totalBalance - percentageCut;

    factoryAddress.transfer(percentageCut);
    owner.transfer(remainingBalance);
  }
}
