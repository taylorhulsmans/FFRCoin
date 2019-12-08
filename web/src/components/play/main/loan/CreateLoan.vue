<template>
  <v-form
    v-model="valid"
  >
    <v-container>
      <v-row>
        <v-col
          cols="12"
          md="12"
        >
          <v-text-field
            v-model="address"
            :rules="isAddress"
            label="Address To Offer To"
            required
          >
          </v-text-field>

           <v-menu
              ref="menu"
              v-model="menu"
              :close-on-content-click="false"
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
              <v-date-picker v-model="date"
                no-title
                scrollable
                actions     
                >
                <v-spacer></v-spacer>
                <v-btn text color="primary" @click="menu = false">Cancel</v-btn>
          <v-btn text color="primary" @click="
            $refs.menu.save(date);
            calcMaxLendForDate(date);
            ">OK</v-btn>
              </v-date-picker>
            </v-menu>
             <v-chip
              class='ma-2'
              color='blue'
              text-color="white"
              >
              <v-chip
                left
                class="teal darken-4"
                >{{maxLend}}
              </v-chip>
                Max Lend
            </v-chip>
            <v-text-field
              type="number"
              v-model="amount"
              :rules="isAmount"
              label="amount to offer"
              v-on:change="calcInterestRate"
              required
            >
            </v-text-field>
            <v-text-field 
              type="number"
              v-model="interest"
              :rules="isInterest"
              label="Interest, Amount to charge for loan"
              v-on:change="calcInterestRate"
              required
            >
            </v-text-field>
             <v-chip
              class='ma-2'
              color='yellow'
              text-color="black"
              >
              <v-chip
                left
                class="yellow darken-4"
                >{{interestRate}}
              </v-chip>
                Interest Rate
            </v-chip>
        </v-col>
      </v-row>
    </v-container>
    <v-btn class="mr-4" @click="offerLoan">
      <v-progress-circular
        v-if="mining"
        indeterminate
        color="amber"
      >
      </v-progress-circular>
      <p v-if="!mining">Submit</p>
    </v-btn>
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
      v => v % 1 == 0 || 'whole numbers only please'
    ],
    date: new Date().toISOString().substr(0, 10),
    isDate: [
      v => !!v || 'An Expiry date is required',
    ],
    interest: 0,
    isInterest: [
      v => !!v || 'How much would you like to charge for this loan?',
    ],
    interestRate: 0,
    menu: false,
    //
    alert: false,
    mining: false,
    maxLend: null,

  }),
  methods: {
    async offerLoan() {
      if (this.valid) {
        this.mining = true;
        const date = Math.floor(new Date(this.date).getTime() / 1000)
        this.$vueEventBus.$emit('new-loan-mining', {
          address: this.address,
          amount: this.amount,
          date
        })
        const addresses = await FFService.addresses()
        const offerLoan = await FFService.offerLoan(
          addresses[0],
          this.address,
          this.amount,
          date,
          this.interest,
        );
        console.log('pastloan')
        console.log(offerLoan)
        this.$vueEventBus.$emit('new-loan-confirmed', {offerLoan, date:this.date, amount:this.amount, interest:this.interest})
        this.mining = false
      } else {
        this.alert = true
      }
    },
    async calcMaxLendForDate(date) {
      this.date = date
      const todayPosix = new Date().getTime() / 1000;
      const datePosix = Math.floor(new Date(date).getTime() / 1000);
      this.maxLend = await FFService.calculateAvailable(datePosix);
    },
    calcInterestRate() {
      this.interestRate =  (this.interest / this.amount).toFixed(2);
    }
  },
};
</script>
