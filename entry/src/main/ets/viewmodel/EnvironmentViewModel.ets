export default class EnvironmentViewModel {
  //0正常，1，警告;2，危险
  stat: number = 0;

  //水温（摄氏度）
  temp: number = 25;

  //水位百分比（0-100%）
  waterLevel: number = 50;

  //光照强度（lux）
  light: number = 500;

  //设备状态
  pumpOn: boolean = false;      //水泵开关状态
  heaterOn: boolean = false;    //加热器开关状态
  coolerOn: boolean = false;    //散热器开关状态
  ledOn: boolean = false;       //LED灯开关状态

  //模式: 0=自动模式, 1=手动模式
  mode: number = 0;

  //报警状态: 0=正常, 1=水位报警, 2=温度报警, 3=综合报警
  alarmType: number = 0;

  //当前选择的植物类型
  plantType: string = '';

  //当前选择的生长阶段
  growthStage: string = '';

  //AI推荐的参数设置
  recommendedTempMin: number = 20;
  recommendedTempMax: number = 28;
  recommendedWaterLevelMin: number = 30;
  recommendedWaterLevelMax: number = 80;
  recommendedLightIntensity: number = 1000;
  recommendedLightDuration: number = 8;  //小时

  //兼容旧字段（保留用于图表等）
  hum: number = 0;
  gas: number = 0;
}