//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./SponsorMe.sol";

contract SponsorMeFactory {
  address payable public owner;
  mapping(address => SponsorMe) public sponsorMeContractList;

  constructor() {
    owner = payable(msg.sender);
  }

  modifier isOwner() {
    require(msg.sender == owner, "Only owner can make this call!");
    _;
  }

  function createSponsorMeContract() public {
    SponsorMe sponsorMe = new SponsorMe(payable(msg.sender));
    sponsorMeContractList[msg.sender] = sponsorMe;
  }

  function sendCreditToSponsorMeOwner(string memory _message, address _sender) public payable {
    require(msg.value > 0, "Cannot send zero funds!");

    SponsorMe sponsorMe = getSponsorMeInstance(_sender);
    sponsorMe.sendCredits{value: msg.value}(_message);
  }

  function withdrawCreditForSponsorMeOwner(address _sender) public {
    SponsorMe sponsorMe = getSponsorMeInstance(_sender);
    sponsorMe.withdrawCredits(msg.sender);
  }

  function getSponsorMeInstance(address _address) public view returns (SponsorMe) {
    require(
      address(sponsorMeContractList[_address]) != address(0),
      "A SponsorMe contract does not exist!"
    );

    return SponsorMe(sponsorMeContractList[_address]);
  }

  function getSponsorMeContractValue(address _address) public view returns (uint256) {
    SponsorMe sponsorMe = getSponsorMeInstance(_address);
    return address(sponsorMe).balance;
  }

  function getFactoryBalance() public view returns (uint256) {
    return address(this).balance;
  }

  function withdrawFactoryCredit() public isOwner {
    payable(msg.sender).transfer(address(this).balance);
  }

  receive() external payable {}
}
