<template>
  <div>
    <el-card class="userform">
      <div slot="header" style="text-align:center">
        <span>在线时长</span>
      </div>
      <div class="formbody">
        <span style="font-size: 24px;"> {{ name }} </span>
        <span style="font-size: 24px;"> <b>{{ dateform.date }} </b></span>
        <span style="font-size: 30px;"> <b>{{ dateform.time }} </b></span>
      </div>
    </el-card>
  </div>
</template>

<script>
const cheerio = require('cheerio')
const request = require('request')
const moment = require('moment')
const URL = 'http://59.69.102.9/zgyw/index.aspx'
const URL_ARTICLE = 'http://59.69.102.9/zgyw/study/LearningContent.aspx?type=1&id=1&learningid=3073'
export default {
  data () {
    return {
      username: '',
      password: '',
      dateform: {
        date: moment(Date.now()).format('MM-DD HH:mm'),
        time: 'waiting...'
      },
      cookie: '',
      name: '正在获取在线时长'
    }
  },
  created () {
    this.login()
    setTimeout(this.loading, 5000)
    this.init()
  },
  mounted () {
    this.f()
  },
  //  mounted: function () {
  //   this.$electron.ipcRenderer.send('login-window')
  // },
  methods: {
    init () {
      this.username = this.$route.query.username
      this.password = this.$route.query.password
    },
    login () {
      request(URL, (error, response, data) => {
        if (error) {
          alert('请确保连接到校园网')
        }
        const $ = cheerio.load(data.toString())
        this.cookie = response.rawHeaders.toString().substr(144, 42)
        const VIEWSTATE = $('#__VIEWSTATE').attr('value')
        request.post({
          url: URL,
          headers: {
            'Cookie': this.cookie
          },
          form: {
            '__VIEWSTATE': VIEWSTATE,
            'ctl00$ContentPlaceHolder1$name': this.username,
            'ctl00$ContentPlaceHolder1$pwd': this.password,
            'ctl00$ContentPlaceHolder1$login': '登入'
          }
        })
      })
    },
    async f () {
      setTimeout(this.f, 60000)
      await request({
        url: URL_ARTICLE,
        headers: {
          'Cookie': this.cookie
        }
      }, () => { })
      await request({
        url: URL,
        headers: {
          'Cookie': this.cookie
        }
      },
      (error, response, body) => {
        if (!error && response.statusCode === 200) {
          const $ = cheerio.load(body.toString(), {decodeEntities: false})
          if ($('#ctl00_ContentPlaceHolder1_lblonlineTime font').html() != null) {
            const timetemp = $('#ctl00_ContentPlaceHolder1_lblonlineTime font').html()
            this.name = $('#ctl00_ContentPlaceHolder1_lblrealname').find('a').text()
            this.dateform.date = moment(Date.now()).format('MM-DD HH:mm')
            this.dateform.time = '已在线 ' + timetemp
          } else {
            this.login()
          }
        }
      })
    },
    async loading () {
      await request({
        url: URL_ARTICLE,
        headers: {
          'Cookie': this.cookie
        }
      }, () => { })
      await request({
        url: URL,
        headers: {
          'Cookie': this.cookie
        }
      },
      (error, response, body) => {
        if (!error && response.statusCode === 200) {
          const $ = cheerio.load(body.toString(), {decodeEntities: false})
          if ($('#ctl00_ContentPlaceHolder1_lblonlineTime font').html() != null) {
            const timetemp = $('#ctl00_ContentPlaceHolder1_lblonlineTime font').html()
            this.name = $('#ctl00_ContentPlaceHolder1_lblrealname').find('a').text()
            this.dateform.date = moment(Date.now()).format('MM-DD HH:mm')
            this.dateform.time = '已在线 ' + timetemp
          } else {
            this.login()
          }
        }
      })
    }
  }
}
</script>

<style scoped>
.userform {
  position: absolute;
  left: 0;
  right: 0;
  border-top: 10px solid #409eff;
}
.formbody {
  margin-top: 20px;
  display: flex;
  flex-direction: column;
  text-align: center;
  height: 138px;
}
</style>
