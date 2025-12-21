import EnvironmentViewModel from "../viewmodel/EnvironmentViewModel";
import { PlantTypeArray, GrowthStageArray } from '../common/constants/Constant';
import { promptAction } from '@kit.ArkUI';

@Component
export struct PlantSelectionComponent {
  @Link item: EnvironmentViewModel;
  @State selectedPlantIndex: number = -1;
  @State selectedStageIndex: number = -1;
  @State showPlantPicker: boolean = false;
  @State showStagePicker: boolean = false;

  build() {
    Column() {
      Text('🌿 植物选择')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .width('100%')
        .padding({ bottom: 10 })

      Row() {
        Column() {
          Text('养殖植物')
            .fontSize(12)
            .fontColor('#666666')
          Button(this.item.plantType || '请选择植物')
            .fontSize(14)
            .height(36)
            .width('100%')
            .backgroundColor('#E8F5E9')
            .fontColor(this.item.plantType ? '#2E7D32' : '#999999')
            .onClick(() => {
              this.showPlantPickerDialog();
            })
        }
        .width('48%')

        Column() {
          Text('生长阶段')
            .fontSize(12)
            .fontColor('#666666')
          Button(this.item.growthStage || '请选择阶段')
            .fontSize(14)
            .height(36)
            .width('100%')
            .backgroundColor('#E3F2FD')
            .fontColor(this.item.growthStage ? '#1565C0' : '#999999')
            .onClick(() => {
              this.showStagePickerDialog();
            })
        }
        .width('48%')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      // 显示当前推荐参数
      if (this.item.plantType && this.item.growthStage) {
        Column() {
          Text('📊 AI推荐参数')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 12, bottom: 8 })

          Grid() {
            GridItem() {
              this.ParamCard('水温范围', `${this.item.recommendedTempMin}-${this.item.recommendedTempMax}℃`, '#FF5722')
            }

            GridItem() {
              this.ParamCard('水位范围', `${this.item.recommendedWaterLevelMin}-${this.item.recommendedWaterLevelMax}%`, '#2196F3')
            }

            GridItem() {
              this.ParamCard('光照强度', `${this.item.recommendedLightIntensity} lux`, '#FFC107')
            }

            GridItem() {
              this.ParamCard('光照时长', `${this.item.recommendedLightDuration} 小时`, '#4CAF50')
            }
          }
          .columnsTemplate('1fr 1fr')
          .rowsTemplate('1fr 1fr')
          .columnsGap(8)
          .rowsGap(8)
          .width('100%')
          .height(100)
        }
      }
    }
    .padding(10)
    .width('94%')
    .borderRadius(10)
    .backgroundColor(Color.White)
    .margin({ left: 10, right: 10 })
  }

  @Builder
  ParamCard(label: string, value: string, color: string) {
    Column() {
      Text(label)
        .fontSize(10)
        .fontColor('#666666')
      Text(value)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
        .margin({ top: 2 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .borderRadius(6)
    .backgroundColor('#FAFAFA')
  }

  showPlantPickerDialog() {
    AlertDialog.show({
      title: '选择养殖植物',
      message: '请选择您要养殖的水生植物类型',
      autoCancel: true,
      alignment: DialogAlignment.Center,
      buttons: PlantTypeArray.map((plant, index) => ({
        value: plant,
        action: () => {
          this.item.plantType = plant;
          this.selectedPlantIndex = index;
          promptAction.showToast({
            message: `已选择: ${plant}`,
            duration: 1500
          });
        }
      }))
    });
  }

  showStagePickerDialog() {
    if (!this.item.plantType) {
      promptAction.showToast({
        message: '请先选择植物类型',
        duration: 2000
      });
      return;
    }

    AlertDialog.show({
      title: '选择生长阶段',
      message: `${this.item.plantType}的生长阶段`,
      autoCancel: true,
      alignment: DialogAlignment.Center,
      buttons: GrowthStageArray.map((stage, index) => ({
        value: stage,
        action: () => {
          this.item.growthStage = stage;
          this.selectedStageIndex = index;
          promptAction.showToast({
            message: `已选择: ${stage}`,
            duration: 1500
          });
        }
      }))
    });
  }
}
