<template>
  <v-card>
    <v-navigation-drawer
      expand-on-hover
      permanent
    >
      <v-divider></v-divider>
      <v-list
        nav
        dense
      >
        <v-list-item-group
          v-model="model"
          :multiple="multiple"
        >
          <v-list-item
            v-for="(option, i) in options"
            :key="i"
          >
           <v-list-item-icon>
             <v-icon>{{option.icon}}</v-icon>
            </v-list-item-icon>
          <v-list-item-title>{{option.title}}</v-list-item-title>

          </v-list-item>
        </v-list-item-group>
      </v-list>
    </v-navigation-drawer>
  </v-card>
</template>
<script>
export default {
  data() {
    return {
      multiple: false,
      options: [
        {
          title: 'Dashboard',
          icon: 'mdi-view-dashboard',
        },
        {
          title: 'My Loans',
          icon: 'mdi-arrow-expand-up',
        },
        {
          title: 'My Debts',
          icon: 'mdi-arrow-expand-down',
        },
        {
          title: 'Starred',
          icon: 'mdi-star',
        },
      ],
    };
  },
};
</script>
