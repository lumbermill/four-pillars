require_relative '../lib/four-pillars'

def assert(expected,actual)
  if expected.is_a?(String) || expected.is_a?(Integer) ||
    expected == true || expected == false || expected == nil
    raise "Expected: #{expected}, Actual: #{actual}" unless expected == actual
  elsif expected.is_a? Array
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
fp = FourPillarsLogic.new(["1984","2","5","0","19"],"m")
puts fp.input
assert(true,fp.know_setsuiri?)
assert(["己巳","丙寅","甲子"],fp.kanshi)
assert(["戌亥","戌亥"],fp.kuubou)

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

fp = FourPillarsLogic.new(["1999","2","4","15","50"],"f")
puts fp.input
assert(true,fp.know_setsuiri?)
assert(["丁亥","乙丑","戊寅"],fp.kanshi)
assert(30,fp.zokan_number)
assert(["壬","己","甲"],fp.zokan)

fp = FourPillarsLogic.new(["1999","2","4","16","00"],"f")
puts fp.input
assert(true,fp.know_setsuiri?)
assert(["丁亥","丙寅","己卯"],fp.kanshi)
assert(1,fp.zokan_number)
assert(["甲","戊","乙"],fp.zokan)
