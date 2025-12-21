import EnvironmentViewModel from "../viewmodel/EnvironmentViewModel";

import ResultData from '../model/ResultData';
import HttpUtil from '../common/utils/HttpUtil';
import { promptAction } from '@kit.ArkUI';

interface StrategyData {
  waterLow: number;
  waterHigh: number;
  tempMin: number;
  tempMax: number;
  lightLux: number;
  lightHours: number;
  suggestion: string;
}

interface PlantConfig {
  light: number;
  temp: number;
}

interface StrategyRequest {
  plant: string;
  stage: string;
  waterTemp: number;
  waterLevel: number;
  lightLux: number;
}

const PLANT_CONFIGS: Record<string, PlantConfig> = {
  '绿萝': { light: 700, temp: 23 },
  '睡莲': { light: 900, temp: 24 },
  '水培薄荷': { light: 800, temp: 25 },
  '水竹': { light: 600, temp: 22 }
};
const DEFAULT_PLANT_CONFIG: PlantConfig = { light: 800, temp: 24 };

@Component
export struct AIComponent {
  @Link
  item: EnvironmentViewModel;
  @State
  resultString: string = '选择水生植物品种和生长阶段后，AI 将返回最优水位、水温和补光策略。'
  @State
  isBusy: boolean = false;
  @State plantOptions: string[] = ['绿萝', '睡莲', '水培薄荷', '水竹'];
  @State stageOptions: string[] = ['育苗期', '营养生长', '花芽分化', '观赏期'];
  @State plantIndex: number = 0;
  @State stageIndex: number = 1;

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
    const parm: StrategyRequest = {
      plant: this.plantOptions[this.plantIndex],
      stage: this.stageOptions[this.stageIndex],
      waterTemp: this.item.temp,
      waterLevel: this.item.hum,
      lightLux: this.item.gas
    }

    //改变状态
    this.isBusy = true;

    //AI策略请求
    HttpUtil.post<ResultData, StrategyRequest>('ai/strategy', parm)
      .then((data: ResultData) => {
        //成功后处理数据
        if (data?.success && data.data) {
          let strategy: StrategyData | null = null;
          if (typeof data.data === 'string') {
            try {
              strategy = JSON.parse(data.data) as StrategyData;
            } catch (err) {
              strategy = null;
            }
          } else {
            strategy = data.data as StrategyData;
          }
          if (strategy) {
            this.applyStrategy(strategy, 'AI策略');
            return;
          }
        }
        this.applyStrategy(this.buildLocalStrategy(), '本地策略');
      })
      .catch(() => {
        this.applyStrategy(this.buildLocalStrategy(), '本地策略');
      })
      .finally(() => {
        //最后更新状态
        this.isBusy = false
      })
  }

  private buildLocalStrategy(): StrategyData {
    const plantName = this.plantOptions[this.plantIndex] || '通用水培植物';
    const config: PlantConfig = PLANT_CONFIGS[plantName] ?? DEFAULT_PLANT_CONFIG;
    const baseLight = config.light;
    const baseTemp = config.temp;
    const stageOffset = this.stageIndex === 0 ? -1 : (this.stageIndex === 2 ? 1 : 0);
    const waterLow = 35;
    const waterHigh = 80;
    const lightHours = this.stageIndex === 0 ? 8 : (this.stageIndex === 3 ? 10 : 12);
    const rangeText = `保持水位${waterLow}%-${waterHigh}%，水温${baseTemp + stageOffset}-${baseTemp + stageOffset + 3}℃`;
    const lightText = `补光${baseLight}lux约${lightHours}小时。`;
    return {
      waterLow: waterLow,
      waterHigh: waterHigh,
      tempMin: baseTemp + stageOffset,
      tempMax: baseTemp + stageOffset + 3,
      lightLux: baseLight,
      lightHours: lightHours,
      suggestion: `${plantName}${this.stageOptions[this.stageIndex]}：${rangeText}，${lightText}`
    }
  }

  private applyStrategy(strategy: StrategyData, source: string) {
    this.resultString = `${source}：\n` +
      `水位下限${strategy.waterLow}% / 上限${strategy.waterHigh}%\n` +
      `水温${strategy.tempMin}-${strategy.tempMax}℃\n` +
      `补光目标${strategy.lightLux}lux，时长${strategy.lightHours}h\n` +
      `${strategy.suggestion || ''}`;
    this.mergeItem({
      waterLowLimit: strategy.waterLow,
      waterHighLimit: strategy.waterHigh,
      tempMin: strategy.tempMin,
      tempMax: strategy.tempMax,
      lightLuxTarget: strategy.lightLux,
      lightDurationHours: strategy.lightHours,
      plant: this.plantOptions[this.plantIndex],
      stage: this.stageOptions[this.stageIndex]
    });
  }

  private mergeItem(partial: Partial<EnvironmentViewModel>) {
    if (!partial) {
      return;
    }
    for (let key in partial) {
      (this.item as Record<string, unknown>)[key] = (partial as Record<string, unknown>)[key];
    }
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

        Button(this.isBusy ? 'AI策略生成中' : '获取AI策略')
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

      Row() {
        Column() {
          Text('养殖品种')
            .fontSize(14)
            .fontColor(Color.Gray)
          Button(this.plantOptions[this.plantIndex])
            .height(32)
            .backgroundColor(Color.White)
            .border({ color: Color.Green, width: 1 })
            .fontColor(Color.Green)
            .onClick(() => {
              this.plantIndex = (this.plantIndex + 1) % this.plantOptions.length;
            })
        }.width('45%')

        Column() {
          Text('生长阶段')
            .fontSize(14)
            .fontColor(Color.Gray)
          Button(this.stageOptions[this.stageIndex])
            .height(32)
            .backgroundColor(Color.White)
            .border({ color: Color.Green, width: 1 })
            .fontColor(Color.Green)
            .onClick(() => {
              this.stageIndex = (this.stageIndex + 1) % this.stageOptions.length;
            })
        }.width('45%')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ top: 6, bottom: 6 })

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
