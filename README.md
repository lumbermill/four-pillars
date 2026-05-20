# four-pillars

四柱推命の命式を計算するRubyライブラリ  
A Ruby library for calculating birth charts with Four Pillar astrology (四柱推命)

[![Gem Version](https://img.shields.io/gem/v/four-pillars)](https://rubygems.org/gems/four-pillars)
[![CI](https://github.com/lumbermill/four-pillars/actions/workflows/ci.yml/badge.svg)](https://github.com/lumbermill/four-pillars/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ruby](https://img.shields.io/badge/ruby-2.6%20%7C%202.7%20%7C%203.x%20%7C%204.0-red)](https://github.com/lumbermill/four-pillars)
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/lumbermill/four-pillars)

> **[▶ ブラウザで試す / Try it in your browser](https://lumbermill.github.io/four-pillars/)**  
> インストール不要・ruby.wasm でその場で動きます / No install needed — runs via ruby.wasm

---

## Quick Start / はじめる

```sh
gem install four-pillars
```

```ruby
require 'four-pillars'

fp = FourPillarsLogic.new([1984, 2, 15, 4, 15], 'f')

fp.input      #=> "1984年2月15日4時15分生 女性"
fp.kanshi     #=> ["己卯", "丙寅", "甲子"]
              #      日柱     月柱     年柱
fp.tsuhensei  #=> [nil,    "印綬", "正官"]
fp.jyuniunsei #=> ["病",   "死",   "絶"]
fp.kuubou     #=> ["申酉", "戌亥"]
fp.shugoshin  #=> ["丙", "甲"]
```

## Output Example / 出力例

### 命式テーブル — Birth chart columns

`tell` は命式を構成する配列群を返します。  
`tell` returns the pillars as arrays you can format into a table.

```ruby
fp = FourPillarsLogic.new([1984, 2, 15, 4, 15], 'f')
row_labels = %w[干支 干支番号 蔵干 通変星 蔵干通変星 十二運星 エネルギー]
fp.tell.zip(row_labels).each { |vals, label| printf "%-10s %s\n", label, vals.inspect }
# 干支         ["己卯", "丙寅", "甲子"]
# 干支番号     [16, 3, 25]
# 蔵干         ["乙", "丙", "癸"]
# 通変星       [nil, "印綬", "正官"]
# 蔵干通変星   ["偏財", "印綬", "偏印"]
# 十二運星     ["病", "死", "絶"]
# エネルギー   [4, 2, 1]
```

### 大運テーブル — 10-year fortune cycles (taiun_table)

```ruby
fp = FourPillarsLogic.new([1948, 12, 6, 10, 0], 'm')
fp.taiun  #=> ["順行", 7]   # direction: forward, starts at age 7

puts "%-12s %-6s %-8s %-8s %s" % %w[年齢 干支 通変星 十二運星 活力]
fp.taiun_table.each do |from, to, kanshi, tsuhen, jyunin, energy|
  puts "%-12s %-6s %-8s %-8s %d" % ["#{from}〜#{to}歳", kanshi, tsuhen.to_s, jyunin, energy]
end
# 年齢         干支   通変星   十二運星 活力
# 0〜7歳       癸亥   偏印     死       2
# 7〜17歳      甲子   劫財     病       4
# 17〜27歳     乙丑   比肩     衰       8
# ...
```

### 時柱あり — With time pillar (v0.1.13+)

```ruby
fp = FourPillarsLogic.new([1998, 2, 27, 10, 31], 'f', with_time: true)
fp.kanshi  #=> ["辛巳", "乙巳", "甲寅", "戊寅"]
           #      時柱     日柱     月柱     年柱
```

---

## API Reference / APIリファレンス

<details>
<summary>コンストラクタ / Constructor</summary>

```ruby
FourPillarsLogic.new(birth_dt, gender, with_time: false, know_time: true)
```

| 引数 | 型 | 説明 |
|---|---|---|
| `birth_dt` | Array | `[year, month, day, hour, minute]` |
| `gender` | String | `'m'`（男性）/ `'f'`（女性）/ `'o'`（その他） |
| `with_time:` | Boolean | `true` で時柱（4本目の柱）を計算 |
| `know_time:` | Boolean | `false` で生時不明として扱う |

</details>

<details>
<summary>基本情報 / Core methods</summary>

| メソッド | 戻り値例 | 説明 |
|---|---|---|
| `input` | `"1984年2月15日4時15分生 女性"` | 入力情報の文字列 |
| `kanshi` | `["己卯", "丙寅", "甲子"]` | 干支（日柱, 月柱, 年柱[, 時柱]） |
| `kanshi_as_number` | `[16, 3, 25]` | 干支番号（1〜60） |
| `zokan` | `["乙", "丙", "癸"]` | 蔵干 |
| `setsuiri` | `[Date, 時刻]` | 節入り日時 |
| `setsuiri?` | `false` | 節入り日に生まれたか |
| `know_setsuiri?` | `true` | 節入りデータが存在するか |

</details>

<details>
<summary>性格・運命 / Character & destiny</summary>

| メソッド | 戻り値例 | 説明 |
|---|---|---|
| `tsuhensei` | `[nil, "印綬", "正官"]` | 通変星 |
| `zokan_tsuhensei` | `["偏財", "印綬", "偏印"]` | 蔵干通変星 |
| `jyuniunsei` | `["病", "死", "絶"]` | 十二運星 |
| `jyuniunsei_energy` | `[4, 2, 1]` | 十二運星エネルギー値（1〜12） |
| `gogyo_jikkan` | `["+土", "+火", "+木"]` | 五行（十干） |
| `gogyo_jyunishi` | `["-木", "+木", "-水"]` | 五行（十二支） |

</details>

<details>
<summary>特殊パターン / Special patterns</summary>

| メソッド | 戻り値例 | 説明 |
|---|---|---|
| `kuubou` | `["申酉", "戌亥"]` | 空亡（天中殺） |
| `shugoshin` | `["丙", "甲"]` | 守護神 |
| `ricchin` | `[true, false, false]` | 律音 |
| `nacchin` | `[false, false, false]` | 納音 |
| `shukumei` | `[...]` | 宿命中殺 |
| `shukumei_daihankai` | `[...]` | 宿命大半会 |

</details>

<details>
<summary>大運 / Great Fortune (taiun)</summary>

| メソッド | 戻り値例 | 説明 |
|---|---|---|
| `taiun` | `["順行", 7]` | 大運の方向と開始年齢 |
| `taiun_table` | `[[0,7,"癸亥","偏印","死",2], ...]` | 大運一覧（8期分） |

`taiun_table` の各要素: `[開始年齢, 終了年齢, 干支, 通変星, 十二運星, エネルギー]`

</details>

<details>
<summary>クラスメソッド / Class methods</summary>

```ruby
FourPillarsLogic.kanshi_array          # 干支60種の配列
FourPillarsLogic.kanshi_hash           # 干支 → 番号のHash
FourPillarsLogic.tsuhensei(jikkan_day, jikkan_src)   # 通変星を計算
FourPillarsLogic.jyuniunsei(jikkan_day, jyunishi_src) # 十二運星を計算
FourPillarsLogic.plus_jikkan?(jikkan)  # 陽干かどうか
```

</details>

---

## Changelog

- **0.1.17** Fixed wrong taiun when time pillar is included.
- **0.1.13** Added time pillar (時柱) feature (`with_time: true`).
- **0.1.12** Fixed wrong shugoshins.
- **0.1.11** Fixed wrong shugoshins.
- **0.1.10** Updated setsuiri time for 2022 Feb.

---

## Contributors

- Kie Fukazawa — [五行アロマx四柱推命](https://meishiki.5aroma-4pillars.com/)

## References

- [日本推命協会](http://suimeikyokai.com/profile.html)
- [干支カレンダー（CASIO）](https://keisan.casio.jp/exec/system/1189949688)
- [愛され四柱推命](http://aisare-fourpillars.info/)
- 書籍: 四柱推命の事典, 平古場泰義

---

<details>
<summary>用語集 — Terminology Reference</summary>

### 通変星 (Tsuhensei)

| 読み | 漢字 |
|---|---|
| いんじゅ | 印綬 |
| へんいん | 偏印 |
| せいかん | 正官 |
| へんかん | 偏官 |
| せいざい | 正財 |
| へんざい | 偏財 |
| ごうざい | 劫財 |
| ひけん | 比肩 |
| しょうかん | 傷官 |
| しょくじん | 食神 |

### 十干 (Jikkan / Heavenly Stems)

| 読み | 漢字 |
|---|---|
| きのえ | 甲 |
| きのと | 乙 |
| ひのえ | 丙 |
| ひのと | 丁 |
| つちのえ | 戊 |
| つちのと | 己 |
| かのえ | 庚 |
| かのと | 辛 |
| みずのえ | 壬 |
| みずのと | 癸 |

### 十二支 (Jyunishi / Earthly Branches)

| 読み | 漢字 |
|---|---|
| い | 亥 |
| ね | 子 |
| うし | 丑 |
| とら | 寅 |
| う | 卯 |
| たつ | 辰 |
| み | 巳 |
| うま | 午 |
| ひつじ | 未 |
| さる | 申 |
| とり | 酉 |
| いぬ | 戌 |

### 十二運星 (Jyuniunsei / Twelve Life Stages)

| 読み | 漢字 | エネルギー |
|---|---|---|
| たい | 胎 | 2 |
| よう | 養 | 3 |
| ちょうせい | 長生 | 10 |
| もくよく | 沐浴 | 5 |
| かんたい | 冠帯 | 9 |
| けんろく | 建禄 | 11 |
| ていおう | 帝旺 | 12 |
| すい | 衰 | 8 |
| びょう | 病 | 4 |
| し | 死 | 2 |
| ぼ | 墓 | 6 |
| ぜつ | 絶 | 1 |

</details>
