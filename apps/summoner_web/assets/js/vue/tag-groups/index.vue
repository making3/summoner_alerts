<template>
  <div>
    <div class="loading" v-if="loading">
      Loading...
    </div>

    <div v-if="error" class="error">
      {{ error }}
    </div>

    <div v-if="tagGroups">
      <ul v-for="group in tagGroups">
        <li>
          <router-link :to="{ name: 'tag-group', params: { id: group.id } }">{{ group.name }}</router-link>
          <button v-on:click="deleteGroup(group.id)">Delete</button>
        </li>
      </ul>
      <input type="text" v-model="name" placeholder="Group name"></input>
      <button v-on:click="createGroup()">Create Group</button>
    </div>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    data () {
      return {
        name: '',
        loading: false,
        tagGroups: null,
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
        this.error = this.tagGroups = null;
        this.loading = true
        this.getTagGroups((err, tagGroups) => {
          if (err) {
            this.error = err.toString();
          } else {
            this.tagGroups = tagGroups;
          }
          this.loading = false;
        })
      },
      getTagGroups (callback) {
        axios.get('/api/tag-groups')
          .then(response => callback(null, response.data))
          .catch(callback);
      },
      createGroup () {
        this.error = null;
        if (!this.name) {
          this.error = 'Name does not exist';
          return;
        }

        // TODO: Put a loading indicator
        axios.post('/api/tag-groups', {
          name: this.name
        })
          .then((tagGroup) => {
            this.tagGroups.push(tagGroup.data)
            this.name = ''
          })
          .catch(error => {
            this.error = error.toString();
          })
      },
      deleteGroup(id) {
        axios.delete(`/api/tag-groups/${id}`)
          .then(() => {
            const tagGroupIndex = this.tagGroups.findIndex((tg) =>
              tg.id === id
            );
            this.tagGroups.splice(tagGroupIndex, 1);
          })
          .catch(error => {
            this.deleteId = null;
            this.error = error.toString();
          });
      }
    }
  }
</script>
