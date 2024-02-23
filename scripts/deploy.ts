import { ethers } from "hardhat";

async function main() {
  // const Token = await ethers.getContractFactory("CVIII");
  // const token = await Token.deploy("web3Bridge", "VIII");
  // await token.deployed();
  const Vault  = await ethers.deployContract("Vault"); 
  await Vault .waitForDeployment();
  
  console.log(
    `Vault  contract deployed to ${Vault .target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
