//环境安全级别
export const StatusArray: string[] = ["安全", "警告", "危险", "未知"];

//报警类型
export const AlarmTypeArray: string[] = ["正常", "水位报警", "温度报警", "综合报警"];

//模式类型
export const ModeArray: string[] = ["自动模式", "手动模式"];

//植物类型列表
export const PlantTypeArray: string[] = [
  "绿萝",
  "睡莲",
  "水葫芦",
  "碗莲",
  "铜钱草",
  "水仙",
  "金鱼藻",
  "浮萍",
  "荷花",
  "菖蒲"
];

//生长阶段列表
export const GrowthStageArray: string[] = [
  "幼苗期",
  "生长期",
  "成熟期",
  "开花期"
];

//服务器IP
const HOST_IP = '192.168.100.77'

//MQTT服务端地址
export const MQTT_URL = `${HOST_IP}:1883`

//MQTT控制主题
export const MQTT_CONTROL_TOPIC = 'ems/control'

//大模型服务API
export const WEB_BASE_URL = `http://${HOST_IP}:8080/`