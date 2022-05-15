
<template>
  <v-container>
    <h1>Debts</h1>
    <v-row>
      <v-col>
        <DebtTable />
      </v-col>
    </v-row>
  </v-container>
</template>
<script>
import DebtTable from './DebtTable.vue';

export default {
  components: {
    DebtTable,
  },
  data() {
    return {

    };
  },
};
</script>
