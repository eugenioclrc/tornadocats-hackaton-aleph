import { get, writable } from 'svelte/store';

import { createFhevmInstance } from './fhevmjs'

import { BrowserProvider } from 'ethers';
const AUTHORIZED_CHAIN_ID = ['0xaa36a7', '0x2328'];

export const account = writable(null);
export const connected = writable(false);
export const loading = writable(false);
export const hasWallet = writable(false);
export const provider = writable(null);
export const validNetwork = writable(false);


export async function hasValidNetwork() {
    const currentChainId: string = await window.ethereum.request({ method: 'eth_chainId' });
    return AUTHORIZED_CHAIN_ID.includes(currentChainId.toLowerCase());
  };

export async function refreshAccounts(accounts: string[]) {
  if (accounts.length > 0) {
    account.set(accounts[0]);
    connected.set(accounts.length > 0);
  }
}


export async function refreshNetwork() {
    if (await hasValidNetwork()) {
      validNetwork.set(true);
      loading.set(true);
      await createFhevmInstance();
      loading.set(false);
    } else {
      validNetwork.set(false);
    }
  };


export async function switchNetwork() {
    try {
      await window.ethereum.request({
        method: 'wallet_switchEthereumChain',
        params: [{ chainId: AUTHORIZED_CHAIN_ID[0] }],
      });
    } catch (e) {
      console.error('No Sepolia chain configured');
    }
  };

export async function connect() {
    const _provider = get(provider);
    if (!_provider) {
      return;
    }
    const accounts: string[] = await _provider.send('eth_requestAccounts', []);

    if (accounts.length > 0) {
      account.set(accounts[0]);
      connected.set(true);
      if (!(await hasValidNetwork())) {
        await switchNetwork();
      }
    }
  };



export async function init() {
  const _hasWallet = !!window.ethereum;
  const _provider = new BrowserProvider(window.ethereum);

  hasWallet.set(_hasWallet);
  provider.set(_provider);

  
  _provider
    .send('eth_accounts', [])
    .then(async (accounts: string[]) => {
      refreshAccounts(accounts);
      refreshNetwork();
    })
    .catch(() => {
      // Do nothing
    });
  window.ethereum.on('accountsChanged', refreshAccounts);
  window.ethereum.on('chainChanged', refreshNetwork);
}