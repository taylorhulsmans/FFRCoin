<template>
 <v-container>
    <v-row
      v-for="(card, i) in titleCards"
      :key="i"
    >
      <v-col
        v-for="k in i + 1"
        :key="k"
      >
        <v-card
          class="pa-2"
          outlined
          tile
        >
        {{card.text}}
        </v-card>
      </v-col>
    </v-row>
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
    ]
  }),
}
</script>
