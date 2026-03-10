import wifi from '@ohos.wifi'
import geoLocationManager from '@ohos.geoLocationManager'

interface WifiInfo {
  ssid: string
  bssid: string
  rssi: number
  frequency: number
  channel: number
}

@Component
export struct WifiPage {
  @State isScanning: boolean = false
  @State wifiList: WifiInfo[] = []
  @State connectedWifi: string = ''
  @State logText: string = '点击"扫描 WiFi"查看附近网络\n'
  
  async startScan() {
    this.isScanning = true
    this.wifiList = []
    this.logText += '开始扫描 WiFi...\n'
    
    try {
      // 检查 WiFi 是否开启
      const isWifiActive = wifi.isWifiActive()
      if (!isWifiActive) {
        this.logText += 'WiFi 未开启\n'
        this.isScanning = false
        return
      }
      
      // 请求位置权限（WiFi 扫描需要）
      // 注意：实际应用需要申请 ohos.permission.LOCATION
      
      // 扫描 WiFi
      const scanResult = wifi.scan()
      this.logText += `扫描结果: ${scanResult ? '成功' : '失败'}\n`
      
      // 等待扫描完成
      await new Promise(resolve => setTimeout(resolve, 2000))
      
      // 获取扫描结果
      const scanInfos = wifi.getScanResults()
      
      this.wifiList = scanInfos.map(info => {
        // 计算信道
        const channel = this.frequencyToChannel(info.frequency)
        
        return {
          ssid: info.ssid || '隐藏网络',
          bssid: info.bssid,
          rssi: info.rssi,
          frequency: info.frequency,
          channel: channel
        }
      })
      
      // 按信号强度排序
      this.wifiList.sort((a, b) => b.rssi - a.rssi)
      
      this.logText += `发现 ${this.wifiList.length} 个 WiFi 网络\n`
      
      // 获取当前连接
      const linkedInfo = wifi.getLinkedInfo()
      if (linkedInfo.ssid) {
        this.connectedWifi = linkedInfo.ssid
        this.logText += `当前连接: ${linkedInfo.ssid}\n`
      }
      
    } catch (err) {
      this.logText += `扫描错误: ${JSON.stringify(err)}\n`
    }
    
    this.isScanning = false
  }
  
  frequencyToChannel(frequency: number): number {
    // 2.4GHz
    if (frequency >= 2412 && frequency <= 2484) {
      return (frequency - 2407) / 5
    }
    // 5GHz
    if (frequency >= 5170 && frequency <= 5825) {
      return (frequency - 5000) / 5
    }
    return 0
  }
  
  getSignalLevel(rssi: number): string {
    if (rssi >= -50) return '极强'
    if (rssi >= -60) return '强'
    if (rssi >= -70) return '中等'
    if (rssi >= -80) return '弱'
    return '极弱'
  }
  
  getSignalColor(rssi: number): ResourceColor {
    if (rssi >= -50) return '#00AA00'
    if (rssi >= -60) return '#88CC00'
    if (rssi >= -70) return '#FFAA00'
    if (rssi >= -80) return '#FF6600'
    return '#FF0000'
  }
  
  build() {
    Column({ space: 15 }) {
      Text('WiFi 分析')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      
      // Scan button
      Row() {
        Button(this.isScanning ? '扫描中...' : '扫描 WiFi')
          .width('45%')
          .enabled(!this.isScanning)
          .onClick(() => {
            this.startScan()
          })
        
        Button('清除列表')
          .width('45%')
          .onClick(() => {
            this.wifiList = []
            this.logText += '列表已清除\n'
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      
      // Channel distribution chart
      if (this.wifiList.length > 0) {
        Text('信道分布 (2.4GHz):')
          .fontSize(14)
          .width('100%')
          .textAlign(TextAlign.Start)
        
        Row() {
          ForEach([1, 6, 11], (channel: number) => {
            const count = this.wifiList.filter(w => w.channel === channel).length
            Column() {
              Text(`${count}`)
                .fontSize(12)
              Text(`CH${channel}`)
                .fontSize(10)
              Row()
                .width(20)
                .height(count * 10)
                .backgroundColor(count > 5 ? '#FF0000' : count > 2 ? '#FFAA00' : '#00AA00')
                .borderRadius(4)
            }
            .margin(5)
          })
        }
        .width('100%')
        .height(100)
        .justifyContent(FlexAlign.Center)
      }
      
      // WiFi list
      Text(`发现网络 (${this.wifiList.length}):`)
        .fontSize(16)
        .width('100%')
        .textAlign(TextAlign.Start)
      
      List({ space: 10 }) {
        ForEach(this.wifiList, (wifi: WifiInfo) => {
          ListItem() {
            Row() {
              Column() {
                Text(wifi.ssid)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                Text(`${wifi.frequency}MHz | CH${wifi.channel}`)
                  .fontSize(12)
                  .fontColor('#666666')
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
              
              Column() {
                Text(`${wifi.rssi} dBm`)
                  .fontSize(14)
                  .fontColor(this.getSignalColor(wifi.rssi))
                Text(this.getSignalLevel(wifi.rssi))
                  .fontSize(10)
                  .fontColor('#666666')
              }
            }
            .width('100%')
            .padding(10)
            .backgroundColor(this.connectedWifi === wifi.ssid ? '#E0FFE0' : '#FFFFFF')
            .borderRadius(8)
          }
        })
      }
      .width('100%')
      .height(250)
      .backgroundColor('#F5F5F5')
      .padding(10)
      
      // Log
      Text('日志:')
        .fontSize(16)
        .width('100%')
        .textAlign(TextAlign.Start)
      
      Scroll() {
        Text(this.logText)
          .fontSize(12)
          .fontFamily('monospace')
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .width('100%')
      .height(150)
      .backgroundColor('#000000')
      .fontColor('#00FF00')
      .padding(10)
    }
    .width('100%')
    .height('100%')
    .padding(15)
  }
}
