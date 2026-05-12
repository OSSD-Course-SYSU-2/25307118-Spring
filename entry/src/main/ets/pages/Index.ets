@Entry
@Component
struct Index {
  // 核心状态变量
  @State message: string = '我爱鸿蒙开发'
  @State fontSize: number = 48
  @State textColor: string = '#FFFFFF'
  @State bgColor: string = '#000000'
  @State isRoll: boolean = false
  @State speed: number = 5
  @State offsetX: number = 300
  @State isFullScreen: boolean = false
  @State scrollDir: 'left' | 'right' = 'left' // 修复：改名避免关键字冲突
  @State vAlign: 'top' | 'center' | 'bottom' = 'center'
  @State isBold: boolean = true
  @State isItalic: boolean = false
  @State isStroke: boolean = false
  @State isBlink: boolean = false

  build() {
    Column({ space: 12 }) {
      // 标题
      Text('手持弹幕 Pro 增强版')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 10 })

      // 1. 弹幕内容
      TextInput({ placeholder: '输入弹幕内容', text: this.message })
        .onChange(val => this.message = val)
        .width('90%')
        .height(48)

      // 2. 字号
      Row({ space: 10 }) {
        Text(`字号：${this.fontSize}`).fontSize(16)
        Slider({ min: 20, max: 100, value: this.fontSize })
          .onChange(val => this.fontSize = val)
          .width(180)
      }.width('90%')

      // 3. 文字样式
      Text('文字样式：').fontSize(16).width('90%')
      Row({ space: 6 }) {
        Button(this.isBold ? '粗体✓' : '粗体')
          .onClick(() => this.isBold = !this.isBold)
          .width(70)
        Button(this.isItalic ? '斜体✓' : '斜体')
          .onClick(() => this.isItalic = !this.isItalic)
          .width(70)
        Button(this.isStroke ? '描边✓' : '描边')
          .onClick(() => this.isStroke = !this.isStroke)
          .width(70)
        Button(this.isBlink ? '闪烁✓' : '闪烁')
          .onClick(() => this.isBlink = !this.isBlink)
          .width(70)
      }

      // 4. 文字颜色
      Text('文字颜色：').fontSize(16).width('90%')
      Row({ space: 6 }) {
        Button(' ')
          .backgroundColor('#fff')
          .width(40)
          .onClick(() => this.textColor = '#fff')
        Button(' ')
          .backgroundColor('#f44')
          .width(40)
          .onClick(() => this.textColor = '#f44')
        Button(' ')
          .backgroundColor('#44f')
          .width(40)
          .onClick(() => this.textColor = '#44f')
        Button(' ')
          .backgroundColor('#4c4')
          .width(40)
          .onClick(() => this.textColor = '#4c4')
        Button(' ')
          .backgroundColor('#ff0')
          .width(40)
          .onClick(() => this.textColor = '#ff0')
        Button(' ')
          .backgroundColor('#f0f')
          .width(40)
          .onClick(() => this.textColor = '#f0f')
      }

      // 5. 背景颜色
      Text('背景颜色：').fontSize(16).width('90%')
      Row({ space: 6 }) {
        Button(' ')
          .backgroundColor('#000')
          .width(40)
          .onClick(() => this.bgColor = '#000')
        Button(' ')
          .backgroundColor('#111')
          .width(40)
          .onClick(() => this.bgColor = '#111')
        Button(' ')
          .backgroundColor('#609')
          .width(40)
          .onClick(() => this.bgColor = '#609')
        Button(' ')
          .backgroundColor('#066')
          .width(40)
          .onClick(() => this.bgColor = '#066')
        Button(' ')
          .backgroundColor('#222')
          .width(40)
          .onClick(() => this.bgColor = '#222')
        Button(' ')
          .backgroundColor('#333')
          .width(40)
          .onClick(() => this.bgColor = '#333')
      }

      // 6. 速度
      Row({ space: 10 }) {
        Text(`速度：${this.speed}`).fontSize(16)
        Slider({ min: 1, max: 15, value: this.speed })
          .onChange(val => this.speed = val)
          .width(180)
      }.width('90%')

      // 7. 方向 & 垂直位置
      Row({ space: 10 }) {
        Button(this.scrollDir === 'left' ? '← 从右向左' : '从左向右 →')
          .onClick(() => this.scrollDir = this.scrollDir === 'left' ? 'right' : 'left')
        Button(`位置：${this.vAlign}`)
          .onClick(() => {
            this.vAlign = this.vAlign === 'top' ? 'center' :
              this.vAlign === 'center' ? 'bottom' : 'top'
          })
      }.width('90%')

      // 8. 控制按钮
      Row({ space: 10 }) {
        Button(this.isRoll ? '⏸ 停止' : '▶ 开始')
          .width('43%')
          .backgroundColor('#007dff')
          .onClick(() => {
            this.isRoll = !this.isRoll
            if (this.isRoll) {
              this.startScrollAnimation()
            } else {
              this.offsetX = this.scrollDir === 'left' ? 300 : -300
            }
          })

        Button(this.isFullScreen ? '退出全屏' : '全屏模式')
          .width('43%')
          .backgroundColor('#ff6600')
          .onClick(() => this.isFullScreen = !this.isFullScreen)
      }

      Button('🔄 重置所有设置')
        .width('90%')
        .backgroundColor('#333')
        .onClick(() => this.resetAll())

      // 9. 弹幕展示区
      this.buildDisplayArea()
    }
    .width('100%')
    .padding(10)
    .backgroundColor('#f5f5f5')
  }

  // 弹幕展示区域（支持全屏）
  @Builder
  buildDisplayArea() {
    Stack({ alignContent: this.getAlignment() }) {
      Text(this.message)
        .fontSize(this.fontSize)
        .fontColor(this.textColor)
        .fontWeight(this.isBold ? FontWeight.Bold : FontWeight.Normal)
        .fontStyle(this.isItalic ? FontStyle.Italic : FontStyle.Normal)
        .textShadow(this.isStroke ? { radius: 2, color: '#000', offsetX: 1, offsetY: 1 } : { radius: 0 })
        .opacity(this.isBlink ? 0.2 : 1)
        .animation({ duration: 500, iterations: -1, playMode: PlayMode.Alternate })
        .translate({ x: this.offsetX })
    }
    .width(this.isFullScreen ? '100%' : '95%')
    .height(this.isFullScreen ? '100%' : 220)
    .backgroundColor(this.bgColor)
    .borderRadius(this.isFullScreen ? 0 : 16)
    .position(this.isFullScreen ? { top: 0, left: 0 } : {})
    .zIndex(this.isFullScreen ? 999 : 1)
  }

  // 安全获取对齐方式
  getAlignment(): Alignment {
    if (this.vAlign === 'top') return Alignment.Top
    if (this.vAlign === 'bottom') return Alignment.Bottom
    return Alignment.Center
  }

  // 滚动动画
  startScrollAnimation() {
    const start = this.scrollDir === 'left' ? 300 : -300
    const end = this.scrollDir === 'left' ? -300 : 300
    this.offsetX = start

    animateTo({
      duration: 6000 / this.speed,
      iterations: -1,
      playMode: PlayMode.Normal
    }, () => {
      this.offsetX = end
    })
  }

  // 重置
  resetAll() {
    this.message = '我爱鸿蒙开发'
    this.fontSize = 48
    this.textColor = '#fff'
    this.bgColor = '#000'
    this.isRoll = false
    this.speed = 5
    this.offsetX = 300
    this.isFullScreen = false
    this.scrollDir = 'left'
    this.vAlign = 'center'
    this.isBold = true
    this.isItalic = false
    this.isStroke = false
    this.isBlink = false
  }
}