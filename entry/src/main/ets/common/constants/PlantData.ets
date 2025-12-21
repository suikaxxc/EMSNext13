// 植物参数接口
export interface PlantParams {
  tempMin: number;
  tempMax: number;
  waterLevelMin: number;
  waterLevelMax: number;
  lightIntensity: number;
  lightDuration: number;
}

// 预定义的植物参数数据库
export const PlantParamsDatabase: Record<string, PlantParams> = {
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

// 默认参数
export const DefaultPlantParams: PlantParams = {
  tempMin: 20,
  tempMax: 28,
  waterLevelMin: 50,
  waterLevelMax: 70,
  lightIntensity: 800,
  lightDuration: 8
};

// 根据植物类型和生长阶段获取推荐参数
export function getPlantParams(plantType: string, growthStage: string): PlantParams {
  const key = `${plantType}_${growthStage}`;
  return PlantParamsDatabase[key] || DefaultPlantParams;
}

// AI提示词模板
export function getAIPromptTemplate(
  plantType: string,
  growthStage: string,
  temp: number,
  waterLevel: number,
  light: number
): string {
  return `我正在养殖水生植物${plantType}，目前处于${growthStage}。请给出养护建议和最佳参数设置。
当前环境数据：
- 水温：${temp}℃
- 水位：${waterLevel}%
- 光照强度：${light}lux

请提供以下信息（总共200字左右）：
1. 当前环境是否适合该植物生长
2. 推荐的最佳水温范围（℃）
3. 推荐的水位范围（%）
4. 推荐的光照强度（lux）和光照时长（小时）
5. 针对当前生长阶段的养护建议`;
}
