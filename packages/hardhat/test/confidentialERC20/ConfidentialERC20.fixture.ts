import { ethers } from "hardhat";

import type { WrappedPrivacyERC20 } from "../../types";
import { getSigners } from "../signers";

export async function deployConfidentialERC20Fixture(addressToken): Promise<WrappedPrivacyERC20> {
  const signers = await getSigners();
  


  const contractFactory = await ethers.getContractFactory("WrappedPrivacyERC20");
  const contract = await contractFactory.connect(signers.alice).deploy(addressToken);
  await contract.waitForDeployment();

  return contract;
}
