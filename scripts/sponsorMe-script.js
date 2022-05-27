const hre = require("hardhat");

async function getBalance(address) {
  const bigIntBalance = await hre.waffle.provider.getBalance(address);
  return hre.ethers.utils.formatEther(bigIntBalance);
}

async function main() {
  const [owner, sponsor1, sponsor2, donator1, donator2] = await hre.ethers.getSigners();
  const SponsorMeFactory = await hre.ethers.getContractFactory("SponsorMeFactory");
  const sponsorMeFactory = await SponsorMeFactory.deploy();

  await sponsorMeFactory.deployed();

  await sponsorMeFactory.connect(sponsor1).createSponsorMeContract();

  const sponsorValue = { value: hre.ethers.utils.parseEther("1000") };
  await sponsorMeFactory
    .connect(donator1)
    .sendCreditToSponsorMeOwner("Hello Sponsor1", sponsor1.address, sponsorValue);

  console.log("Owner: ", await getBalance(owner.address));
  console.log("Sponsor1: ", await getBalance(sponsor1.address));
  console.log("Donator1: ", await getBalance(donator1.address));

  await sponsorMeFactory.connect(sponsor1).withdrawCreditForSponsorMeOwner(sponsor1.address);

  console.log("Owner: ", await getBalance(owner.address));
  console.log("Sponsor1: ", await getBalance(sponsor1.address));
  console.log("Donator1: ", await getBalance(donator1.address));

  await sponsorMeFactory.connect(owner).withdrawFactoryCredit();

  console.log("Owner: ", await getBalance(owner.address));
  console.log("Sponsor1: ", await getBalance(sponsor1.address));
  console.log("Donator1: ", await getBalance(donator1.address));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
