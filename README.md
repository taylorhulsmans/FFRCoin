
*WIP*
Testing on Ropsten at [Fiat Frenzy](http://fiatfrenzy.ninja)

# Fiat Frenzy 777 edition
## Permissionless Fractional Reserve Lending
Welcome to the offical repository of Fiat Frenzy, a living monetary experiment asking the question of what would happen if everyone was allowed to fractionally reserve lend instead of just banking institutions.


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
