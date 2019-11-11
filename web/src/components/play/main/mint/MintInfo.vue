<template>
 <v-container>
   <v-layout row wrap justify-center>
     <v-flex>
       <h1 class="text-center">Memetic Minter</h1>
     </v-flex>
   </v-layout>
   <v-layout row wrap justify-center>
    <v-flex xs12 sm6>
      <h3 class="text-center">About</h3>
      <p>To kickstart the crypto, An oracle has been created to award users by Proof of Meme.<br/>  In proof of meme, a user provides a proof of their shitpost by adding an ethereum address in it, and submitting the post number and the thread number it was in.<br/> The oracle will then award this ethereum address with its amount in digits.</p>
    </v-flex>
    <v-flex xs12 sm6>
      <h3 class="text-center">Instructions</h3>
      <p>1. Go on 4chan and contribute to its pool of knowledge, within your posts, include an ethereum address</p>
      <br/>
      <p>2.  Grab OPS post number and you post number and add it to the fields below, click submit</p>
      <p>3. tokens should be rewarded shortly</p>
    </v-flex>
   </v-layout>
 </v-container>
</template>
<script>
export default {
  data: () => ({
    titleCards: [
      {
        name: 'title',
        text: 'Memetic Minter'
      },
      {
        name: 'subtitle',
        text: 'May kek bless your digits with Frenz',
      },
      {
        name: 'explanation',
        text: ''
      }
    ],
    detailCards: [
      {
        name: 'About',
        text: ''
      },
      {
        name: 'Instructions',
        text: ''
      }
    ]
  }),
}
</script>
