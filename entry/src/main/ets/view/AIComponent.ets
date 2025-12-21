import EnvironmentViewModel from "../viewmodel/EnvironmentViewModel";

import ResultData from '../model/ResultData';
import HttpUtil from '../common/utils/HttpUtil';
import MQTTUtil from '../common/utils/MQTTUtil';
import { promptAction } from '@kit.ArkUI';
import { getPlantParams, getAIPromptTemplate, PlantParams } from '../common/constants/PlantData';

@Component
export struct AIComponent {
  @Link
  item: EnvironmentViewModel;
  @State
  resultString: string = '还未对当前环境进行评估，请先选择植物类型和生长阶段'
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

    //判断是否选择了植物类型和生长阶段
    if (!this.item.plantType || !this.item.growthStage) {
      promptAction.showToast({
        message: '请先选择植物类型和生长阶段',
        duration: 2000
      });
      return;
    }

    //设置请求参数 - 针对水生植物养殖
    let parm = getAIPromptTemplate(
      this.item.plantType,
      this.item.growthStage,
      this.item.temp,
      this.item.waterLevel,
      this.item.light
    );

    //改变状态
    this.isBusy = true;

    //AI分析请求
    HttpUtil.post<ResultData, string>('ai/analysis', parm)
      .then((data: ResultData) => {
        //成功后处理数据
        if (data?.success) {
          this.resultString = `${data.data}`;
          // 解析AI返回的参数并更新推荐值
          this.parseAndApplyAIParams(data.data);
        }
      })
      .finally(() => {
        //最后更新状态
        this.isBusy = false
      })
  }

  // 解析AI返回的参数并应用
  async parseAndApplyAIParams(aiResponse: string) {
    // 根据植物类型设置预定义参数
    const plantParams: PlantParams = getPlantParams(this.item.plantType, this.item.growthStage);

    this.item.recommendedTempMin = plantParams.tempMin;
    this.item.recommendedTempMax = plantParams.tempMax;
    this.item.recommendedWaterLevelMin = plantParams.waterLevelMin;
    this.item.recommendedWaterLevelMax = plantParams.waterLevelMax;
    this.item.recommendedLightIntensity = plantParams.lightIntensity;
    this.item.recommendedLightDuration = plantParams.lightDuration;

    // 发送参数到设备
    await MQTTUtil.getInstance().sendAIParams({
      plantType: this.item.plantType,
      growthStage: this.item.growthStage,
      tempMin: plantParams.tempMin,
      tempMax: plantParams.tempMax,
      waterLevelMin: plantParams.waterLevelMin,
      waterLevelMax: plantParams.waterLevelMax,
      lightIntensity: plantParams.lightIntensity,
      lightDuration: plantParams.lightDuration
    });

    promptAction.showToast({
      message: '已应用AI推荐参数到设备',
      duration: 2000
    });
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

        Button('AI智能养护')
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

      // 显示当前选择的植物信息
      if (this.item.plantType && this.item.growthStage) {
        Row() {
          Text(`🌿 ${this.item.plantType}`)
            .fontSize(12)
            .fontColor('#2E7D32')
            .padding(4)
            .backgroundColor('#E8F5E9')
            .borderRadius(4)
          Text(`📈 ${this.item.growthStage}`)
            .fontSize(12)
            .fontColor('#1565C0')
            .padding(4)
            .backgroundColor('#E3F2FD')
            .borderRadius(4)
            .margin({ left: 8 })
        }
        .margin({ top: 8 })
      }

      Scroll() {
        Text(this.resultString)
          .lineHeight(30)
          .fontSize(16)
          .width('100%')
      }
      .height('70%')
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
    .height('32%')
    .borderRadius(10)
    .backgroundColor(Color.White)
    .margin({ left: 10, right: 10 })
  }
}