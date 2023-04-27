# four-pillars
A class which tells fortune by Four Pillar astrology(四柱推命).

## Installation

```
sudo gem install four-pillars
```

## Usage

```
require 'four-pillars'

fp = FourPillarsLogic.new([1980,7,18,0,0],'f')
puts fp.input
#=> 1980年7月18日0時0分生 女性
p fp.kanshi
#=> ["壬辰", "癸未", "庚申"]
p fp.kanshi_as_number
#=> [29, 20, 57]
p fp.zokan
#=> ["癸", "乙", "壬"]
p fp.setsuiri?
#=> false
```

See test cases for more methods.


## Changelog
- 0.1.12 Fixed wrong shugoshins.
- 0.1.11 Fixed wrong shugoshins.
- 0.1.10 Update setsuiri time on 2022 Feb. 11:42->11:43 [国立天文台 令和 5年(2023) 暦要項](https://eco.mtk.nao.ac.jp/koyomi/yoko/2023/rekiyou232.html)

## Contributors
- Kie Fukazawa [五行アロマx四柱推命](https://meishiki.5aroma-4pillars.com/)

## References
- [日本推命協会](http://suimeikyokai.com/profile.html)
- [干支カレンダー](https://keisan.casio.jp/exec/system/1189949688)
- [愛され四柱推命](http://aisare-fourpillars.info/)

- 書籍
  - 四柱推命の事典,平古場泰義

### 通変星

```
いんじゅ 印綬
へんいん 偏印
せいかん 正官
へんかん 偏官
せいざい 正財
へんざい 偏財
ごうざい 劫財
ひけん 比肩
しょうかん 傷官
しょくじん 食神
```

### 十干

```
きのえ 甲
きのと 乙
ひのえ 丙
ひのと 丁
つちのえ 戊
つちのと 己
かのえ 庚
かのと 辛
みずのえ 壬
みずのと 癸
```

### 十二支

```
い 亥
ね 子
うし 丑
とら 寅
う 卯
たつ 辰
み 巳
うま 午
ひつじ 未
さる 申
とり 酉
いぬ 戌
```

### 十二運星

```
たい 胎
よう 養
ちょうせい 長生
もくよく 沐浴
かんたい 冠帯
けんろく 建禄
ていおう 帝旺
すい 衰
びょう 病
し 死
ぼ 墓
ぜつ 絶
```
