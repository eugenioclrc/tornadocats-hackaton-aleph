import { isAddress } from 'ethers';
import { initFhevm, createInstance } from 'fhevmjs';
import { getPublicKey, getPublicParams, storePublicKey, storePublicParams } from './fhevmStorage';

	import {
		PUBLIC_ACL_ADDRESS,
		PUBLIC_KMS_ADDRESS,
    PUBLIC_GATEWAY_URL
	} from '$env/static/public';


  const EBOOL_T = 0;
const EUINT4_T = 1;
const EUINT8_T = 2;
const EUINT16_T = 3;
const EUINT32_T = 4;
const EUINT64_T = 5;
const EUINT128_T = 6;
const EUINT160_T = 7; // @dev It is the one for eaddresses.
const EUINT256_T = 8;
const EBYTES64_T = 9;
const EBYTES128_T = 10;
const EBYTES256_T = 11;


export type Keypair = {
  publicKey: string;
  privateKey: string;
  signature: string;
};

type Keypairs = {
  [key: string]: {
    [key: string]: Keypair;
  };
};

export const init = async () => {
  await initFhevm({ thread: navigator.hardwareConcurrency });
};

let instancePromise;
let instance;

const keypairs: Keypairs = {};

export const createFhevmInstance = async () => {
  if (instancePromise) return instancePromise;
  const storedPublicKey = await getPublicKey(PUBLIC_ACL_ADDRESS);
  const publicKey = storedPublicKey?.publicKey;
  const publicKeyId = storedPublicKey?.publicKeyId;
  const storedPublicParams = await getPublicParams(PUBLIC_ACL_ADDRESS);
  const publicParams = storedPublicParams
    ? {
        '2048': storedPublicParams,
      }
    : null;
  instancePromise = createInstance({
    network: window.ethereum,
    aclContractAddress: PUBLIC_ACL_ADDRESS,
    kmsContractAddress: PUBLIC_KMS_ADDRESS,
    gatewayUrl: PUBLIC_GATEWAY_URL,
    publicKey,
    publicKeyId,
    publicParams,
  });
  instance = await instancePromise;
  const pp = instance.getPublicParams(2048);
  if (pp) {
    await storePublicParams(PUBLIC_ACL_ADDRESS, pp);
  }
  const pk = instance.getPublicKey();
  if (pk) {
    await storePublicKey(PUBLIC_ACL_ADDRESS, pk);
  }
};

export const setKeypair = (contractAddress: string, userAddress: string, keypair: Keypair) => {
  if (!isAddress(contractAddress) || !isAddress(userAddress)) return;
  keypairs[userAddress][contractAddress] = keypair;
};

export const getKeypair = (contractAddress: string, userAddress: string): Keypair | null => {
  if (!isAddress(contractAddress) || !isAddress(userAddress)) return null;
  return keypairs[userAddress] ? keypairs[userAddress][contractAddress] || null : null;
};

export const getInstance = async (): FhevmInstance => {
  if(!instance) {
    await createFhevmInstance();
  }
  return instance;
};

export async function reencryptEuint64(
  signer,
  instance,
  handle,
  contractAddress,
): Promise<bigint> {
  verifyType(handle, EUINT64_T);
  return reencryptHandle(signer, instance, handle, contractAddress);
}




export function verifyType(handle: bigint, expectedType: number) {
  if (handle === 0n) {
    throw "Handle is not initialized";
  }

  if (handle.toString(2).length > 256) {
    throw "Handle is not a bytes32";
  }

  const typeCt = handle >> 8n;

  if (Number(typeCt % 256n) !== expectedType) {
    throw "Wrong encrypted type for the handle";
  }
}



/**
 * @dev This function is to reencrypt handles.
 *      It does not verify types.
 */
async function reencryptHandle(
  signer,
  instance,
  handle,
  contractAddress,
): Promise<any> {
  const { publicKey: publicKey, privateKey: privateKey } = instance.generateKeypair();
  const eip712 = instance.createEIP712(publicKey, contractAddress);
  const signature = await signer.signTypedData(eip712.domain, { Reencrypt: eip712.types.Reencrypt }, eip712.message);

  const reencryptedHandle = await instance.reencrypt(
    handle,
    privateKey,
    publicKey,
    signature.replace("0x", ""),
    contractAddress,
    await signer.getAddress(),
  );

  return reencryptedHandle;
}