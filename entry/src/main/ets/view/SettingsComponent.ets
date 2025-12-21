import AquaticTankViewModel from "../viewmodel/AquaticTankViewModel";
import {
  PlantTypeArray,
  GrowthStageArray,
  PlantParamsConfig,
  SettingsChangeData
} from "../common/constants/Constant";
import { promptAction } from '@kit.ArkUI';

@Component
export struct SettingsComponent {
  @Link
  item: AquaticTankViewModel;

  // 回调函数不能使用@Prop装饰器，直接作为普通属性传递
  onSettingsChange: (settings: SettingsChangeData) => void = () => {};

  build() {
    Column() {
      // 标题
      Row() {
        Image($r('app.media.plant'))
          .width(24)
          .height(24)
        Text("植物养护设置")
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .margin({ left: 8 })
      }
      .width('100%')
      .margin({ bottom: 16 })

      // 植物品种选择
      Row() {
        Text("植物品种")
          .fontSize(14)
          .fontColor('#666666')
          .width(80)
        Select(PlantTypeArray.map((item, index) => {
          return { value: item } as SelectOption
        }))
          .selected(this.item.plantTypeIndex)
          .value(PlantTypeArray[this.item.plantTypeIndex])
          .font({ size: 14 })
          .fontColor('#333333')
          .selectedOptionFont({ size: 14 })
          .optionFont({ size: 14 })
          .layoutWeight(1)
          .onSelect((index: number) => {
            this.item.plantTypeIndex = index;
            this.applyPlantParams(index);
          })
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#F5F5F5')
      .borderRadius(8)
      .margin({ bottom: 12 })

      // 生长阶段选择
      Row() {
        Text("生长阶段")
          .fontSize(14)
          .fontColor('#666666')
          .width(80)
        Select(GrowthStageArray.map((item, index) => {
          return { value: item } as SelectOption
        }))
          .selected(this.item.growthStage)
          .value(GrowthStageArray[this.item.growthStage])
          .font({ size: 14 })
          .fontColor('#333333')
          .selectedOptionFont({ size: 14 })
          .optionFont({ size: 14 })
          .layoutWeight(1)
          .onSelect((index: number) => {
            this.item.growthStage = index;
            const changeData: SettingsChangeData = { growthStage: index };
            this.onSettingsChange(changeData);
          })
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#F5F5F5')
      .borderRadius(8)
      .margin({ bottom: 12 })

      // 当前植物参数显示
      Column({ space: 8 }) {
        Text("当前养护参数")
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .width('100%')

        Row() {
          this.ParamItem("水温范围", `${this.item.waterTempMin}-${this.item.waterTempMax}°C`, '#FF5722')
          this.ParamItem("水位范围", `${this.item.waterLevelMin}-${this.item.waterLevelMax}%`, '#2196F3')
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceEvenly)

        Row() {
          this.ParamItem("光照阈值", `${this.item.lightThreshold} lux`, '#FFC107')
          this.ParamItem("补光时长", `${this.item.lightDuration} h/天`, '#4CAF50')
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceEvenly)
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#E8F5E9')
      .borderRadius(8)
      .margin({ bottom: 12 })

      // 植物描述
      Column() {
        Text(PlantParamsConfig[this.item.plantTypeIndex]?.description || "请选择植物品种")
          .fontSize(12)
          .fontColor('#666666')
          .lineHeight(20)
          .width('100%')
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#FFF3E0')
      .borderRadius(8)

      // 应用AI推荐参数按钮
      Button("应用AI推荐参数")
        .fontSize(14)
        .fontColor(Color.White)
        .backgroundColor('#4CAF50')
        .width('100%')
        .height(40)
        .borderRadius(20)
        .margin({ top: 16 })
        .onClick(() => {
          this.applyPlantParams(this.item.plantTypeIndex);
          promptAction.showToast({
            message: `已应用${PlantTypeArray[this.item.plantTypeIndex]}的最优养护参数`,
            duration: 2000
          });
        })
    }
    .padding(12)
    .width('94%')
    .borderRadius(12)
    .backgroundColor(Color.White)
    .margin({ left: '3%', right: '3%' })
  }

  @Builder
  ParamItem(label: string, value: string, color: string) {
    Column() {
      Text(label)
        .fontSize(11)
        .fontColor('#999999')
      Text(value)
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
        .fontColor(color)
        .margin({ top: 2 })
    }
    .alignItems(HorizontalAlign.Center)
    .padding(8)
  }

  applyPlantParams(index: number) {
    const params = PlantParamsConfig[index];
    if (params) {
      this.item.waterTempMin = params.waterTempMin;
      this.item.waterTempMax = params.waterTempMax;
      this.item.waterLevelMin = params.waterLevelMin;
      this.item.waterLevelMax = params.waterLevelMax;
      this.item.lightThreshold = params.lightThreshold;
      this.item.lightDuration = params.lightDuration;

      const changeData: SettingsChangeData = {
        plantTypeIndex: index,
        waterTempMin: params.waterTempMin,
        waterTempMax: params.waterTempMax,
        waterLevelMin: params.waterLevelMin,
        waterLevelMax: params.waterLevelMax,
        lightThreshold: params.lightThreshold,
        lightDuration: params.lightDuration
      };
      this.onSettingsChange(changeData);
    }
  }
}
