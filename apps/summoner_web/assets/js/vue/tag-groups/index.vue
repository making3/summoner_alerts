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
          <span v-if="groupBeingEdited && groupBeingEdited.id === group.id">
            <input type="text" v-model="newName" placeholder="Group name" v-on:keyup.13="updateGroup(group.id)"></input>
            <input type="text" v-model="newColor" placeholder="Color" v-on:keyup.13="updateGroup(group.id)"></input>
            <button v-on:click="updateGroup(group.id)">Update</button>
            <button v-on:click="cancelEdit(group.id)">Cancel</button>
          </span>
          <span v-else>
            <router-link :to="{ name: 'tag-group', params: { id: group.id } }">{{ group.name }}</router-link>
            <span v-bind:style="{ color: group.color }">{{ group.color }}</span>
            <button v-on:click="editGroup(group.id)">Edit</button>
            <button v-on:click="deleteGroup(group.id)">Delete</button>
          </span>
        </li>
      </ul>
      <input type="text" v-model="name" placeholder="Group name" v-on:keyup.13="createGroup()"></input>
      <input type="text" v-model="color" placeholder="Color" v-on:keyup.13="createGroup()"></input>
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
        color: '',
        loading: false,
        tagGroups: null,
        newName: '',
        newColor: '',
        groupBeingEdited: null,
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
          name: this.name,
          color: this.color
        })
          .then((tagGroup) => {
            this.tagGroups.push(tagGroup.data);
            this.name = '';
            this.color = '';
          })
          .catch(error => {
            this.error = error.toString();
          })
      },
      editGroup (id) {
        const group = this.tagGroups.find(tg => tg.id === id);
        this.newName = group.name;
        this.newColor = group.color;
        this.groupBeingEdited = group;
      },
      cancelEdit (id) {
        const group = this.tagGroups.find(tg => tg.id === id);
        this.newName = '';
        this.newColor = '';
        this.groupBeingEdited = null;
      },
      updateGroup (id) {
        const group = this.tagGroups.find(tg => tg.id === id);
        axios.put(`/api/tag-groups/${group.id}`, {
          name: this.newName,
          color: this.newColor
        })
          .then((response) => {
            group.name = response.data.name;
            group.color = response.data.color;
            this.groupBeingEdited = null;
            group.newName = '';
            group.newColor = '';
          })
          .catch(error => {
            this.error = error.toString();
          });
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
