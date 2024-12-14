import { ethers } from "hardhat";

import type { MockToken } from "../../types";
import { getSigners } from "../signers";

export async function deployMockERC20Fixture(): Promise<MockToken> {
  const signers = await getSigners();
  


  const contractFactory = await ethers.getContractFactory("MockToken");
  const contract = await contractFactory.connect(signers.alice).deploy("Naraggara", "NARA", 18, BigInt(20e18));
  await contract.waitForDeployment();

  return contract;
}
