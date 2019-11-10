<template>
  <v-app id="home">
    <TopNav />
    <v-container fluid>
      <v-layout row wrap>
        <v-flex xs12 sm12 md3>
          <v-img src='@/assets/andrew-thug.png'
            contain/>
        </v-flex>
        <v-flex xs12 sm12 md9>
          <h1 class="text-center"><i>Fiat Frenzy</i></h1>
          <h2 class="text-center"><i>Fractional Reserve Lending for All</i></h2>
          <br/>
          <v-img src='@/assets/henry-ford-quote.jpg'
              contain
              style="margin: 0 auto"
              width='50%'
            />
            <br/>
            <br/>
            <p class="text-center">Welcome to Fiat Frenzy, a crypocurrency by which everyone can fractionally reserve lend, not just the banking elite.</p>
            <br/>
            <p class="text-center"> Why? education on monetary mechanics is scant and obsurced by loads of jargon, a fraud behind complexity theatre.</p>
            <br/>
            <p class="text-center">How? Fiat Frenzy gamifies Fractional reserve lending so the normies will be able to grasp how they are being pillaged and robbed every time a loan is created.</p>
            <p class="text-center"> Okay OP, this is pretty cool, but why have you sunk so much time into getting this right?</p>
            <v-img src="@/assets/jesus-money-changers.jpg"
              contain
              style="margin: 0 auto"
              width="25%"
            />
              <br/>
              <p class="text-center"> Thanks for totally asking that question anon, to answer please see pic above. It is my knowledge that Earths most Original Gangster, Jesus Christ, spent time carefully crafting his flail to discipline the money changers, this is my attempt at crafting the flail. With this technology, it is my greatest hope that we can make Jesus proud</p>
              <br/>
              <p class="text-center"> Sounds great christ cuck, how do I start?</p>
              <br/>
              <p class="text-center"> Awesome, welcome to the revolution, first start by installing 
              <a href="https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=en" target="_blank">metamask</a> into your browser</p>
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
