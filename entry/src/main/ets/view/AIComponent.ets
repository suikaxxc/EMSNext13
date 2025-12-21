import EnvironmentViewModel from "../viewmodel/EnvironmentViewModel";

import ResultData from '../model/ResultData';
import HttpUtil from '../common/utils/HttpUtil';
import MQTTUtil from '../common/utils/MQTTUtil';
import { promptAction } from '@kit.ArkUI';

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
    let parm =
      `我正在养殖水生植物${this.item.plantType}，目前处于${this.item.growthStage}。请给出养护建议和最佳参数设置。
      当前环境数据：
      - 水温：${this.item.temp}℃
      - 水位：${this.item.waterLevel}%
      - 光照强度：${this.item.light}lux
      
      请提供以下信息（总共200字左右）：
      1. 当前环境是否适合该植物生长
      2. 推荐的最佳水温范围（℃）
      3. 推荐的水位范围（%）
      4. 推荐的光照强度（lux）和光照时长（小时）
      5. 针对当前生长阶段的养护建议`

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
    // 这里可以根据AI返回的内容解析推荐参数
    // 简单示例：根据植物类型设置预定义参数
    const plantParams = this.getPlantParams(this.item.plantType, this.item.growthStage);

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

  // 根据植物类型和生长阶段获取推荐参数
  getPlantParams(plantType: string, growthStage: string): PlantParams {
    // 预定义的植物参数表
    const plantDatabase: Record<string, PlantParams> = {
      '绿萝_幼苗期': { tempMin: 18, tempMax: 25, waterLevelMin: 40, waterLevelMax: 60, lightIntensity: 500, lightDuration: 6 },
      '绿萝_生长期': { tempMin: 20, tempMax: 28, waterLevelMin: 50, waterLevelMax: 70, lightIntensity: 800, lightDuration: 8 },
      '绿萝_成熟期': { tempMin: 18, tempMax: 26, waterLevelMin: 40, waterLevelMax: 65, lightIntensity: 600, lightDuration: 6 },
      '绿萝_开花期': { tempMin: 22, tempMax: 28, waterLevelMin: 50, waterLevelMax: 70, lightIntensity: 1000, lightDuration: 10 },
      '睡莲_幼苗期': { tempMin: 20, tempMax: 28, waterLevelMin: 60, waterLevelMax: 80, lightIntensity: 1000, lightDuration: 8 },
      '睡莲_生长期': { tempMin: 22, tempMax: 30, waterLevelMin: 70, waterLevelMax: 90, lightIntensity: 1500, lightDuration: 10 },
      '睡莲_成熟期': { tempMin: 22, tempMax: 28, waterLevelMin: 65, waterLevelMax: 85, lightIntensity: 1200, lightDuration: 8 },
      '睡莲_开花期': { tempMin: 24, tempMax: 32, waterLevelMin: 70, waterLevelMax: 90, lightIntensity: 2000, lightDuration: 12 },
      '水葫芦_幼苗期': { tempMin: 18, tempMax: 26, waterLevelMin: 50, waterLevelMax: 70, lightIntensity: 800, lightDuration: 8 },
      '水葫芦_生长期': { tempMin: 20, tempMax: 30, waterLevelMin: 60, waterLevelMax: 80, lightIntensity: 1200, lightDuration: 10 },
      '水葫芦_成熟期': { tempMin: 18, tempMax: 28, waterLevelMin: 55, waterLevelMax: 75, lightIntensity: 1000, lightDuration: 8 },
      '水葫芦_开花期': { tempMin: 22, tempMax: 32, waterLevelMin: 65, waterLevelMax: 85, lightIntensity: 1500, lightDuration: 12 },
      '碗莲_幼苗期': { tempMin: 20, tempMax: 28, waterLevelMin: 50, waterLevelMax: 70, lightIntensity: 1000, lightDuration: 8 },
      '碗莲_生长期': { tempMin: 22, tempMax: 30, waterLevelMin: 60, waterLevelMax: 80, lightIntensity: 1500, lightDuration: 10 },
      '碗莲_成熟期': { tempMin: 20, tempMax: 28, waterLevelMin: 55, waterLevelMax: 75, lightIntensity: 1200, lightDuration: 8 },
      '碗莲_开花期': { tempMin: 24, tempMax: 32, waterLevelMin: 65, waterLevelMax: 85, lightIntensity: 2000, lightDuration: 12 },
      '铜钱草_幼苗期': { tempMin: 15, tempMax: 25, waterLevelMin: 40, waterLevelMax: 60, lightIntensity: 600, lightDuration: 6 },
      '铜钱草_生长期': { tempMin: 18, tempMax: 28, waterLevelMin: 50, waterLevelMax: 70, lightIntensity: 800, lightDuration: 8 },
      '铜钱草_成熟期': { tempMin: 16, tempMax: 26, waterLevelMin: 45, waterLevelMax: 65, lightIntensity: 700, lightDuration: 6 },
      '铜钱草_开花期': { tempMin: 20, tempMax: 28, waterLevelMin: 50, waterLevelMax: 70, lightIntensity: 1000, lightDuration: 10 },
      '水仙_幼苗期': { tempMin: 10, tempMax: 18, waterLevelMin: 30, waterLevelMax: 50, lightIntensity: 500, lightDuration: 6 },
      '水仙_生长期': { tempMin: 12, tempMax: 20, waterLevelMin: 40, waterLevelMax: 60, lightIntensity: 800, lightDuration: 8 },
      '水仙_成熟期': { tempMin: 10, tempMax: 18, waterLevelMin: 35, waterLevelMax: 55, lightIntensity: 600, lightDuration: 6 },
      '水仙_开花期': { tempMin: 8, tempMax: 15, waterLevelMin: 30, waterLevelMax: 50, lightIntensity: 1000, lightDuration: 10 },
      '金鱼藻_幼苗期': { tempMin: 15, tempMax: 25, waterLevelMin: 60, waterLevelMax: 80, lightIntensity: 600, lightDuration: 8 },
      '金鱼藻_生长期': { tempMin: 18, tempMax: 28, waterLevelMin: 70, waterLevelMax: 90, lightIntensity: 800, lightDuration: 10 },
      '金鱼藻_成熟期': { tempMin: 16, tempMax: 26, waterLevelMin: 65, waterLevelMax: 85, lightIntensity: 700, lightDuration: 8 },
      '金鱼藻_开花期': { tempMin: 18, tempMax: 28, waterLevelMin: 70, waterLevelMax: 90, lightIntensity: 1000, lightDuration: 12 },
      '浮萍_幼苗期': { tempMin: 15, tempMax: 28, waterLevelMin: 50, waterLevelMax: 70, lightIntensity: 500, lightDuration: 6 },
      '浮萍_生长期': { tempMin: 18, tempMax: 32, waterLevelMin: 60, waterLevelMax: 80, lightIntensity: 800, lightDuration: 8 },
      '浮萍_成熟期': { tempMin: 16, tempMax: 30, waterLevelMin: 55, waterLevelMax: 75, lightIntensity: 600, lightDuration: 6 },
      '浮萍_开花期': { tempMin: 20, tempMax: 32, waterLevelMin: 60, waterLevelMax: 80, lightIntensity: 1000, lightDuration: 10 },
      '荷花_幼苗期': { tempMin: 20, tempMax: 28, waterLevelMin: 60, waterLevelMax: 80, lightIntensity: 1200, lightDuration: 8 },
      '荷花_生长期': { tempMin: 22, tempMax: 32, waterLevelMin: 70, waterLevelMax: 90, lightIntensity: 1800, lightDuration: 10 },
      '荷花_成熟期': { tempMin: 20, tempMax: 30, waterLevelMin: 65, waterLevelMax: 85, lightIntensity: 1500, lightDuration: 8 },
      '荷花_开花期': { tempMin: 24, tempMax: 35, waterLevelMin: 70, waterLevelMax: 90, lightIntensity: 2500, lightDuration: 12 },
      '菖蒲_幼苗期': { tempMin: 15, tempMax: 25, waterLevelMin: 40, waterLevelMax: 60, lightIntensity: 500, lightDuration: 6 },
      '菖蒲_生长期': { tempMin: 18, tempMax: 28, waterLevelMin: 50, waterLevelMax: 70, lightIntensity: 800, lightDuration: 8 },
      '菖蒲_成熟期': { tempMin: 16, tempMax: 26, waterLevelMin: 45, waterLevelMax: 65, lightIntensity: 600, lightDuration: 6 },
      '菖蒲_开花期': { tempMin: 18, tempMax: 28, waterLevelMin: 50, waterLevelMax: 70, lightIntensity: 1000, lightDuration: 10 }
    };

    const key = `${plantType}_${growthStage}`;
    return plantDatabase[key] || { tempMin: 20, tempMax: 28, waterLevelMin: 50, waterLevelMax: 70, lightIntensity: 800, lightDuration: 8 };
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

// 植物参数接口
interface PlantParams {
  tempMin: number;
  tempMax: number;
  waterLevelMin: number;
  waterLevelMax: number;
  lightIntensity: number;
  lightDuration: number;
}