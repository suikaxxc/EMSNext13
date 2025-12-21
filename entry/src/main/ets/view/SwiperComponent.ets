import { McLineChart, Options } from '@mcui/mccharts'
import EnvironmentViewModel from '../viewmodel/EnvironmentViewModel';

@Component
export struct SwiperComponent {
  @State tempArray: number[] = [24, 24, 25, 26, 25, 24, 23];
  @State humArray: number[] = [70, 72, 74, 73, 75, 71, 70];
  @State gasArray: number[] = [650, 720, 680, 750, 690, 640, 610];

  @State tempOption: Options = new Options({
    title: {
      show: true,
       text: '水温趋势',
       right: 20,
       top: 30
     },
    color:['#008000'],
    xAxis: {
       data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
     },
     yAxis: {
       name: '单位：℃'
     },
     series: [
       {
         name: '水温',
         data: this.tempArray
       }
     ]
  })
  @State humOption: Options = new Options({
    title: {
      show: true,
       text: '水位趋势',
       right: 20,
       top: 30
     },
    color:['#008000'],
    xAxis: {
      data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
     },
     yAxis: {
       name: '单位：%'
     },
     series: [
       {
         name: '水位',
         data: this.humArray
       }
     ]
  })
  @State gasOption: Options = new Options({
    title: {
      show: true,
       text: '光照趋势',
       right: 20,
       top: 30
     },
    color:['#008000'],
    xAxis: {
      data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
    },
    yAxis: {
       name: '单位：lux'
     },
     series: [
       {
         name: '光照强度',
         data: this.gasArray
       }
     ]
  })

  updateData(array: number[], value: number) {
    if (!array || typeof value !== 'number') {
      return;
    }
    array.push(value)
    if (array.length > 7) {
      array.splice(0, 1)
    }
  }

  upOption(){
     this.tempOption.setVal({
       series: [
         {
           name: '水温',
           data: this.tempArray
         }
       ]
     })
     this.humOption.setVal({
       series: [
         {
           name: '水位',
           data: this.humArray
         }
       ]
     })
     this.gasOption.setVal({
       series: [
         {
           name: '光照强度',
           data: this.gasArray
         }
       ]
     })
  }
  @Prop @Watch('onItemUpdated')
  item: EnvironmentViewModel = new EnvironmentViewModel();
  onItemUpdated() {
    this.updateData(this.tempArray, this.item.temp)
    this.updateData(this.humArray, this.item.hum)
    this.updateData(this.gasArray, this.item.gas)
    this.upOption();
  }

  build() {
    Swiper() {
      McLineChart({
        options: this.tempOption
      })
        .height('30%')

      McLineChart({
        options: this.humOption
      }).height('30%')

      McLineChart({
        options: this.gasOption
      })
        .height('30%')
    }
    .loop(true)
    .autoPlay(true)
    .interval(3000)
    .backgroundColor(Color.White)
    .indicator( // 设置圆点导航点样式
      new DotIndicator()
        .itemWidth(10)
        .itemHeight(10)
        .selectedItemWidth(18)
        .selectedItemHeight(12)
        .color(Color.Gray)
        .selectedColor(Color.Green))
    .margin({ left: 10, right: 10 })
    .padding(10)
    .borderRadius(10)
    .width('94%')
  }
}
