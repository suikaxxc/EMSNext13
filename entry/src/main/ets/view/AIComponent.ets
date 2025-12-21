import EnvironmentViewModel from "../viewmodel/EnvironmentViewModel";

import ResultData from '../model/ResultData';
import HttpUtil from '../common/utils/HttpUtil';
import { promptAction } from '@kit.ArkUI';

@Component
export struct AIComponent {
  @Prop
  item: EnvironmentViewModel;
  @State
  resultString: string = '还未对当前环境进行评估'
  @State
  isBusy: boolean = false;

  aiRequest() {
    //判断是否在请求中
    if (this.isBusy) {
      promptAction.showToast({
        message: 'AI 大模型评估中。。。',
        duration: 2000
      });
      return;
    }

    //判断当前数据是否有效
    if (!this.item) {
      promptAction.showToast({
        message: '评估数据无效',
        duration: 2000
      });
      return;
    }

    //设置请求参数
    let parm =
      `当前环境是否适合农作为生长？内容为120字左右，当前环境为，温度:${this.item.temp}度，湿度:${this.item.hum}%，可燃气体:${this.item.gas}ppm`

    //改变状态
    this.isBusy = true;

    //AI分析请求
    HttpUtil.post<ResultData, string>('ai/analysis', parm)
      .then((data: ResultData) => {
        //成功后处理数据
        if (data?.success) {
          this.resultString = `${data.data}`;
        }
      })
      .finally(() => {
        //最后更新状态
        this.isBusy = false
      })
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ai_green_128'))
          .width(40)
          .height(40)

        if (this.isBusy) {
          Row() {
            LoadingProgress()
              .width(40)
              .height(40)
              .color(Color.Green)
            Text('AI评估中。。。')
              .fontColor(Color.Green)
          }
        }

        Button('AI评估')
          .fontSize(16)
          .fontWeight(600)
          .height(34)
          .backgroundColor(Color.Green)
          .enabled(!this.isBusy)
          .onClick(() => {
            this.aiRequest();
          })
      }.width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Scroll() {
        Text(this.resultString)
          .lineHeight(30)
          .fontSize(16)
          .width('100%')
      }
      .height('82%')
      .margin({ top: 10 })
      .padding(5)
      .borderColor($r('app.color.green_128'))
      .borderWidth(1)
      .borderRadius(10)

      Blank()
    }
    .alignItems(HorizontalAlign.End)
    .padding(10)
    .width('94%')
    .height('36%')
    .borderRadius(10)
    .backgroundColor(Color.White)
    .margin({ left: 10, right: 10 })
  }
}