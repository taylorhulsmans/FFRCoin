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
          v-model="thread"
          :rules="isThread"
          label="thread id (post number of OP)"
          required>
        </v-text-field>
        <v-text-field
          v-model="post"
          :rules="isPost"
          label="post number"
          required
        >
        </v-text-field>
        </v-col>
      </v-row>
  
      <v-btn
        class="mr-4"
        @click="submitProofOfMeme"
      >Submit Proof of Meme
      </v-btn> 
    </v-container>
  </v-form>
</template>
<script>
import * as FFService from '../../../../shared/FFService'
export default {
  data: () => ({
    valid: false,
    thread: '',
    isThread: [
      v => !!v || 'thread url is required',
    ],
    post: '',
    isPost: [
      v => !!v || 'post is required',
    ],
  }),
  methods: {
    async submitProofOfMeme() {
      if (this.valid) {
        return await FFService.proveMemeAndMint(this.thread, this.post)
      }
    },
  }
};
</script>
