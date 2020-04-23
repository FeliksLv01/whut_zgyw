import Vue from 'vue'

import App from './App'
import router from './router'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
Vue.use(ElementUI)

var devInnerHeight = 274 // 开发时的InnerHeight
var devDevicePixelRatio = 1.0// 开发时的devicepixelratio
var devScaleFactor = 1.0 // 开发时的ScaleFactor
var scaleFactor = require('electron').screen.getPrimaryDisplay().scaleFactor
var zoomFactor = (window.innerHeight / devInnerHeight) * (window.devicePixelRatio / devDevicePixelRatio) * (devScaleFactor / scaleFactor)
require('electron').webFrame.setZoomFactor(zoomFactor)

if (!process.env.IS_WEB) Vue.use(require('vue-electron'))
Vue.config.productionTip = false


new Vue({
  components: { App },
  router,
  template: '<App/>'
}).$mount('#app')
