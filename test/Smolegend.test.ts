import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { expect } from 'chai';
import { ethers } from 'hardhat';
import {
  FameToken,
  Smolegends,
  SmolegendsMetadata,
  SmolegendsReroller,
} from '../typechain';

describe('Smolegends Tests', () => {
  let smolegends: Smolegends;
  let reroller: SmolegendsReroller;
  let metadata: SmolegendsMetadata;
  let fameToken: FameToken;

  let minter1: SignerWithAddress;

  beforeEach(async () => {
    [, minter1] = (await ethers.getSigners()) as SignerWithAddress[];

    const SmolegendsFactory = await ethers.getContractFactory('Smolegends');
    smolegends = await SmolegendsFactory.deploy();

    const SmolegendsRerollerFactory = await ethers.getContractFactory(
      'SmolegendsReroller',
    );
    reroller = await SmolegendsRerollerFactory.deploy();

    const SmolegendsMetadataFactory = await ethers.getContractFactory(
      'SmolegendsMetadata',
    );
    metadata = await SmolegendsMetadataFactory.deploy();

    const FameTokenFactory = await ethers.getContractFactory('FameToken');
    fameToken = await FameTokenFactory.deploy();

    await smolegends.initialize(
      metadata.address,
      reroller.address,
      fameToken.address,
    );
  });

  it('should mint 1 smolegend', async () => {
    await smolegends.connect(minter1).mintSmolegend();

    expect(await smolegends.ownerOf(1)).to.equal(minter1.address);
    expect(await smolegends.totalSupply()).to.equal(1);
  });

  it('should mint 1 smolegend and stake it', async () => {
    await smolegends.connect(minter1).mintAndStakeSmolegend();

    const block = await ethers.provider.getBlock('latest');

    const owner = await smolegends.ownerOf(1);
    expect(owner).to.equal(minter1.address);
    expect(await smolegends.totalSupply()).to.equal(1);

    const staked = await smolegends.staked(1);
    expect(staked.owner).to.equal(minter1.address);
    expect(staked.timestamp).to.equal(block.timestamp);
  });
});
