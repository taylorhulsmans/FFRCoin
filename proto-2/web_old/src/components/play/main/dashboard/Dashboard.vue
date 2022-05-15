<template>
  <v-container fluid>
      <v-col cols="12">
        <v-row
          align="start"
          justify="start"
          style="height: 300px"
        >
        <v-card
          v-for="(card, j) in cards"
          :key="j"
          class="ma-3 pa-6"
          outlined
          tile
        >
        <h1>Hello Card</h1>
        <p>{{card.name}}</p>
        </v-card>
        </v-row>
      </v-col>
  </v-container>
</template>
<script>
export default {
  data() {
    return {
      cards: [
        {
          name: 'name',
        },
        {
          name: 'name',
        },
        {
          name: 'name',
        },
        {
          name: 'name',
        },
        {
          name: 'name',
        },
      ],
    };
  },
};
<
