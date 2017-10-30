<template>
  <div class="thread">
    <div class="loading" v-if="loading">
      Loading...
    </div>

    <div v-if="error" class="error">
      {{ error }}
    </div>

    <div v-if="threads" class="content">
      <div v-for="thread in threads">
        <a v-bind:href="thread.permalink">
          {{ thread.title }}
        </a>
      </div>
    </div>
  </div>
</template>


<style scoped>
</style>

<script>
  import axios from 'axios';
  export default {
    data () {
      return {
        loading: false,
        threads: null,
        error: null
      }
    },
    created () {
      this.fetchData()
    },
    watch: {
      '$route': 'fetchData'
    },
    methods: {
      fetchData () {
        this.error = this.threads = null;
        this.loading = true
        this.getThreads((err, threads) => {
          if (err) {
            this.error = err.toString()
          } else {
            console.log('threads: ', threads.data);
            this.threads = threads
          }
          this.loading = false
        })
      },
      getThreads (callback) {
        axios.get('/api/threads')
          .then(response => callback(null, response.data))
          .catch(e => callback(e))
      }
    }
  }
</script>
