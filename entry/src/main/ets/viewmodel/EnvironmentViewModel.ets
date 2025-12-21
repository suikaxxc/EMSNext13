export default class EnvironmentViewModel {
  //0正常，1，警告;2，危险
  stat: number = 0;

  // 水体温度（℃）
  temp: number = 0;

  // 水位（%）
  hum: number = 0;

  // 环境/缸体光照强度（lux）
  gas: number = 0;

  // Wi-Fi 连接状态
  wifiConnected: boolean = false;
  wifiSsid: string = '';

  // 工作模式：auto / manual
  mode: string = 'auto';

  // 执行器状态
  pumpOn: boolean = false;
  heaterOn: boolean = false;
  coolerOn: boolean = false;
  ledOn: boolean = false;

  // 报警信息
  alarmMessage: string = '';

  // AI 养护策略
  plant: string = '通用水培植物';
  stage: string = '营养生长';
  waterLowLimit: number = 30;
  waterHighLimit: number = 80;
  tempMin: number = 22;
  tempMax: number = 28;
  lightLuxTarget: number = 800;
  lightDurationHours: number = 10;
}
