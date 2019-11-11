<template>
  <v-app id="home">
    <TopNav />
    <v-container fluid>
      <v-layout row wrap justify-center>
        <v-flex xs10 sm8 md6 lg4 xl4>
          <h1 class="text-center"><i>Fiat Frenzy</i></h1>
          <h2 class="text-center"><i>Fractional Reserve Lending for All</i></h2>
          <br/>
          <v-img src='@/assets/andrew-thug.png'
            contain
            style="margin: 0 auto"/>
            <br/>
            <br/>
            <p class="text-center">Shadilay Anon, and welcome to Fiat Frenzy, A cryptocurrency by which everyone can print money from nothing and lend it, not just the banking elite.</p>
            <br/>
            <p class="text-center"> Why? Education on monetary mechanics is scant and obsurced by loads of jargon. Indeed, a recent <a href="https://www.ccn.com/nearly-1-3-of-americans-believe-this-myth-about-the-us-dollar/">study</a> Indicates that nearly 30% of Americans think the Nixon Shock never happened, and the dollar is still back by gold</p>
            <iframe width="100%" height="315" src="https://www.youtube.com/embed/ye4uRvkAPhA" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
            <br/>
            <br/>
            <p>It is of critical importance that we take the concept of fractional reserve lending, and reduce it from incomprensible word salad to so easy a 4 year old with daddies crypto can do it</p>
            <p class="text-center">We need to Gamify Fractional Reserve Banking</p>
            <br/>
            <v-img src='@/assets/henry-ford-quote.jpg'
                contain
                style="margin: 0 auto"
              />
              <br/>
              <br/>
            <p class="text-center">How? Fiat Frenzy builds atop the Ethereum blockchain and standard token contract, and adds the ability to offer, sign and repay loans</p>
            <p class="text-center">But when I say sign and repay, I don't mean them in the way you or I would make a loan arrangment.</p>
            <p class="text-center">Oh No...</p>
            <p class="text-center">Money will be minted for the debtor, and repaid to the buyer after expiration.</p>
            
            <v-img src='@/assets/fcl.png'
                contain
                style="margin: 0 auto"
              />
              <br/>
            <p class="text-center">But OP, this will get out of hand to quickly, I'll simply make a bot that will lend money to myself and repay instantly an infinitum</p>
            <p class="text-center">You think this doesn't happen in todays monetary system? What do you think tax havens and shell companies are for? The best banks outwit regulators</p>
            <p class="text-center"> But, alas this crypto has standards, A reserveLimit of phi - 1 (~61.8%) at the annum and prevents loan prepayment. This means that a user can lend at most 61.8% of their total money, but this number is less if the loan term is less than a year.<br/>  This means bigger loans are allowed the longer in time they are, reaching a max of 61.8% per year.</p>
            <p class="text-center"> Okay OP, this is pretty cool, but one thing i don't get, is if you need money to create money, how does the process start? did you mint yourself a billion coins like other wannabie-crypto projects like Stellar and Ripple?</p>
            <p class="text-center"> No, kek.  My solution is a tad bit more creative</p>
            <p class="text-center"> The initial coin offering will be governed by the will of Kek itself, I call it Proof of Meme</p>
            <p class="text-center"></p>
            <v-img src="@/assets/kek-digits.gif"
              contain
              style="margin: 0 auto"
            />
              <br/>
              <p class="text-center"> May every post on /biz/ and /pol/ with an ethereum address added in its content be minted its digits</p>
              <p class="text-center"> Pretty cool OP, but I'm wearing a radium watch and am the current officer assigned to your monitering file, why shouldn't I report you to my superiors</p>
            <v-img src="@/assets/jesus-money-changers.jpg"
              contain
              style="margin: 0 auto"
            />
              <br/>
              <p class="text-center"> Thanks for totally asking that question anon, to answer please see pic above. It is my knowledge that Earths most Original Gangster, Jesus Christ, spent time carefully crafting his flail to discipline the money changers, this is my attempt at crafting the flail. With this technology, it is my greatest hope that we can make Jesus proud, would you be that guy who locked up Jesus globie?</p>
              <br/>
              <p class="text-center"> Sounds great christ cuck, how do I start?</p>
              <br/>
              <p class="text-center"> Awesome, welcome to the revolution, first start by installing
              <a href="https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=en" target="_blank">metamask</a> into your browser, this isn't my code, and is a really common way to user the etherum network with a standard browser</p>
              <br/>
              <p class="text-center"> Okay cool, i've installed metamask and followed its steps, i even bothered to write down my seed phrase on paper</p>
              <br/>
              <p class="text-center"> Nice work anon, now comes the crux, we need to get you like 5 bucks in etherum, perhaps
              <a href="https://www.coinbase.com/buy-ethereum" target="_blank">Coinbase</a> will do the job for you, but there is many ways</p>
              <p class="text-center">That was arduous, but now I have a bit of crypto</p>
              <p class="text-center"> Nice job, you've taken a monumental step in breaking the chains of fiat-debt slavery, now, press play (at the top) to begin!</p>
            </v-flex>
      </v-layout>
    </v-container>
  </v-app>
</template>
<script>
import TopNav from '../components/TopNav.vue';
export default {
  components: {
    TopNav,
  },

  data: () => ({
  }),
};
</script>
