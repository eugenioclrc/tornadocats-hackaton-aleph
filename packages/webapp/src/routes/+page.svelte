<script lang="ts">
  import { goto } from '$app/navigation';

  import { ethers, isAddress } from 'ethers';

	import { connect, provider, validNetwork,  connected, switchNetwork, account} from '../lib/stores';

  const tokenFactory = "0x110613840629d4bbe6b8220F1e8e457C42D19A69";

  let tokenAddress = '';
  let openCreateModal = false;


    // tokenFactory ABI
    const tokenFactoryAbi = [
        "function tokenMap(address) view returns (address)",
        "function createToken(address) external"
    ];

  async function fetchToken() { 
    if (!isAddress(tokenAddress)) {
        alert("Invalid token address");
        return;
    }

    // Create a contract instance
    const tokenFactoryContract = new ethers.Contract(tokenFactory, tokenFactoryAbi, $provider);

    try {
        // Call the `name` and `symbol` functions
        const wrapped = await tokenFactoryContract.tokenMap(tokenAddress);
        if (wrapped === '0x0000000000000000000000000000000000000000') {
            openCreateModal = true;
            // If the token is not wrapped, create a new wrapped token
            //await tokenFactoryContract.createToken(tokenAddress);
        } else {
          goto(`/token/${tokenAddress}`);
        }
        console.log(`Token Name: ${wrapped}`);
        
    } catch (error) {
        console.error("Error fetching token metadata:", error);
        alert("Error fetching token metadata: " + error);

    }
}

async function createToken() {
    // tokenFactory ABI

    // Create a contract instance
      //const signer = ;
      //const tokenFactoryContractWithSigner = tokenFactoryContract.connect(signer);
      
    
      // Get the signer from the provider
    const _provider = new ethers.BrowserProvider(window.ethereum);

        const signer = await _provider.getSigner();
      // Create a contract instance with a signer
      const tokenFactoryContract = new ethers.Contract(tokenFactory, tokenFactoryAbi, signer);


    try {
        // Call the `name` and `symbol` functions
        const tx = await tokenFactoryContract.createToken(tokenAddress);
        await tx.wait();

        goto(`/token/${tokenAddress}`);
        
        openCreateModal = false;

    } catch (error) {
        console.error("Error fetching token metadata:", error);
        alert("Error creating wrapped token: " + error);
    }
}

</script>
<svelte:head>
  <title>🌪️ TornadoCats</title>
</svelte:head>
    <header class="bg-gray-800 py-6 shadow-md">
        <div class="container mx-auto px-4">
            <h1 class="text-4xl font-bold text-center">🌪️ TornadoCats</h1>
        </div>
    </header>
    <main class="container mx-auto px-4 py-10">
        <section class="text-center">
            <h2 class="text-2xl font-semibold mb-4">Wrap Your Tokens with Homomorphic Encryption</h2>
            <p class="text-lg text-gray-300 mb-6">
                TornadoCats lets you create wrapped tokens with Zama’s cutting-edge homomorphic encryption. Ensure your transactions are secure and private in just a few clicks.
            </p>
        </section>

        <section class="bg-gray-800 rounded-lg p-6 shadow-lg">
            <h3 class="text-xl font-bold mb-4">Get Started</h3>
            <p class="text-gray-300 mb-4">
                Enter the address of the token you want to wrap to continue:
            </p>
            <form class="space-y-4">
                <div>
                    <label for="tokenAddress" class="block text-sm font-medium text-gray-400">Token Address</label>
                    <input
                        type="text"
                        id="tokenAddress"
                        name="tokenAddress"
                        placeholder="0x..."
                        bind:value={tokenAddress}
                        class="w-full mt-1 px-4 py-2 bg-gray-700 text-white border border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none"
                        required
                    />
                </div>
{#if !$connected}
                <button
                    type="button"
                    on:click|preventDefault={connect}
                    class="w-full bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-lg transition-all"
                >
                    Connect
                </button>
{:else if !$validNetwork} 
                <button
                    type="button"
                    on:click|preventDefault={switchNetwork}
                    class="w-full bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-lg transition-all"
                >
                    Switch to Sepolia
                </button>

{:else}
                <button
                    on:click|preventDefault={fetchToken}
                    class="w-full bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-lg transition-all"
                >
                    Continue
                </button>

{/if}
            </form>
        </section>
    </main>

    <footer class="bg-gray-800 py-6 mt-10">
        <div class="container mx-auto text-center">
            <p class="text-gray-500 text-sm">
                Built for the Aleph Verano Hackathon | &copy; 2024 TornadoCats
            </p>
        </div>
    </footer>




{#if openCreateModal}
<div id="popup-modal" tabindex="-1" class="overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full" style="background-color: rgba(0, 0, 0, 0.5)">
    <div class="relative p-4 w-full max-w-md max-h-full mx-auto" style="margin-top:30%">
        <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
            <button type="button" class="absolute top-3 end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white" data-modal-hide="popup-modal"
            on:click|preventDefault={openCreateModal = false}>
                <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                </svg>
                <span class="sr-only">Close modal</span>
            </button>
            <div class="p-4 md:p-5 text-center">
                <svg class="mx-auto mb-4 text-gray-400 w-12 h-12 dark:text-gray-200" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 20">
                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 11V6m0 8h.01M19 10a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/>
                </svg>
                <h3 class="mb-5 text-lg font-normal text-gray-500 dark:text-gray-400">There is no wrapped contract fot this token, do you want to create the wrapped token?</h3>
                <button data-modal-hide="popup-modal" type="button" class="text-white bg-red-600 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 dark:focus:ring-red-800 font-medium rounded-lg text-sm inline-flex items-center px-5 py-2.5 text-center"
                  on:click|preventDefault={createToken}>
                    Yes, please
                </button>
                <button data-modal-hide="popup-modal" type="button" class="py-2.5 px-5 ms-3 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700"
                on:click|preventDefault={openCreateModal = false}>No, cancel</button>
                
            </div>
        </div>
    </div>
</div>
{/if}