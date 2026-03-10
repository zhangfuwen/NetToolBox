import http from '@ohos.net.http'

@Component
export struct HttpPage {
  @State url: string = 'https://api.github.com/users/github'
  @State method: string = 'GET'
  @State requestBody: string = ''
  @State responseText: string = ''
  @State isLoading: boolean = false
  @State statusCode: number = 0
  
  private methods: string[] = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH']
  
  async sendRequest() {
    this.isLoading = true
    this.responseText = '发送请求...\n\n'
    
    try {
      const httpRequest = http.createHttp()
      
      let result: http.HttpResponse
      
      if (this.method === 'GET') {
        result = await httpRequest.request(this.url, {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json'
          },
          connectTimeout: 10000,
          readTimeout: 10000
        })
      } else if (this.method === 'POST') {
        result = await httpRequest.request(this.url, {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: this.requestBody,
          connectTimeout: 10000,
          readTimeout: 10000
        })
      } else if (this.method === 'PUT') {
        result = await httpRequest.request(this.url, {
          method: http.RequestMethod.PUT,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: this.requestBody,
          connectTimeout: 10000,
          readTimeout: 10000
        })
      } else if (this.method === 'DELETE') {
        result = await httpRequest.request(this.url, {
          method: http.RequestMethod.DELETE,
          header: {
            'Content-Type': 'application/json'
          },
          connectTimeout: 10000,
          readTimeout: 10000
        })
      } else {
        result = await httpRequest.request(this.url, {
          method: http.RequestMethod.GET,
          connectTimeout: 10000,
          readTimeout: 10000
        })
      }
      
      this.statusCode = result.responseCode
      
      this.responseText = `状态码: ${result.responseCode}\n\n`
      this.responseText += `响应头:\n${JSON.stringify(result.header, null, 2)}\n\n`
      this.responseText += `响应体:\n${result.result}`
      
      httpRequest.destroy()
    } catch (err) {
      this.responseText = `错误: ${JSON.stringify(err)}`
      this.statusCode = 0
    }
    
    this.isLoading = false
  }
  
  build() {
    Column({ space: 15 }) {
      Text('HTTP 客户端')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      
      // URL input
      Row() {
        Text('URL: ')
          .width(50)
        TextInput({ placeholder: 'https://...', text: $$this.url })
          .width('75%')
          .height(40)
          .backgroundColor('#FFFFFF')
      }
      .width('100%')
      
      // Method selector
      Row() {
        Text('方法: ')
          .width(50)
        Select(this.methods)
          .selected(this.methods.indexOf(this.method))
          .value(this.method)
          .onSelect((index: number) => {
            this.method = this.methods[index]
          })
          .width('40%')
      }
      .width('100%')
      
      // Body input (for POST/PUT)
      if (this.method === 'POST' || this.method === 'PUT') {
        Text('请求体 (JSON):')
          .width('100%')
          .textAlign(TextAlign.Start)
        
        TextArea({ placeholder: '{"key": "value"}', text: $$this.requestBody })
          .width('100%')
          .height(100)
          .backgroundColor('#FFFFFF')
      }
      
      // Send button
      Button(this.isLoading ? '发送中...' : '发送请求')
        .width('80%')
        .enabled(!this.isLoading)
        .backgroundColor(this.statusCode >= 200 && this.statusCode < 300 ? '#00AA00' : '#007DFF')
        .onClick(() => {
          this.sendRequest()
        })
      
      // Response
      Text('响应:')
        .fontSize(16)
        .width('100%')
        .textAlign(TextAlign.Start)
      
      Scroll() {
        Text(this.responseText)
          .fontSize(12)
          .fontFamily('monospace')
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .width('100%')
      .height(350)
      .backgroundColor('#1E1E1E')
      .fontColor('#00FF00')
      .padding(10)
    }
    .width('100%')
    .height('100%')
    .padding(15)
  }
}
