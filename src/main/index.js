'use strict'

import { app, BrowserWindow, Tray, Menu, dialog } from 'electron'

/**
 * Set `__static` path to static files in production
 * https://simulatedgreg.gitbooks.io/electron-vue/content/en/using-static-assets.html
 */
if (process.env.NODE_ENV !== 'development') {
  global.__static = require('path').join(__dirname, '/static').replace(/\\/g, '\\\\')
}

let mainWindow
const winURL = process.env.NODE_ENV === 'development'
  ? `http://localhost:9080`
  : `file://${__dirname}/index.html`

let tray = null
function createWindow () {
  mainWindow = new BrowserWindow({
    width: 362,
    height: 274,
    useContentSize: true,
    transparent: true
  })
  mainWindow.setMenu(null)
  mainWindow.loadURL(winURL)

  mainWindow.on('closed', () => {
    mainWindow = null
  })

  mainWindow.on('close', (event) => {
    event.preventDefault()
    dialog.showMessageBox({
      type: 'question',
      title: '状态选择',
      message: '是否在后台继续运行？',
      buttons: ['确定', '取消']
    }, (idx) => {
      if (idx === 1) {
        mainWindow.destroy()
      } else {
        mainWindow.setSkipTaskbar(true)

        mainWindow.hide()
      }
    })
    // mainWindow.setSkipTaskbar(true)

    // mainWindow.hide()
  })

  mainWindow.on('show', () => {
    tray.setHighlightMode('always')
  })
  mainWindow.on('hide', () => {
    tray.setHighlightMode('never')
  })
  // 创建系统通知区菜单
  tray = new Tray(`${__static}/icon.ico`)
  const contextMenu = Menu.buildFromTemplate([
    {label: '退出', click: () => { mainWindow.destroy() }} // 我们需要在这里有一个真正的退出（这里直接强制退出）
  ])
  tray.setToolTip('中国语文')
  tray.setContextMenu(contextMenu)
  tray.on('click', () => { // 我们这里模拟桌面程序点击通知区图标实现打开关闭应用的功能
    mainWindow.isVisible() ? mainWindow.hide() : mainWindow.show()
    mainWindow.isVisible() ? mainWindow.setSkipTaskbar(false) : mainWindow.setSkipTaskbar(true)
  })
}

app.on('ready', createWindow)

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  if (mainWindow === null) {
    createWindow()
  }
})

/**
 * Auto Updater
 *
 * Uncomment the following code below and install `electron-updater` to
 * support auto updating. Code Signing with a valid certificate is required.
 * https://simulatedgreg.gitbooks.io/electron-vue/content/en/using-electron-builder.html#auto-updating
 */

/*
import { autoUpdater } from 'electron-updater'

autoUpdater.on('update-downloaded', () => {
  autoUpdater.quitAndInstall()
})

app.on('ready', () => {
  if (process.env.NODE_ENV === 'production') autoUpdater.checkForUpdates()
})
 */
