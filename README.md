# SponsorMe

This repo consists of smart contracts that mimics basic BuyMeACoffee functionalities in a decentralized way. An account can create it's `SponsorMe` instance inside `SponsorMeFactory` that can be used to get and withdraw tokens for a small cut to factory contract instance.

### Contracts
- `SponsorMe` - Consists of basic token sending and withdrawing functions
- `SponsorMeFactory` - Consists of functions used for handling the `SponsorMe` instances

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat ./scripts/sponsor-me-script.js
```
