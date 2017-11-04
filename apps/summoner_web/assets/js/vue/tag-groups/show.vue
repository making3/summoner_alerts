<template>
  <div>
    <div class="loading" v-if="loading">
      Loading...
    </div>

    <div v-if="error" class="error">
      {{ error }}
    </div>

    <div v-if="tagGroup">
      <h3>
        Group {{ tagGroup.name }}
      </h3>

      <ul v-if="tagGroup.tags" v-for="tag in tagGroup.tags">
        <li>{{ tag }}</li>
      </ul>
    </div>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    data () {
      return {
        loading: false,
        tagGroup: null,
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
        this.error = this.tagGroup = null;
        this.loading = true
        this.getTagGroup(this.$route.params.id, (err, tagGroup) => {
          if (err) {
            this.error = err.toString();
          } else {
            this.tagGroup = tagGroup;
          }
          this.loading = false;
        })
      },
      getTagGroup (id, callback) {
        axios.get(`/api/tag-groups/${id}`)
          .then(response => callback(null, response.data))
          .catch(callback);
      }
    }
  }
</script>
