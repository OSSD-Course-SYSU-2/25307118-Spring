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
  @State offsetX: number = 300 // 弹幕水平偏移量

  build() {
    Column({ space: 12 }) {
      // 标题
      Text('手持弹幕')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })

      // 1. 弹幕内容输入框
      TextInput({ placeholder: '输入弹幕内容', text: this.message })
        .onChange((val) => { this.message = val })
        .width('90%')
        .height(48)

      // 2. 字号调节滑块
      Row({ space: 10 }) {
        Text(`字号：${this.fontSize}`).fontSize(16)
        Slider({ min: 24, max: 80, value: this.fontSize })
          .onChange((val) => { this.fontSize = val })
          .width(180)
      }.width('90%')

      // 3. 文字颜色选择
      Text('文字颜色：').fontSize(16).width('90%')
      Row({ space: 8 }) {
        Button('白')
          .backgroundColor('#fff')
          .fontColor('#000')
          .onClick(() => { this.textColor = '#FFFFFF' })
        Button('红')
          .backgroundColor('#f44')
          .onClick(() => { this.textColor = '#FF4444' })
        Button('蓝')
          .backgroundColor('#44f')
          .onClick(() => { this.textColor = '#4444FF' })
        Button('绿')
          .backgroundColor('#4c4')
          .onClick(() => { this.textColor = '#44CC44' })
      }

      // 4. 背景颜色选择（扩展功能）
      Text('背景颜色：').fontSize(16).width('90%')
      Row({ space: 8 }) {
        Button('黑')
          .backgroundColor('#000')
          .onClick(() => { this.bgColor = '#000000' })
        Button('紫')
          .backgroundColor('#609')
          .onClick(() => { this.bgColor = '#660099' })
        Button('青')
          .backgroundColor('#066')
          .onClick(() => { this.bgColor = '#006666' })
      }

      // 5. 滚动速度调节
      Row({ space: 10 }) {
        Text(`速度：${this.speed}`).fontSize(16)
        Slider({ min: 1, max: 10, value: this.speed })
          .onChange((val) => { this.speed = val })
          .width(180)
      }.width('90%')

      // 6. 开始/停止滚动按钮
      Button(this.isRoll ? '停止滚动' : '开始滚动')
        .width('90%')
        .height(50)
        .backgroundColor('#007dff')
        .onClick(() => {
          this.isRoll = !this.isRoll;
          if (this.isRoll) {
            this.startScrollAnimation();
          } else {
            // 停止时重置偏移，避免动画残留
            this.offsetX = 300;
          }
        })

      // 7. 弹幕显示区域（彻底修复，零报错，全版本兼容）
      Stack({ alignContent: Alignment.Center }) { // 用默认居中对齐，彻底规避枚举报错
        Text(this.message)
          .fontSize(this.fontSize)
          .fontColor(this.textColor)
          .fontWeight(FontWeight.Bold)
          .translate({ x: this.offsetX }) // 新版标准位移属性，替代margin
      }
      .width('95%')
      .height(220)
      .backgroundColor(this.bgColor)
      .borderRadius(16)
      .margin({ top: 10 })
    }
    .width('100%')
    .padding(10)
  }

  // 新版标准动画方法（彻底修复语法问题）
  startScrollAnimation() {
    animateTo({
      duration: 6000 / this.speed, // 速度越快，动画时长越短
      iterations: -1, // 无限循环
      playMode: PlayMode.Normal
    }, () => {
      this.offsetX = -300; // 从右向左滚动
    });
  }
}