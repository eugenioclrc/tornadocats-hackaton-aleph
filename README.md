<center><img src="./logo.png" width="250" height="250" /></center>


# Tornado Cats
<small>Quick shoutout, this name has been inspired from <a href="https://minaminao.github.io/tornado-cats/" target="_blank">minaminao/tornado-cats</a></small>

TornadoCats is a project built for the Aleph Verano Hackathon. It provides a simple and efficient way to create wrapped tokens with homomorphic encryption, leveraging Zama's technology. The project is structured as a monorepo, consisting of a SvelteKit front-end and a folder containing all smart contracts.

----------

## Features

- **Contract Factory**: Easily deploy wrapped tokens.
- **Homomorphic Encryption**: Ensures privacy and security by integrating Zama's encryption.
- **SvelteKit Front-End**: A sleek and intuitive interface for interacting with the factory.
- **Modular Architecture**: Contracts and front-end are decoupled for clarity and ease of maintenance.

---

## Deployment

- **Contract Wrapped Token Factory**:
  Successfully verified contract TokenFactory on Sourcify.
  [View on Sepolia Etherscan](https://sepolia.etherscan.io/address/0xEb25882253bcCeFf23Ae2ec76Cc2648A13d16f87#code)

- **Front-End**:
  Deployed on Vercel. [Visit TornadoCats](https://tornadocats-hackaton-aleph-webapp.vercel.app/)

---

## Getting Started

### Prerequisites

- **Node.js** (>= 16.x)
- **pnpm**
- **Foundry** or **Hardhat** (for deploying and testing contracts)
- **Zama SDK**

### Installation

1. Clone the repository:

   ```bash
   git clone git@github.com:eugenioclrc/tornadocats-hackaton-aleph.git
   cd tornadocats-hackaton-aleph
   ```

2. Install dependencies for both the front-end and contracts (**im using a monorepo**):

   ```bash
   pnpm i
   ```

### Usage

#### Running the Front-End

1. Navigate to the `webapp` directory:
   ```bash
   cd packages/webapp
   ```
2. Start the development server:
   ```bash
   npm run dev
   ```

#### Deploying Contracts

1. Navigate to the `hardhat` directory:
   ```bash
   cd packages/hardhat
   ```
2. Compile the contracts:
   ```bash
   npm run compile
   ```
3. Deploy the factory contract:
   ```bash
   npm run deploy
   ```

### Testing
#### Contracts

Run tests for the Solidity contracts:

```bash
cd packages/hardhat
npm run test
```

---

## Directory Structure

```
TornadoCats
├── packages
│   ├── hardhat   # Smart contracts
│   └── webapp    # SvelteKit application
└── README.md
```

---

## Technologies

- **SvelteKit**: Front-end framework for building the UI.
- **Solidity**: Smart contract programming language.
- **Zama SDK**: Enables homomorphic encryption.
- **Hardhat**: Development environment for Ethereum contracts.

---

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---

## Acknowledgments

- **Aleph Verano Hackathon** for the opportunity.
- **Zama** for providing cutting-edge encryption technology.
