require 'date'

class FourPillarsLogic
  JIKKAN = ["甲","乙","丙","丁","戊","己","庚","辛","壬","癸"]
  JYUNISHI = ["子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"]
  TSUHENSEI = ["比肩","劫財","食神","傷官","偏財","正財","偏官","正官","偏印","印綬"]
  JYUNIUNSEI = ["長生","沐浴","冠帯","建禄","帝旺","衰","病","死","墓","絶","胎","養"]
  GOGYO = ["木","火","土","金","水"]
  KUUBOU = ["戌亥","申酉","午未","辰巳","寅卯","子丑"]
  SHUGOSHIN = [["丁庚丙","丙戊","壬戊","甲庚","丙甲","丙甲戊","丁甲戊","丙壬","戊丙","丙辛"],
               ["丁庚甲","丙甲","甲壬","甲庚","丙甲","丙甲","丙甲丁","丙壬甲","丙甲","丙壬戊"],
               ["丙癸","丙癸","壬庚","甲庚","丙甲癸","丙戊甲","丙甲戊","己壬庚","庚丙戊","辛丙"],
               ["庚丁丙","丙癸","壬庚己","庚甲","丙甲癸","甲丙癸","丁甲庚","壬甲","戊辛","庚辛"],
               ["庚丁壬","癸丙","壬甲","甲庚","甲丙癸","丙甲癸","甲丁","壬甲","甲庚","丙甲辛"],
               ["癸庚丁","癸辛","壬庚","甲庚","甲癸丙","癸丙辛","壬戊丙","壬癸甲","壬庚辛","辛壬"],
               ["癸丁庚","癸丙","壬庚","壬庚","壬甲丙","癸丙辛","壬癸庚","壬癸乙","癸庚辛","辛壬"],
               ["癸","癸丙甲","壬庚","甲壬","丙癸甲","癸丙","丁甲","壬甲庚","辛甲","辛壬癸"],
               ["庚丁壬","丙癸","壬戊","甲庚丙","丙癸甲","丙癸","丁甲","壬甲","戊丁","丁甲"],
               ["癸庚丁甲","丙癸","壬","甲庚丙","丙癸","丙癸","丁甲丙","壬","甲庚","辛丙"],
               ["癸庚丁甲","癸辛甲","甲壬","甲庚","甲丙癸","甲丙","甲壬","壬甲","甲丙戊","辛甲癸"],
               ["癸丁丙戊","丙戊","甲戊庚","甲庚","甲丙","丙甲戊","丁甲丙","壬丙","戊丙庚","辛戊"]]

  # 60干支表
  def self.kanshi_array
    a = []
    60.times do |i|
      j1 = FourPillarsLogic::JIKKAN[i%10]
      j2 = FourPillarsLogic::JYUNISHI[i%12]
      a += [j1+j2]
    end
    return a
  end
  KANSHI_ARRAY = kanshi_array

  # 60干支表
  def self.kanshi_hash
    h = {}
    kanshi_array.each_with_index do |v,i|
      h[v] = i+1
    end
    return h
  end
  KANSHI_HASH = kanshi_hash

  # 陰干通表
  def self.jikkan_in
    j = [nil] * 10
    [0,2,4,6,8].each do |i|
      j[i] = JIKKAN[i+1]
      j[i+1] = JIKKAN[i]
    end
    return j
  end
  JIKKAN_IN = jikkan_in
  JYUNISHI_IN = JYUNISHI.reverse

  # 十二運星エネルギー
  def self.jyuniunsei_energy
    h = {}
    energies = [9,7,10,11,12,8,4,2,5,1,3,6]
    12.times do |i|
      h[JYUNIUNSEI[i]] = energies[i]
    end
    return h
  end
  JYUNIUNSEI_ENERGY = jyuniunsei_energy

  # 年月の節入り日時 (注:時 = 時間 x 60 + 分)
  def self.load_setsuiri
    l = []
    h = {}
    open(__dir__+"/four-pillars-setsuiri.txt").each do |line|
      next if line.strip.empty? || line.start_with?("#")
      vs = line.split(",")
      if vs.count != 5 || vs[0].empty?
        puts "Invalid row: #{line}"
        next
      end
      vs.map! { |v| v.to_i }
      h[vs[0]*100+vs[1]] = [vs[2],vs[3]*60+vs[4]]
      l += [vs]
    end
    return h, l
  end
  SETSUIRI_HASH, SETSUIRI_LIST = load_setsuiri

  # 生年月日時間, 性別(大運の向きに使用)
  attr_reader :birth_dt,:gender

  def initialize(birth_dt,gender)
    @birth_dt = birth_dt.map {|v| v.to_i }
    @gender = gender
    raise "Incorrect birth date: #{birth_dt}" if @birth_dt.count != 5
    raise "Gender must be m,f or o(other): #{gender}" unless ['o','m','f'].include? @gender
    raise "Year must be larger than 1863" if @birth_dt[0] < 1864
  end

  # 生年月日と性別
  def input
    y,m,d,h,i = @birth_dt
    case @gender
    when 'm' then
      g = "男性"
    when 'f' then
      g = "女性"
    else
      g = ""
    end
    "#{y}年#{m}月#{d}日#{h}時#{i}分生 #{g}"
  end

  # 前月の日数
  def days_of_previous_month
    y,m,d,h,i = @birth_dt
    (Date.new(y,m,1) - 1).day
  end

  # 今月の日数
  def days_of_current_month
    y,m,d,h,i = @birth_dt
    Date.new(y,m,1).next_month.prev_day.day
  end

  # 前月の節入日
  def setsuiri_of_previous_month
    y,m,d,h,i = @birth_dt
    if m == 1
      y -= 1
      m = 12
    else
      m -= 1
    end
    SETSUIRI_HASH[y*100+m] || [0,0]
  end

  # 翌月の節入日
  def setsuiri_of_next_month
    y,m,d,h,i = @birth_dt
    if m == 12
      y += 1
      m = 1
    else
      m += 1
    end
    SETSUIRI_HASH[y*100+m] || [0,0]
  end

  # 生年月に対する節入日時を知っているか？
  # このメソッドがfalseを返す場合、干支、蔵干が仮の節入日で計算されています。
  def know_setsuiri?
    y,m,d,h,i = @birth_dt
    SETSUIRI_HASH.include? y*100+m
  end

  # 生年月に対応する節入り日時 ファイルに登録がない場合は、4日12時を返す
  def setsuiri
    y,m,d,h,i = @birth_dt
    SETSUIRI_HASH[y*100+m] || [4,12*60]
  end

  # 生まれた日が節入日にあたる場合、true
  def setsuiri?
    return false unless know_setsuiri?
    y,m,d,h,i = @birth_dt
    setsuiri[0] == d
  end

  # 干支(日,月,年)
  def kanshi
    y,m,d,h,i = @birth_dt
    sd, st = setsuiri
    yd = y - 1864 # (till 1865.02.0?) = 甲子
    yd -= 1 if m < 2 || (m == 2 && d < sd) || (m == 2 && d == sd && h*60+i < st)
    md = (y - 1863) * 12 + (m - 12) # (till 1864.01.05) = 甲子
    md -= 1 if d < sd || (d == sd && h*60+i < st)
    dd = Date.new(y,m,d) - Date.new(1863,12,31) # 1923.10.18 = 甲子

    return [KANSHI_ARRAY[dd % 60],KANSHI_ARRAY[md % 60],KANSHI_ARRAY[yd % 60]]
  end

  # 干支(数字)
  def kanshi_as_number
    kanshi.map {|v| KANSHI_HASH[v] }
  end

  # 蔵干数字
  def zokan_number
    y,m,d,h,i = @birth_dt
    sd, st = setsuiri
    if d < sd || (d == sd && h*60+i < st)
      # 誕生日 + (前月の日数 - 前月の節入日) + 1
      return d + (days_of_previous_month - setsuiri_of_previous_month[0]) + 1
    else
      # 誕生日 - 節入日 + 1
      return d - sd + 1
    end
  end

  def zokan
    zokan_hash1 = {"子" => "癸","卯" => "乙","酉" => "辛"}
    zokan_hash2 = {"午" => ["己",19,"丁"],"亥" => ["甲",12,"壬"]}
    zokan_hash3 = {"丑" => ["癸",9,"辛",12,"己"],"寅" => ["戊",7,"丙",14,"甲"],
      "辰" => ["乙",9,"癸",12,"戊"],"巳" => ["戊",5,"庚",14,"丙"],"未" => ["丁",9,"乙",12,"己"],
      "申" => ["戊",10,"壬",13,"庚"],"戌" => ["辛",9,"丁",13,"戊"]}
    zn = zokan_number
    z = []
    kanshi.each do |k|
      j = k[1] # 十二支
      if zokan_hash1.keys.include? j
        z += [zokan_hash1[j]]
      elsif zokan_hash2.keys.include? j
        arr = zokan_hash2[j]
        if zn <= arr[1]
          z += [arr[0]]
        else
          z += [arr[2]]
        end
      elsif zokan_hash3.keys.include? j
        arr = zokan_hash3[j]
        if zn <= arr[1]
          z += [arr[0]]
        elsif zn <= arr[3]
          z += [arr[2]]
        else
          z += [arr[4]]
        end
      end
    end
    return z
  end

  # 通変星(nil,月,年)
  def tsuhensei
    j = JIKKAN.index(kanshi[0][0])
    if j % 2 == 0 # 陽
      jikkan = JIKKAN
    else # 陰
      jikkan = JIKKAN_IN
    end
    j = jikkan.index(kanshi[0][0])
    j_month = jikkan.index(kanshi[1][0])
    j_year = jikkan.index(kanshi[2][0])
    t_month = j_month - j
    t_month += 10 if t_month < 0
    t_year = j_year - j
    t_year += 10 if t_year < 0
    [nil,TSUHENSEI[t_month],TSUHENSEI[t_year]]
  end

  # 蔵干通変星
  def zokan_tsuhensei
    j = JIKKAN.index(kanshi[0][0])
    if j % 2 == 0 # 陽
      jikkan = JIKKAN
    else # 陰
      jikkan = JIKKAN_IN
    end
    j = jikkan.index(kanshi[0][0])
    j_day = jikkan.index(zokan[0])
    j_month = jikkan.index(zokan[1])
    j_year = jikkan.index(zokan[2])
    t_day = j_day - j
    t_day += 10 if t_day < 0
    t_month = j_month - j
    t_month += 10 if t_month < 0
    t_year = j_year - j
    t_year += 10 if t_year < 0
    [TSUHENSEI[t_day],TSUHENSEI[t_month],TSUHENSEI[t_year]]
  end

  # 十二運星
  def jyuniunsei
    j = JIKKAN.index(kanshi[0][0])
    if j % 2 == 0 # 陽
      jyunishi = JYUNISHI
    else # 陰
      jyunishi = JYUNISHI_IN
    end
    offset = [1,7,10,10,10,10,7,1,4,4][j] # 十二運表より求めたオフセット
    j_day = jyunishi.index(kanshi[0][1])
    j_month = jyunishi.index(kanshi[1][1])
    j_year = jyunishi.index(kanshi[2][1])
    u_day = (j_day + offset) % 12
    u_month = (j_month + offset) % 12
    u_year = (j_year + offset) % 12
    [JYUNIUNSEI[u_day],JYUNIUNSEI[u_month],JYUNIUNSEI[u_year]]
  end

  def jyuniunsei_energy
    jyuniunsei.map {|v| JYUNIUNSEI_ENERGY[v] }
  end

  # 空亡 = 天中殺
  def kuubou
    k_day = (kanshi_as_number[0] - 1) / 10
    k_year = (kanshi_as_number[2] - 1) / 10
    [KUUBOU[k_day],KUUBOU[k_year]]
  end

  # テーブル表示用に配列にして返す (デバッグ用)
  # 0:干支, 1:干支数字, 2:蔵干, 3:通変星, 4:蔵干通変星, 5:十二運星
  # 五行、天中殺、十二運星エネルギーは別途
  def tell
    m = [kanshi]
    m += [kanshi_as_number]
    m += [zokan]
    m += [tsuhensei]
    m += [zokan_tsuhensei]
    m += [jyuniunsei]
    m += [jyuniunsei_energy]
  end

  # 五行(十干)
  def gogyo_jikkan
    arr = []
    3.times do |i|
      j = JIKKAN.index(kanshi[i][0])
      arr += [(j % 2 == 0 ? "+" : "-") + GOGYO[j / 2]]
    end
    return arr
  end

  # 五行(十二支)
  def gogyo_jyunishi
    arr = []
    gogyo_j = ["水","土","木","木","土","火","火","土","金","金","土","水"]
    3.times do |i|
      j = JYUNISHI.index(kanshi[i][1])
      arr += [(j % 2 == 0 ? "+" : "-") + gogyo_j[j]]
    end
    return arr
  end

  # 守護神
  def shugoshin
    # 日柱の十干と月柱の十二支
    x = JIKKAN.index(kanshi[0][0])
    y = JYUNISHI.index(kanshi[1][1])
    SHUGOSHIN[y][x].split("")
  end

  # 宿命中殺
  def shukumei
    s = []
    t = kuubou # 天中殺 0:上段, 1:下段
    k = kanshi.map {|v| v[1] } # 日,月,年柱の干支
    if t[0].include? k[2]
      s += ["生年中殺"]
    end
    if t[0].include? k[1]
      s += ["生月中殺"]
    end
    if t[1].include? k[0]
      s += ["生日中殺"]
    end
    f = false
    f = true if kanshi_as_number.include? 11 #甲戌
    f = true if kanshi_as_number.include? 12 #乙亥
    s += ["日座中殺"] if f
    return s
  end

  def equivalent_kanshi(only_jikkan=false)
    if only_jikkan
      k = kanshi.map {|v| v[0] } # 日,月,年柱の十干
    else
      k = kanshi
    end
    if k[0] == k[1] && k[1] == k[2]
      return [[0,1],[0,2],[1,2]]
    elsif k[0] == k[1]
      return [[0,1]]
    elsif k[0] == k[2]
      return [[0,2]]
    elsif k[1] == k[2]
      return [[1,2]]
    else
      return []
    end
  end

  def on_distance?(j1,j2,d=6)
    i = JYUNISHI.index(j1)
    return j2 == JYUNISHI[(i+d) % 12]
  end

  # 律音
  def ricchin
    # 干支(十干・十二支)が同じ
    equivalent_kanshi(false)
  end

  # 納音
  def nacchin
    # 十干が同じで十二支が 沖 の関係にある
    v = []
    eq = equivalent_kanshi(true)
    eq.each do |e|
      k0 = kanshi[e[0]][1]
      k1 = kanshi[e[1]][1]
      v += [e] if on_distance?(k0,k1,6)
    end
    return v
  end

  # 宿命大半会
  def shukumei_daihankai
    # 十干が同じで十二支が三合会局の関係にある
    v = []
    eq = equivalent_kanshi(true)
    eq.each do |e|
      k0 = kanshi[e[0]][1]
      k1 = kanshi[e[1]][1]
      v += [e] if on_distance?(k0,k1,4)
    end
    eq.each do |e|
      k0 = kanshi[e[0]][1]
      k1 = kanshi[e[1]][1]
      v += [e] if on_distance?(k0,k1,8)
    end
    return v
  end

  # 大運 [順行 or 逆行, year] or [nil,nil](if gender is not male nor female)
  def taiun
    return [nil,nil] unless ['m','f'].include? @gender
    k = gogyo_jikkan[2][0]
    if (@gender == 'm' && k == "+") || (@gender == 'f' && k == '-')
      order = "順行"
      d = setsuiri[0] - birth_dt[2]
      if d > 0 # A 生まれた日が節入り前の場合 (節入り日―誕生日＋１)÷３
        year = ((d + 1) / 3.0).round
      elsif d == 0 # 節入り日
        year = nil # TODO
      else # B 生まれた日が節入り後の場合  (誕生月の日数―誕生日＋１＋翌月の節入り日)÷３
        s = days_of_current_month - birth_dt[2] + 1 + setsuiri_of_next_month[0]
        year = (s / 3.0).round
      end
    else
      order = "逆行"
      if setsuiri?
        year = nil # TODO
      else
        year = (zokan_number / 3.0).round
      end
    end
    return [order,year]
  end
end

if __FILE__ == $0
  require 'optparse'
  Version = "1.0.0"

  bd = ["1980","7","27","1","20"]
  gender = 'm' # m or f

  opt = OptionParser.new
  opt.on('-b y,m,d,h,m') { |v| bd = v.split(",")}
  opt.on('-g (m|f)') { |v| gender = v }
  opt.parse!(ARGV)

  res = FourPillarsLogic.new(bd,gender)
  puts res.input
  puts res.tell
end
