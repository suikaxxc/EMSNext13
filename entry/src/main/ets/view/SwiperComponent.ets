import { McLineChart, Options } from '@mcui/mccharts'
import EnvironmentViewModel from '../viewmodel/EnvironmentViewModel';

@Component
export struct SwiperComponent {
  @State waterLevelArray: number[] = [50, 52, 48, 55, 53, 51, 50];
  @State tempArray: number[] = [24, 25, 24, 26, 25, 24, 25];
  @State lightArray: number[] = [800, 900, 1000, 850, 920, 880, 900];

  @State waterLevelOption: Options = new Options({
    title: {
      show: true,
      text: '水位变化',
      right: 20,
      top: 30
    },
    color: ['#2196F3'],
    xAxis: {
      data: ['1', '2', '3', '4', '5', '6', '7']
    },
    yAxis: {
      name: '单位：%'
    },
    series: [
      {
        name: '水位',
        data: this.waterLevelArray
      }
    ]
  })
  @State tempOption: Options = new Options({
    title: {
      show: true,
      text: '水温变化',
      right: 20,
      top: 30
    },
    color: ['#FF5722'],
    xAxis: {
      data: ['1', '2', '3', '4', '5', '6', '7']
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
  @State lightOption: Options = new Options({
    title: {
      show: true,
      text: '光照强度',
      right: 20,
      top: 30
    },
    color: ['#FFC107'],
    xAxis: {
      data: ['1', '2', '3', '4', '5', '6', '7']
    },
    yAxis: {
      name: '单位：lux'
    },
    series: [
      {
        name: '光照',
        data: this.lightArray
      }
    ]
  })

  updata(array: number[], value: number) {
    if (!array) { return; }
    array.push(value)
    if (array.length > 7) {
      array.splice(0, 1)
    }
  }

  upOption() {
    this.waterLevelOption.setVal({
      series: [
        {
          name: '水位',
          data: this.waterLevelArray
        }
      ]
    })
    this.tempOption.setVal({
      series: [
        {
          name: '水温',
          data: this.tempArray
        }
      ]
    })
    this.lightOption.setVal({
      series: [
        {
          name: '光照',
          data: this.lightArray
        }
      ]
    })
  }

  @Prop @Watch('onItemUpdated')
  item: EnvironmentViewModel = new EnvironmentViewModel();

  onItemUpdated() {
    this.updata(this.waterLevelArray, this.item.waterLevel)
    this.updata(this.tempArray, this.item.temp)
    this.updata(this.lightArray, this.item.light)
    this.upOption();
  }

  build() {
    Swiper() {
      McLineChart({
        options: this.waterLevelOption
      })
        .height('30%')

      McLineChart({
        options: this.tempOption
      }).height('30%')

      McLineChart({
        options: this.lightOption
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