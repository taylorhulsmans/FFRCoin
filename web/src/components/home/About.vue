<template>
  <v-app id="home">
    <v-container fluid>
      
  <v-row align="center">
    <v-item-group
      v-model="window"
      class="shrink mr-6"
      mandatory
      tag="v-flex"
    >
      <v-item
        v-for="n in length"
        :key="n"
        v-slot:default="{ active, toggle }"
      >
        <div>
          <v-btn
            :input-value="active"
            icon
            @click="toggle"
          >
            <v-icon>mdi-record</v-icon>
          </v-btn>
        </div>
      </v-item>
    </v-item-group>

    <v-col>
      <v-window
        v-model="window"
        class="elevation-1"
        vertical
      >
        <v-window-item
          v-for="n in length"
          :key="n"
        >

              <v-layout v-if="n == 1" row wrap justify-center align-center> 
                <v-flex xs6 sm6 md3>
                  <v-img src='@/assets/bag-holder.jpg'
                    contain
                    width="61.8%"
                    style="margin: 0 auto;"/>
                </v-flex>
                <v-flex xs12 sm6 class="justify-center align-center pa-4">
                  <p class="text-center headline"><i>Thunder Cracks...</i></p>
                  <p class="text-center headline">Shared in the darkest corners of the internet, where Google dares not index,</p> 
                  <p class="text-center headline">The screencap of a prophecy, rumoured to be penned by the Archangel himself.</p>
                  <p class="text-center headline">Within its text, the telling of a new age of man, a creative age; a technological age.</p>
                  <p class='text-center headline'>One where the realm of our collective imagination blurs into the physical plane</p>
                  <p class="text-center headline">The prophecy speaks of a <i>Memetic Singularity</i>- The moment in time when a meme so potent in meaning, so feverish in virality, that it will shatter the very perception of time and space</p>
                  <p class="text-center headline bold"><i></i></p>
                  
                </v-flex>
                <v-flex xs6 sm6 md3>
                  <v-img src='@/assets/bag-holder.jpg'
                    contain
                    width="61.8%"
                    style="margin: 0 auto; transform: scaleX(-1);"/>
                </v-flex>
              </v-layout>

              <v-layout v-if="n == 2" row wrap justify-center align-center> 
                <v-flex xs6 sm6 md3>
                  <v-img src='@/assets/bag-holder.jpg'
                    contain
                    width="61.8%"
                    style="margin: 0 auto;"/>
                </v-flex>
                <v-flex xs12 sm6 class="justify-center align-center pa-4">
                  <p class="text-center headline">But Alas...</p> 
                  <p class="text-center headline">Mans memetic prowess is still but an ember</p> 
                  <p class="text-center headline">What is needed is a crucible; a bellow to set our meme magic ablaze</p>
                  <p class="text-center headline">So welcome to this temple, I your humble steward, am pleased to maintain</p>
                  <p class="text-center headline">A place for memetic purification and amplication</p>
                  <p class="text-center headline">So that the memetic singularity can be attained</p>
                </v-flex>
                <v-flex xs6 sm6 md3>
                  <v-img src='@/assets/bag-holder.jpg'
                    contain
                    width="61.8%"
                    style="margin: 0 auto; transform: scaleX(-1);"/>
                </v-flex>
              </v-layout>
              <v-layout v-if="n == 3" row wrap justify-center align-center> 
                <v-flex xs6 sm6 md3>
                  <v-img src='@/assets/bag-holder.jpg'
                    contain
                    width="61.8%"
                    style="margin: 0 auto;"/>
                </v-flex>
                <v-flex xs12 sm6 class="justify-center align-center pa-4">
                  <p class="text-center headline">Welcome to Fiat Frenzy: the Memetic Crucible</p> 
                  <p class="text-center headline">A decentralized meme economy, powered on an ethereum smart contract</p> 
                  <p class="text-center headline">Its unit of account, called the FREN, is created by two processes</p>
                  <p class="text-center headline">Firstly, users can fractionally reserve lend to each other (see piggy bank icon)</p>
                  <p class="text-center headline">Secondly, the Fiat Frenzy Protocol contains Proof of Meme, rewarding users for contributing their knowledge</p>
                  <p class="text-center headline">Users can then invest in different images, being rewarded in FREN for reposts</p>
                </v-flex>
                <v-flex xs6 sm6 md3>
                  <v-img src='@/assets/bag-holder.jpg'
                    contain
                    width="61.8%"
                    style="margin: 0 auto; transform: scaleX(-1);"/>
                </v-flex>
              </v-layout>
        </v-window-item>
      </v-window>
    </v-col>
  </v-row>
      <v-layout row wrap justify-center align-center>
        <v-flex xs12 sm12 md6>
          <v-img src='@/assets/title.jpg'
            contain
            width="61.8%"
            style="margin: 0 auto;"/>
        </v-flex>
        </v-layout>
    </v-container>
  </v-app>
</template>
<script>
export default {
  data: () => ({
    length: 3,
    window: 0
  }),
};
</script>
