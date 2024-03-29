require_relative '../lib/four-pillars'

def assert(expected,actual)
  if expected.is_a?(String) || expected.is_a?(Integer) ||
    expected == true || expected == false || expected == nil
    raise "Expected: #{expected}, Actual: #{actual}" unless expected == actual
  elsif expected.is_a? Array
    raise "Expected: #{expected}, Actual: #{actual}" if expected.count != actual.count
    expected.each_with_index do |e,i|
      assert(e,actual[i])
    end
  else
    raise "Unknown class for: #{expected} ,#{actual}"
  end
end

# Test internal methods.
assert(1,FourPillarsLogic::KANSHI_HASH["甲子"])
assert(60,FourPillarsLogic::KANSHI_HASH["癸亥"])
assert(true,FourPillarsLogic::plus_jikkan?("丙"))
assert(false,FourPillarsLogic::plus_jikkan?("丁"))

# Test entire the object.
fp = FourPillarsLogic.new(["1984","2","15","4","15"],"f")
puts fp.input
assert(true,fp.know_setsuiri?)
assert(["己卯","丙寅","甲子"],fp.kanshi)
assert(["-土","+火","+木"],fp.gogyo_jikkan)
assert(["-木","+木","+水"],fp.gogyo_jyunishi)
assert([16,3,1],fp.kanshi_as_number)
assert(11,fp.zokan_number)
assert(["乙","丙","癸"],fp.zokan)
assert([nil,"印綬","正官"],fp.tsuhensei)
assert(["偏官","印綬","偏財"],fp.zokan_tsuhensei)
assert(["病","死","絶"],fp.jyuniunsei)
assert([4,2,1],fp.jyuniunsei_energy)
assert(7,fp.jyuniunsei_energy.sum)
assert(["申酉","戌亥"],fp.kuubou)
assert([],fp.shukumei)
assert([],fp.ricchin)
assert([],fp.nacchin)
assert([],fp.shukumei_daihankai)

fp = FourPillarsLogic.new(["2019","10","25","16","38"],"m")
puts fp.input
assert(true,fp.know_setsuiri?)
assert(["乙未","甲戌","己亥"],fp.kanshi)
assert(["-木","+木","-土"],fp.gogyo_jikkan)
assert(["-土","+土","-水"],fp.gogyo_jyunishi)
assert([32,11,36],fp.kanshi_as_number)
assert(18,fp.zokan_number)
assert(["己","戊","壬"],fp.zokan)
assert([nil,"劫財","偏財"],fp.tsuhensei)
assert(["偏財","正財","印綬"],fp.zokan_tsuhensei)
assert(["養","墓","死"],fp.jyuniunsei)
assert([6,5,2],fp.jyuniunsei_energy)
assert(13,fp.jyuniunsei_energy.sum)
assert(["辰巳","辰巳"],fp.kuubou)
assert(["日座中殺"],fp.shukumei)
assert([],fp.ricchin)
assert([],fp.nacchin)
assert([],fp.shukumei_daihankai)

# 節入
fp = FourPillarsLogic.new(["2020","2","4","18","2"],"m")
puts fp.input
assert(true,fp.know_setsuiri?)
assert(["丁丑","丁丑","己亥"],fp.kanshi)
fp = FourPillarsLogic.new(["2020","2","4","18","3"],"m")
puts fp.input
assert(true,fp.know_setsuiri?)
assert(["丁丑","戊寅","庚子"],fp.kanshi)

# 1984,2,5,0,19
fp = FourPillarsLogic.new(["1984","2","5","0","18"],"m")
puts fp.input
assert(true,fp.know_setsuiri?)
assert(["己巳","乙丑","癸亥"],fp.kanshi)
assert(["戌亥","子丑"],fp.kuubou)
assert(["丙","甲"],fp.shugoshin)
assert([],fp.ricchin)
assert([],fp.nacchin)
assert([],fp.shukumei_daihankai)

fp = FourPillarsLogic.new(["1984","2","5","0","19"],"m")
puts fp.input
assert(true,fp.know_setsuiri?)
assert(["己巳","丙寅","甲子"],fp.kanshi)
assert(["戌亥","戌亥"],fp.kuubou)
assert(["丙","戊","甲"],fp.shugoshin)
assert([],fp.ricchin)
assert([],fp.nacchin)
assert([],fp.shukumei_daihankai)

fp = FourPillarsLogic.new(["1983","12","16","13","20"],"f")
puts fp.input
assert(true,fp.know_setsuiri?)
assert(["戊寅","甲子","癸亥"],fp.kanshi)
assert(["+土","+木","-水"],fp.gogyo_jikkan)
assert(["+木","+水","-水"],fp.gogyo_jyunishi)
assert([15,1,60],fp.kanshi_as_number)
assert(9,fp.zokan_number)
assert(["丙","癸","甲"],fp.zokan)
assert([nil,"偏官","正財"],fp.tsuhensei)
assert(["偏印","正財","偏官"],fp.zokan_tsuhensei)
assert(["長生","胎","絶"],fp.jyuniunsei)
assert([9,3,1],fp.jyuniunsei_energy)
assert(13,fp.jyuniunsei_energy.sum)
assert(["申酉","子丑"],fp.kuubou)
assert(["丙","甲"],fp.shugoshin)
assert([],fp.ricchin)
assert([],fp.nacchin)
assert([],fp.shukumei_daihankai)

fp = FourPillarsLogic.new(["1999","2","4","15","50"],"f")
puts fp.input
assert(true,fp.know_setsuiri?)
assert(["丁亥","乙丑","戊寅"],fp.kanshi)
assert(30,fp.zokan_number)
assert(["壬","己","甲"],fp.zokan)
assert(["甲","庚"],fp.shugoshin)
assert([],fp.ricchin)
assert([],fp.nacchin)
assert([],fp.shukumei_daihankai)

fp = FourPillarsLogic.new(["1999","2","4","16","00"],"f")
puts fp.input
assert(true,fp.know_setsuiri?)
assert(["丁亥","丙寅","己卯"],fp.kanshi)
assert(1,fp.zokan_number)
assert(["甲","戊","乙"],fp.zokan)
assert(["甲","庚"],fp.shugoshin)
assert([],fp.ricchin)
assert([],fp.nacchin)
assert([],fp.shukumei_daihankai)

# 律音、納音
fp = FourPillarsLogic.new(["1970","9","27","10","00"],"m")
puts fp.input
assert([[0,2]],fp.ricchin)
assert([],fp.nacchin)

fp = FourPillarsLogic.new(["1948","11","29","10","00"],"m")
puts fp.input
assert([],fp.ricchin)
assert([[0,2]],fp.nacchin)

fp = FourPillarsLogic.new(["1970","4","30","10","00"],"m")
puts fp.input
assert(["庚辰","庚辰","庚戌"],fp.kanshi)
assert([[0,1]],fp.ricchin)
assert([[0,2],[1,2]],fp.nacchin)
assert([],fp.shukumei_daihankai)

# 宿命大半会
fp = FourPillarsLogic.new(["1969","6","1","10","00"],"m")
puts fp.input
assert([[1,2]],fp.shukumei_daihankai)

fp = FourPillarsLogic.new(["1960","4","29","10","00"],"m")
puts fp.input
assert([[1,2]],fp.shukumei_daihankai)

# 大運
fp = FourPillarsLogic.new(["1980","1","1","10","00"],"o")
puts fp.input
assert([nil,nil],fp.taiun)

fp = FourPillarsLogic.new(["2021","1","1","10","00"],"f")
puts fp.input
assert(["己酉","戊子","庚子"],fp.kanshi)
assert("+金",fp.gogyo_jikkan[2])
assert(26,fp.zokan_number)
assert(false,fp.setsuiri?)
assert(['逆行',9],fp.taiun)

fp = FourPillarsLogic.new(["2021","2","15","10","00"],"m")
puts fp.input
assert(["甲午","庚寅","辛丑"],fp.kanshi)
assert("-金",fp.gogyo_jikkan[2])
assert(['逆行',4],fp.taiun)

fp = FourPillarsLogic.new(["1948","12","6","10","00"],"m")
puts fp.input
assert(false,fp.setsuiri?)
assert([7,818],fp.setsuiri)
assert("癸亥",fp.kanshi[1])
assert("+土",fp.gogyo_jikkan[2])
assert(['順行',1],fp.taiun)
assert([0,1,"癸亥","偏印","死",2],fp.taiun_table[0])
assert([1,11,"甲子","劫財","病",4],fp.taiun_table[1])
assert([11,21,"乙丑","比肩","衰",8],fp.taiun_table[2])

fp = FourPillarsLogic.new(["1964","11","7","4","5"],"f")
puts fp.input
assert(true,fp.setsuiri?)
assert([7,1095],fp.setsuiri)
assert("甲戌",fp.kanshi[1])
assert("+木",fp.gogyo_jikkan[2])
assert(['逆行',10],fp.taiun)
assert([0,10,"甲戌","偏財","衰",8],fp.taiun_table[0])
assert([10,20,"癸酉","傷官","帝旺",12],fp.taiun_table[1])
assert([20,30,"壬申","食神","建禄",11],fp.taiun_table[2])


fp = FourPillarsLogic.new(["1948","12","7","13","37"],"m")
puts fp.input
assert(['順行',1],fp.taiun)

fp = FourPillarsLogic.new(["1948","12","7","13","38"],"m")
puts fp.input
assert(['順行',1],fp.taiun)

fp = FourPillarsLogic.new(["1948","12","7","13","39"],"m")
puts fp.input
assert(['順行',10],fp.taiun)

fp = FourPillarsLogic.new(["1948","12","7","13","37"],"f")
puts fp.input
assert(['逆行',10],fp.taiun)

fp = FourPillarsLogic.new(["1948","12","7","13","38"],"f")
puts fp.input
assert(['逆行',1],fp.taiun)

fp = FourPillarsLogic.new(["1948","12","7","13","39"],"f")
puts fp.input
assert(['逆行',1],fp.taiun)

fp = FourPillarsLogic.new(["1979","1","17","10","00"],"f")
puts fp.input
assert(['逆行',4],fp.taiun)
assert([64, 74, "戊午", "偏財", "死", 2],fp.taiun_table[7])
