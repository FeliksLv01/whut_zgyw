import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/view/Home.vue'
import Login from '@/view/Login.vue'
Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'login',
      component: Login
    },
    {
      path: '/home',
      name: 'home',
      component: Home
    }
  ]
})
