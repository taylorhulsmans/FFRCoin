<template>
  <v-form
    v-model="valid"
  >
    <v-container>
      <v-row>
        <v-col
          cols="12"
          md="4"
        >
          <v-text-field
            v-model="address"
            :rules="isAddress"
            label="Address To Offer To"
            required
          >
          </v-text-field>
            <v-text-field
              type="number"
              v-model="amount"
              :rules="isAmount"
              label="amount to offer"
              required
            >
            </v-text-field>
             <v-menu
                ref="menu"
                v-model="menu"
                :close-on-content-click="false"
                :return-value.sync="date"
                transition="scale-transition"
                offset-y
                min-width="290px"
              >
                <template v-slot:activator="{ on }">
                  <v-text-field
                    v-model="date"
                    :rules="isDate"
                    label="Expiry Date"
                    prepend-icon="event"
                    readonly
                    v-on="on"
                  ></v-text-field>
                </template>
                <v-date-picker v-model="date" no-title scrollable>
                  <v-spacer></v-spacer>
                  <v-btn text color="primary" @click="menu = false">Cancel</v-btn>
                  <v-btn text color="primary" @click="$refs.menu.save(date)">OK</v-btn>
                </v-date-picker>
              </v-menu>
        </v-col>
      </v-row>
    </v-container>
    <v-btn class="mr-4" @click="offerLoan">submit</v-btn>
    <v-snackbar
      v-model="alert"
      top
      color="red"
      >
    </v-snackbar>
  </v-form>
</template>
<script>
import * as FFService from '../../../../shared/FFService'
export default {
  data: () => ({
    valid: false,
    address: '',
    isAddress: [
      v => !!v || 'Address is required',
      v => window.web3.utils.isAddress(v) || 'Must be a valid Ethereum Address',
    ],
    amount: 0,
    isAmount: [
      v => !!v || 'An amount to loan is required',
    ],
    date: new Date().toISOString().substr(0, 10),
    isDate: [
      v => !!v || 'An Expiry date is required',
    ],
    menu: false,
    //
    alert: false,

  }),
  methods: {
    async offerLoan() {
      if (this.valid) {
        const addresses = await FFService.addresses()
        const offerLoan = await FFService.offerLoan(
          addresses[0],
          this.address,
          this.amount,
          (this.date / 1000).toFixed(0),
        );
        console.log(offerLoan)
      } else {
        this.alert = true
      }
    }
  },
};
</script>
