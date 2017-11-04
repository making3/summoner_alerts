// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

import Threads from './vue/threads.vue'
import TagGroup from './vue/tag-groups/show.vue'
import TagGroups from './vue/tag-groups/index.vue'
import Hello from './vue/hello.vue'

const routes = [
  { path: '/', component: Threads },
  { path: '/threads', component: Threads },
  { path: '/tag-groups', component: TagGroups },
  { path: '/tag-groups/:id', name: 'tag-group', component: TagGroup },
  { path: '/hello', component: Hello },
]

const router = new VueRouter({
  routes
})

const app = new Vue({
  router
}).$mount('#router-main')
