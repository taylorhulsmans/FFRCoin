
*WIP*
Testing on Ropsten at [Fiat Frenzy](fiatfrenzy.ninja)

# Fiat Frenzy 777 edition
## Permissionless Fractional Reserve Lending





## Spec

- [] upgraded smart contract from [v1](https://github.com/Joe-mcgee/Fiat-Frenzy)
- [] a chronjob that will scrape 4chan for gets with eth addresses, and mint tokens for them
- [] a simple web ui
- [] getting [this guy](https://www.patreon.com/tarotofkek) to do the design work

## Build
```cp .env.example .env```
```npm install -g ganache-cli``` [ganachi-cli](https://www.npmjs.com/package/ganache-cli)
```npm install truffle -g``` [truffle](https://github.com/trufflesuite/truffle)

### Contracts
```truffle deploy```
```truffle test```

### Api
```cd api && npm install```
```npm run serve```

### web
```cd web && npm install```
```npm run serve```

If you have [tmux](https://github.com/tmux/tmux) installed you can one liner start up with ./tmux.sh
