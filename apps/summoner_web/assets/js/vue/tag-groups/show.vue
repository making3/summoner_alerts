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
        <li>
          {{ tag.name }}
          <button v-on:click="deleteTag(tag.id)">Delete</button>
        </li>
      </ul>

      <input type="text" v-model="name" placeholder="Tag name" v-on:keyup.13="createTag()"></input>
      <button v-on:click="createTag()">Create Tag</button>
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
      },
      createTag () {
        if (!this.name) {
          this.error = "Tag requires a name";
          return;
        }
        axios.post('/api/tags', {
          name: this.name,
          group_id: this.tagGroup.id
        })
          .then(response => {
            this.name = "";
            this.tagGroup.tags.push(response.data);
          })
          .catch(error => {
            this.error = error.toString();
          });
      },
      deleteTag(id) {
        axios.delete(`/api/tags/${id}`)
          .then(() => {
            const tagIndex = this.tagGroup.tags.findIndex((t) =>
              t.id === id
            );
            this.tagGroup.tags.splice(tagIndex, 1);
          })
          .catch(error => {
            this.error = error.toString();
          });
      }
    }
  }
</script>
