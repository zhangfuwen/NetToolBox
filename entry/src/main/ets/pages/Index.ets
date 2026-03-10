import { PingPage } from './PingPage'
import { HttpPage } from './HttpPage'
import { BlePage } from './BlePage'
import { WifiPage } from './WifiPage'

@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  
  private tabs: string[] = ['Ping', 'HTTP', 'BLE', 'WiFi']
  
  build() {
    Column() {
      // Title
      Text('网络调试工具箱')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin(20)
      
      // Tab buttons
      Row() {
        ForEach(this.tabs, (item: string, index: number) => {
          Button(item)
            .type(ButtonType.Capsule)
            .backgroundColor(this.currentIndex === index ? '#007DFF' : '#E5E5E5')
            .fontColor(this.currentIndex === index ? '#FFFFFF' : '#000000')
            .margin(5)
            .onClick(() => {
              this.currentIndex = index
            })
        })
      }
      .margin(10)
      
      // Content area
      Column() {
        if (this.currentIndex === 0) {
          PingPage()
        } else if (this.currentIndex === 1) {
          HttpPage()
        } else if (this.currentIndex === 2) {
          BlePage()
        } else if (this.currentIndex === 3) {
          WifiPage()
        }
      }
      .width('100%')
      .height('80%')
      .padding(10)
      
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
