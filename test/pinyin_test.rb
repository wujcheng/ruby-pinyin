# -*- coding: utf-8 -*-

require 'helper'

class PinYinTest < Minitest::Test

  def test_get_pinyin_of_multiple_pronunciation_character
    assert_equal ['hao3'], PinYin.of_string('好', true) # code 597D, value hao3
  end

  def test_get_pinyin_of_empty_string
    assert_equal [], PinYin.of_string('')
    assert_equal [], PinYin.of_string(nil)
  end

  def test_get_pinyin_of_chinese_string
    assert_equal ['jie', 'cao'], PinYin.of_string('节操')
  end

  def test_mixed_in_random_garbage_characters
    assert_equal ['jia', 'yi'], PinYin.of_string('×甲乙')
    assert_equal ['jia', 'yi'], PinYin.of_string('甲×乙')
    assert_equal ['jia', 'yi'], PinYin.of_string('甲乙×')
    assert_equal ['jia', 'yi'], PinYin.of_string('×甲×乙')
    assert_equal ['jia', 'yi'], PinYin.of_string('×甲×乙×')
    assert_equal ['jia', 'yi', 'jia', 'yi'], PinYin.of_string('×甲×乙××甲×乙×')
  end

  def test_get_pinyin_of_chinese_string_with_tone
    assert_equal ['jie2', 'cao1'], PinYin.of_string('节操', true)
  end

  def test_get_pinyin_of_chinese_string_with_ascii_tone
    assert_equal ['jie2', 'cao1'], PinYin.of_string('节操', :ascii)
  end

  def test_get_pinyin_of_chinese_string_with_unicode_tone
    assert_equal ["jié", "cāo"], PinYin.of_string('节操', :unicode)
  end

  def test_get_pinyin_of_english_phrase
    assert_equal %w(And the winner is), PinYin.of_string('And the winner is ...')
  end

  def test_get_pinyin_of_mixed_string
    pinyin = PinYin.of_string '感谢party感谢guo jia'
    assert_equal %w(gan xie party gan xie guo jia), pinyin
    assert_equal true, pinyin.all? {|word| word.class == PinYin::Value}
  end

  def test_permlink
    assert_equal 'gan-xie-party-gan-xie-guo-jia', PinYin.permlink('感谢party感谢guo jia')
  end

  def test_permlink_with_customized_seperator
    assert_equal 'gan+xie+party+gan+xie+guo+jia', PinYin.permlink('感谢party感谢guo jia', '+')
  end

  def test_abbr
    assert_equal 'gxpartygxguojia', PinYin.abbr('感谢party感谢guo jia')
  end

  def test_abbr_except_lead
    assert_equal 'ganxpartygxguojia', PinYin.abbr('感谢party感谢guo jia', true)
  end

  def test_abbr_with_english
    assert_equal 'gxpgxgj', PinYin.abbr('感谢party感谢guo jia', false, false)
  end

  def test_get_pinyin_sentence
    assert_equal 'gan xie party, gan xie guo jia!', PinYin.sentence('感谢party, 感谢guo家!')
  end

  def test_get_pinyin_sentence_with_unicode_punctuation
    assert_equal 'hello, world', PinYin.sentence('hello， world')
    assert_equal 'cè shì, cè shì', PinYin.sentence('测试, 测试', :unicode)
    assert_equal 'cè shì, cè shì', PinYin.sentence('测试，测试', :unicode)
    assert_equal 'tiān lěng le, kuài huí jiā.', PinYin.sentence('天冷了, 快回家。', :unicode)
    assert_equal 'tiān lěng le, kuài huí jiā.', PinYin.sentence('天冷了，快回家。', :unicode)
    assert_equal 'huáng fà chuí tiáo. qiān mò', PinYin.sentence('黄发垂髫。阡陌', :unicode)
    assert_equal %w(ni hao zhong guo), PinYin.of_string('你好！@_@ 中国!')
  end

  def test_get_pinyin_sentence_with_ascii_tone
    assert_equal 'gan3 xie4 party, gan3 xie4 guo jia1!', PinYin.sentence('感谢party, 感谢guo家!', :ascii)
  end

  def test_get_pinyin_sentence_with_unicode_tone
    assert_equal 'gǎn xiè party, gǎn xiè guo jiā!', PinYin.sentence('感谢party, 感谢guo家!', :unicode)
  end

  def test_get_pinyin_of_polyphone
    assert_equal ["cháng", "duǎn"], PinYin.of_string('长短', :unicode)
    assert_equal ["chǎng", "zhǎng", "duǎn", "qī", "chū", "chāi"], PinYin.of_string('厂长短期出差', :unicode)
    assert_equal ["nán", "jīng", "shì", "cháng", "jiāng", "dà", "qiáo"], PinYin.of_string('南京市长江大桥', :unicode)
    assert_equal ["zhǎng", "jìn"], PinYin.of_string('长进', :unicode)
    assert_equal ["cháng", "fāng", "xíng"], PinYin.of_string('长方形', :unicode)
    assert_equal ["yì", "zhī"], PinYin.of_string('一只', :unicode)
    assert_equal ["shǔ", "shù"], PinYin.of_string('数数', :unicode)
    #assert_equal [], PinYin.of_string('一位姓解的名医', :unicode)
    assert_equal ["jiāng", "jūn"], PinYin.of_string('将军', :unicode)
    assert_equal ["dà", "jiàng"], PinYin.of_string('大将', :unicode)
    assert_equal ["dài", "fū"], PinYin.of_string('大夫', :unicode)
    assert_equal ["shān", "dài", "wáng"], PinYin.of_string('山大王', :unicode)
    assert_equal ["máo", "fà"], PinYin.of_string('毛发', :unicode)
    assert_equal ["dà", "shān"], PinYin.of_string('大山', :unicode)
    assert_equal ["bā", "dà", "shān", "rén"], PinYin.of_string('八大山人', :unicode)
  end

  def test_ue_combination
    assert_equal "gong1 cheng2 lue3 di4", PinYin.sentence("攻城掠地", :ascii)
  end

  def test_override_files
    assert_equal ['guang3'], PinYin.romanize('广', :ascii)
    PinYin.override_files = [File.expand_path('../fixtures/my.dat', __FILE__)]
    assert_equal ['yan3'], PinYin.romanize('广', :ascii)
  end

end
