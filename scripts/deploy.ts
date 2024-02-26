import { ethers } from "hardhat";

async function main() {
  // const Token = await ethers.getContractFactory("CVIII");
  // const token = await Token.deploy("web3Bridge", "VIII");
  // await token.deployed();
  const MarketPlace = await ethers.deployContract("MarketPlace",["name" ,"symbol"]); 
  await MarketPlace.waitForDeployment();
  
  console.log(
    `MarketPlace contract deployed to ${MarketPlace.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
