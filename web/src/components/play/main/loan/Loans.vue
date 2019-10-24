
<template>
  <v-container>
    <h1>Loans</h1>
    <v-row
      align="center"
      justify="center"
    >
      <v-col>
        <CreateLoan />
      </v-col>
    </v-row>
    <v-row>
      <v-col>
        <LoanTable />
      </v-col>
    </v-row>
  </v-container>
</template>
<script>
import CreateLoan from './CreateLoan.vue';
import LoanTable from './LoanTable.vue';
import SignLoan from './SignLoan.vue';

export default {
  components: {
    CreateLoan,
    LoanTable,
    SignLoan,
  },
  data() {
    return {

    };
  },
};
</script>
