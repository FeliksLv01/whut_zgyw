<template>
  <div>
    <el-card class="login-form">
      <el-form :model="loginForm">
        <h2 class="login-title">中国语文</h2>
        <el-form-item prop="username">
          <el-input v-model="loginForm.username" placeholder="用户名"></el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="loginForm.password" placeholder="密码" show-password>
          </el-input>
        </el-form-item>
        <el-form-item style="margin-bottom: 5px;text-align: center">
          <el-button style="width: 45%" type="primary" @click="login()">登录</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
const request = require('request')
const URL = 'http://59.69.102.9/zgyw/index.aspx'
export default {
  data () {
    return {
      loginForm: {
        username: '',
        password: ''
      }
    }
  },
  mounted()
  {
    this.test()
  },
  methods: {
    login () {
      this.$router.push({
        path: '/home',
        query: this.loginForm
      })
    },
    test () {
      request.get({
        url: URL,
        timeout: 3000
      }, (error, response, data) => {
        if (response === null || error) {
          alert('请确保连接到校园网')
        }
      })
    }
  }

}
</script>

<style  scoped>
.login-form {
  position: absolute;
  left: 0;
  right: 0;
  border-top: 10px solid #409eff;
}
.login-title {
  text-align: center;
  color: #409eff;
  font-size: 16px;
}
.el-form-item__content {
  display: flex;
  align-items: center;
}
</style>
