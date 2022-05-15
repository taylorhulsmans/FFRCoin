
*WIP*
Testing on Ropsten at [Fiat Frenzy](http://fiatfrenzy.ninja)

# Fiat Frenzy 777 edition
## Permissionless Fractional Reserve Lending
Welcome to the offical repository of Fiat Frenzy, a living monetary experiment asking the question of what would happen if everyone was allowed to fractionally reserve lend instead of just banking institutions.

## Some Rules
A reserve limit is cryptographically enforced, it is also time delimited, meaning this limit is less for shorter term loans.
Loan Prepayment is not allowed.
There is a centralized oracle that will print free money for you if you paste an eth address (ens to come) into a 4chan /pol/ post.  This is called the Memetic minter.

## Whats next
This project was built using whole numbers only to make it simpler for non math nerds, but it would be nice to have decimals to fine tune the interest rate.

## Build
```cp .env.example .env```
```npm install -g ganache-cli``` [ganachi-cli](https://www.npmjs.com/package/ganache-cli)
```npm install truffle -g``` [truffle](https://github.com/trufflesuite/truffle)

### Contracts
```npm install```
```truffle deploy```
```truffle test```


### Api
```cd api && npm install```
```npm run serve```

### web
```cd web && npm install```
```npm run serve```

If you have [tmux](https://github.com/tmux/tmux) installed you can one liner start up with ./tmux.sh
