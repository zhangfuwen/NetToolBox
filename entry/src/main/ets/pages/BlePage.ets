import bluetooth from '@ohos.bluetooth'

interface BleDevice {
  deviceId: string
  name: string
  rssi: number
}

@Component
export struct BlePage {
  @State isScanning: boolean = false
  @State devices: BleDevice[] = []
  @State connectedDevice: string = ''
  @State logText: string = '点击"扫描设备"开始搜索 BLE 设备\n'
  @State selectedDevice: BleDevice | null = null
  
  private scanTimer: number = -1
  
  async startScan() {
    this.isScanning = true
    this.devices = []
    this.logText += '开始扫描...\n'
    
    try {
      // 检查蓝牙状态
      const state = bluetooth.getState()
      if (state !== bluetooth.BluetoothState.STATE_ON) {
        this.logText += '蓝牙未开启\n'
        this.isScanning = false
        return
      }
      
      // 开始扫描
      bluetooth.startBLEScan([
        {
          serviceUuid: ''  // 扫描所有设备
        }
      ], {
        interval: 0,
        dutyMode: bluetooth.ScanDutyMode.SCAN_MODE_LOW_POWER,
        matchMode: bluetooth.MatchMode.MATCH_MODE_AGGRESSIVE
      })
      
      // 监听扫描结果
      bluetooth.on('BLEDeviceFind', (data: bluetooth.BLEDeviceFindResult) => {
        data.data.forEach((device: bluetooth.ScanResult) => {
          const existingIndex = this.devices.findIndex(d => d.deviceId === device.deviceId)
          const bleDevice: BleDevice = {
            deviceId: device.deviceId,
            name: device.deviceName || '未知设备',
            rssi: device.rssi || -100
          }
          
          if (existingIndex >= 0) {
            this.devices[existingIndex] = bleDevice
          } else {
            this.devices.push(bleDevice)
            this.logText += `发现设备: ${bleDevice.name} (${bleDevice.deviceId}) RSSI: ${bleDevice.rssi}\n`
          }
        })
      })
      
      // 10 秒后停止扫描
      this.scanTimer = setTimeout(() => {
        this.stopScan()
      }, 10000)
      
    } catch (err) {
      this.logText += `扫描错误: ${JSON.stringify(err)}\n`
      this.isScanning = false
    }
  }
  
  stopScan() {
    this.isScanning = false
    bluetooth.stopBLEScan()
    bluetooth.off('BLEDeviceFind')
    if (this.scanTimer !== -1) {
      clearTimeout(this.scanTimer)
      this.scanTimer = -1
    }
    this.logText += '扫描停止\n'
  }
  
  async connectDevice(device: BleDevice) {
    this.logText += `正在连接 ${device.name}...\n`
    
    try {
      // 创建 GATT 客户端
      const gattClient = bluetooth.BLEDevice.createGattClientDevice(device.deviceId)
      
      // 连接
      await gattClient.connect()
      
      this.connectedDevice = device.deviceId
      this.logText += `已连接到 ${device.name}\n`
      
      // 发现服务
      const services = await gattClient.getServices()
      this.logText += `发现 ${services.length} 个服务:\n`
      services.forEach(service => {
        this.logText += `  - ${service.serviceUuid}\n`
      })
      
    } catch (err) {
      this.logText += `连接失败: ${JSON.stringify(err)}\n`
    }
  }
  
  build() {
    Column({ space: 15 }) {
      Text('BLE 调试器')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      
      // Scan button
      Row() {
        Button(this.isScanning ? '停止扫描' : '扫描设备')
          .width('45%')
          .backgroundColor(this.isScanning ? '#FF0000' : '#007DFF')
          .onClick(() => {
            if (this.isScanning) {
              this.stopScan()
            } else {
              this.startScan()
            }
          })
        
        Button('清除列表')
          .width('45%')
          .onClick(() => {
            this.devices = []
            this.logText += '列表已清除\n'
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      
      // Device list
      Text(`发现设备 (${this.devices.length}):`)
        .fontSize(16)
        .width('100%')
        .textAlign(TextAlign.Start)
      
      List({ space: 10 }) {
        ForEach(this.devices, (device: BleDevice) => {
          ListItem() {
            Row() {
              Column() {
                Text(device.name)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                Text(device.deviceId)
                  .fontSize(12)
                  .fontColor('#666666')
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
              
              Text(`${device.rssi} dBm`)
                .fontSize(14)
                .fontColor(device.rssi > -60 ? '#00AA00' : device.rssi > -80 ? '#FFAA00' : '#FF0000')
            }
            .width('100%')
            .padding(10)
            .backgroundColor(this.connectedDevice === device.deviceId ? '#E0FFE0' : '#FFFFFF')
            .borderRadius(8)
            .onClick(() => {
              this.connectDevice(device)
            })
          }
        })
      }
      .width('100%')
      .height(200)
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
      .height(250)
      .backgroundColor('#000000')
      .fontColor('#00FF00')
      .padding(10)
    }
    .width('100%')
    .height('100%')
    .padding(15)
  }
}
