// Deploying the TD somewhere
// To verify it on Etherscan:
// npx hardhat verify --network sepolia <address> <constructor arg 1> <constructor arg 2>

const hre = require("hardhat");

async function main() {
  // Deploying contracts
  const ERC721 = await hre.ethers.getContractFactory("MyToken");
  const erc721 = await ERC721.deploy();

  await erc721.deployed();
  console.log(`ERC721 deployed at  ${erc721.address}`);
  console.log(
    await erc721.isBreeder("0x43981d9b7f031500f618727B68e554930eE99BB8")
  );

  // await erc721.safeMint("0x43981d9b7f031500f618727B68e554930eE99BB8");
  /*
        uint sex,
        uint legs,
        bool wings,
        string calldata name*/
  // await erc721.declareAnimal(0, 0, true, "Rq_dcwjiLwCntT9");
  await erc721.declareAnimal(0, 0, true, "Rq_dcwjiLwCntT9");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
