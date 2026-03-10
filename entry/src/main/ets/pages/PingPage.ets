import socket from '@ohos.net.socket'

@Component
export struct PingPage {
  @State targetHost: string = '8.8.8.8'
  @State pingCount: number = 4
  @State pingResults: string = ''
  @State isPinging: boolean = false
  
  async doPing() {
    this.isPinging = true
    this.pingResults = `开始 Ping ${this.targetHost}...\n\n`
    
    try {
      // 使用 TCP 连接模拟 Ping（鸿蒙没有原生 ICMP API）
      for (let i = 0; i < this.pingCount; i++) {
        const startTime = Date.now()
        
        const tcpSocket = socket.constructTCPSocketInstance()
        await tcpSocket.connect({
          address: { address: this.targetHost, port: 80 },
          timeout: 5000
        })
        
        const endTime = Date.now()
        const rtt = endTime - startTime
        
        this.pingResults += `来自 ${this.targetHost}: 时间=${rtt}ms\n`
        
        tcpSocket.close()
        
        // 等待 1 秒
        await new Promise(resolve => setTimeout(resolve, 1000))
      }
      
      this.pingResults += `\nPing 完成`
    } catch (err) {
      this.pingResults += `错误: ${JSON.stringify(err)}\n`
    }
    
    this.isPinging = false
  }
  
  build() {
    Column({ space: 15 }) {
      Text('Ping 测试')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      
      // Target input
      Row() {
        Text('目标: ')
          .width(60)
        TextInput({ placeholder: 'IP 或域名', text: $$this.targetHost })
          .width('70%')
          .height(40)
          .backgroundColor('#FFFFFF')
      }
      .width('100%')
      
      // Count input
      Row() {
        Text('次数: ')
          .width(60)
        Slider({
          value: this.pingCount,
          min: 1,
          max: 10,
          step: 1
        })
          .width('50%')
          .onChange((value: number) => {
            this.pingCount = value
          })
        Text(`${this.pingCount}`)
          .width(30)
      }
      .width('100%')
      
      // Ping button
      Button(this.isPinging ? '执行中...' : '开始 Ping')
        .width('80%')
        .enabled(!this.isPinging)
        .onClick(() => {
          this.doPing()
        })
      
      // Results
      Text('结果:')
        .fontSize(16)
        .width('100%')
        .textAlign(TextAlign.Start)
      
      Scroll() {
        Text(this.pingResults)
          .fontSize(14)
          .fontFamily('monospace')
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .width('100%')
      .height(300)
      .backgroundColor('#000000')
      .padding(10)
    }
    .width('100%')
    .height('100%')
    .padding(15)
  }
}
