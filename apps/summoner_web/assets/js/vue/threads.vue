<template>
  <div class="thread">
    <div class="loading" v-if="loading">
      Loading...
    </div>

    <div v-if="error" class="error">
      {{ error }}
    </div>

    <div v-if="threads" v-for="thread in threads" class="thread">
      <a target="_blank" v-bind:href="thread.permalink">
        {{ thread.title }}
      </a>
      <div>
        <span v-bind:style="{ color: tag.color, 'background-color': tag.bgColor }" v-for="tag in thread.tags" class="thread-tag">
          <router-link :to="{ name: 'threads', query: {
            tags: $route.query.tags ? $route.query.tags + ',' + tag.name : tag.name }
          }">
            {{ tag.name }}
          </router-link>
        </span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.thread {
  padding: 10px 0
}
.thread-tag {
  padding-left: 5px;
  font-size: 10px;
}
.tag {
}
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
            const tags = this.$route.query.tags;
            if (tags && tags.length > 0) {
              for (const thread of threads) {
                for (const tag of thread.tags) {
                  tag.bgColor = tags.indexOf(tag.name) > -1 ? 'yellow' : 'white';
                }
              }
            }
            this.threads = threads
          }
          this.loading = false
        })
      },
      getThreads (callback) {
        axios.get('/api/threads?tags=' + (this.$route.query.tags || ''))
          .then(response => callback(null, response.data))
          .catch(e => callback(e))
      }
    }
  }
</script>
