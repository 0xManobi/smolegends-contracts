// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.

import { Signer } from 'ethers';
import { ethers, run } from 'hardhat';

async function main() {
  await run('compile');

  const [deployer] = await ethers.getSigners();
  console.log('Deploying the contracts with the account:', deployer.address);

  const metadata = await deploySmolegendsMetadata(deployer);
  const smolegendsReroller = await deploySmolegendsReroller();
  const fameToken = await deployFameToken();

  console.log('Deploying Smolegends');
  const SmolegendsFactory = await ethers.getContractFactory('Smolegends');
  const smolegends = await SmolegendsFactory.deploy();
  console.log(smolegends.address);

  console.log('Setting Smolegends as FameToken minter');
  await fameToken.connect(deployer).setMinter(smolegends.address, true);

  console.log('Initializing Smolegends');
  await smolegends.initialize(
    metadata.address,
    smolegendsReroller.address,
    fameToken.address,
  );
}

async function deployFameToken() {
  console.log('Deploying FameToken');
  const FameTokenFactory = await ethers.getContractFactory('FameToken');
  const fameToken = await FameTokenFactory.deploy();
  console.log(fameToken.address);
  return fameToken;
}

async function deploySmolegendsReroller() {
  console.log('Deploying SmolegendsReroller');
  const SmolegendsRerollerFactory = await ethers.getContractFactory(
    'SmolegendsReroller',
  );
  const smolegendsReroller = await SmolegendsRerollerFactory.deploy();
  console.log(smolegendsReroller.address);
  return smolegendsReroller;
}

async function deploySmolegendsMetadata(deployer: Signer) {
  console.log('Deploying SmolegendsMetadata');
  const SmolegendsMetadataFactory = await ethers.getContractFactory(
    'SmolegendsMetadata',
  );
  let metadata = await SmolegendsMetadataFactory.deploy();
  console.log(metadata.address);

  metadata = metadata.connect(deployer);

  console.log('starting');
  // Now deploy all of the art
  const svgs = [
    { name: 'Classes', ids: [1, 2, 3], type: 1 },
    { name: 'Headgears', ids: [1, 2, 3], type: 2 },
    { name: 'Alignments', ids: [1, 2, 3], type: 3 },
    { name: 'Weapons', ids: [1, 2, 3], type: 4 },
    { name: 'Backs', ids: [1, 2, 3], type: 5 },
    { name: 'Bodies', ids: [1, 2, 3], type: 6 },
    { name: 'Races', ids: [1, 2, 3], type: 7 },
    { name: 'Pets', ids: [1, 2, 3], type: 8 },
    { name: 'Items', ids: [1, 2, 3], type: 10 },
    { name: 'Footgears', ids: [1, 2, 3], type: 11 },
  ];

  for (const svg of svgs) {
    console.log('Deploying', svg.name);
    const FAC = await ethers.getContractFactory(svg.name);
    const data = await FAC.deploy();

    await data.deployed();
    console.log('address', data.address);
    if (svg.type == 1) {
      console.log('Setting as Classes');
      await metadata.setClasses(svg.ids, data.address);
    }

    if (svg.type == 2) {
      console.log('Setting as Headgears');
      await metadata.setHeadgears(svg.ids, data.address);
    }

    if (svg.type == 3) {
      console.log('Setting as Alignments');
      await metadata.setAlignments(svg.ids, data.address);
    }

    if (svg.type == 4) {
      console.log('Setting as Offhands');
      await metadata.setOffhands(svg.ids, data.address);
    }

    if (svg.type == 5) {
      console.log('Setting as Backs');
      await metadata.setBacks(svg.ids, data.address);
    }

    if (svg.type == 6) {
      console.log('Setting as Bodies');
      await metadata.setBodies(svg.ids, data.address);
    }

    if (svg.type == 7) {
      console.log('Setting as Races');
      await metadata.setRaces(svg.ids, data.address);
    }

    if (svg.type == 8) {
      console.log('Setting as Pets');
      await metadata.setPets(svg.ids, data.address);
    }

    if (svg.type == 4) {
      console.log('Setting as Mainhands');
      await metadata.setMainhands(svg.ids, data.address);
    }

    if (svg.type == 10) {
      console.log('Setting as Items1');
      await metadata.setItems1(svg.ids, data.address);
    }

    if (svg.type == 11) {
      console.log('Setting as Footgears');
      await metadata.setFootgears(svg.ids, data.address);
    }

    if (svg.type == 10) {
      console.log('Setting as Items2');
      await metadata.setItems2(svg.ids, data.address);
    }
  } //end for loop

  return metadata;
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
