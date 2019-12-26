<template>
    <v-navigation-drawer
      app
      expand-on-hover
      permanent
      class="mt-5"
      style='top: 28px; display: block'
      >
      <v-divider></v-divider>
      <v-list
        nav
        dense
      >
        <v-list-item-group
          :multiple="multiple"
        >
          <v-list-item
            v-for="(option, i) in options"
            :key="i"
            @click="$emit('change-main', option.component)"
          >
           <v-list-item-icon>
             <v-icon>{{option.icon}}</v-icon>
            </v-list-item-icon>
          <v-list-item-title>{{option.title}}</v-list-item-title>

          </v-list-item>
        </v-list-item-group>
      </v-list>
    </v-navigation-drawer>
</template>
<script>
export default {
  data() {
    return {
      multiple: false,
      options: [
        {
          title: 'Home',
          icon: 'mdi-home',
          component: 'About',
        },
        {
          title: 'Fractional Reserves',
          icon: 'mdi-piggy-bank',
          component: 'FractionalReserves',
        },
      ],
    };
  },
  methods: {

  }
};
</script>
