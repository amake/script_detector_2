# frozen_string_literal: true

require 'test_helper'

class ScriptDetector2Test < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ScriptDetector2::VERSION
  end

  def test_japanese?
    assert(ScriptDetector2.japanese?(' 私のホバークラフトは鰻でいっぱいです.'))
    refute(ScriptDetector2.japanese?(' 我的气垫船充满了鳝鱼.'))
    refute(ScriptDetector2.japanese?(' 我的氣墊船充滿了鱔魚.'))
    refute(ScriptDetector2.japanese?(' 내 호버크라프트는 장어로 가득 차 있어요.'))
    refute(ScriptDetector2.japanese?(' Hello, world!'))
    refute(ScriptDetector2.japanese?('123,456日元(含稅)'))
  end

  def test_kana?
    assert(ScriptDetector2.kana?(' 私のホバークラフトは鰻でいっぱいです.'))
    assert(ScriptDetector2.kana?('あいうえお'))
    assert(ScriptDetector2.kana?('アイウエオ'))
    refute(ScriptDetector2.kana?('亜'))
    refute(ScriptDetector2.kana?(' 내 호버크라프트는 장어로 가득 차 있어요.'))
    refute(ScriptDetector2.kana?(' Hello, world!'))
  end

  def test_chinese?
    refute(ScriptDetector2.chinese?(' 私のホバークラフトは鰻でいっぱいです.'))
    assert(ScriptDetector2.chinese?(' 我的气垫船充满了鳝鱼.'))
    assert(ScriptDetector2.chinese?(' 我的氣墊船充滿了鱔魚.'))
    refute(ScriptDetector2.chinese?(' 내 호버크라프트는 장어로 가득 차 있어요.'))
    refute(ScriptDetector2.chinese?(' Hello, world!'))
    assert(ScriptDetector2.chinese?('123,456日元(含稅)'))
  end

  def test_simplified_chinese?
    refute(ScriptDetector2.simplified_chinese?(' 私のホバークラフトは鰻でいっぱいです.'))
    assert(ScriptDetector2.simplified_chinese?(' 我的气垫船充满了鳝鱼.'))
    refute(ScriptDetector2.simplified_chinese?(' 我的氣墊船充滿了鱔魚.'))
    refute(ScriptDetector2.simplified_chinese?(' 내 호버크라프트는 장어로 가득 차 있어요.'))
    refute(ScriptDetector2.simplified_chinese?(' Hello, world!'))
    refute(ScriptDetector2.simplified_chinese?('123,456日元(含稅)'))
  end

  def test_traditional_chinese?
    refute(ScriptDetector2.traditional_chinese?(' 私のホバークラフトは鰻でいっぱいです.'))
    refute(ScriptDetector2.traditional_chinese?(' 我的气垫船充满了鳝鱼.'))
    assert(ScriptDetector2.traditional_chinese?(' 我的氣墊船充滿了鱔魚.'))
    refute(ScriptDetector2.traditional_chinese?(' 내 호버크라프트는 장어로 가득 차 있어요.'))
    refute(ScriptDetector2.traditional_chinese?(' Hello, world!'))
    assert(ScriptDetector2.traditional_chinese?('123,456日元(含稅)'))
  end

  def test_korean?
    refute(ScriptDetector2.korean?(' 私のホバークラフトは鰻でいっぱいです.'))
    refute(ScriptDetector2.korean?(' 我的气垫船充满了鳝鱼.'))
    refute(ScriptDetector2.korean?(' 我的氣墊船充滿了鱔魚.'))
    assert(ScriptDetector2.korean?(' 내 호버크라프트는 장어로 가득 차 있어요.'))
    refute(ScriptDetector2.korean?(' Hello, world!'))
    assert(ScriptDetector2.korean?('123,456日元(含稅)'))
  end

  def test_hangul?
    refute(ScriptDetector2.hangul?(' 私のホバークラフトは鰻でいっぱいです.'))
    refute(ScriptDetector2.hangul?('あいうえお'))
    refute(ScriptDetector2.hangul?('アイウエオ'))
    refute(ScriptDetector2.hangul?('亜'))
    assert(ScriptDetector2.hangul?(' 내 호버크라프트는 장어로 가득 차 있어요.'))
    refute(ScriptDetector2.hangul?(' Hello, world!'))
  end

  def test_identify_script
    assert_equal(:Jpan, ScriptDetector2.identify_script(' 私のホバークラフトは鰻でいっぱいです.'))
    assert_equal(:Hans, ScriptDetector2.identify_script(' 我的气垫船充满了鳝鱼.'))
    assert_equal(:Hant, ScriptDetector2.identify_script(' 我的氣墊船充滿了鱔魚.'))
    assert_equal(:Kore, ScriptDetector2.identify_script(' 내 호버크라프트는 장어로 가득 차 있어요.'))
    assert_equal(:Kore, ScriptDetector2.identify_script('乫')) # Korean-only ideograph
    assert_equal(:Hani, ScriptDetector2.identify_script(' 你好'))
    assert_equal(:Zyyy, ScriptDetector2.identify_script(' Hello, world!'))
    assert_equal(:Hant, ScriptDetector2.identify_script('123,456日元(含稅)'))
    assert_equal(:Hani, ScriptDetector2.identify_script('猫'))
    assert_equal(:Hani, ScriptDetector2.identify_script('椩')) # Not in kUnihanCore2020
  end

  def test_identify_scripts
    assert_equal([:Jpan], ScriptDetector2.identify_scripts(' 私のホバークラフトは鰻でいっぱいです.'))
    assert_equal([:Hans], ScriptDetector2.identify_scripts(' 我的气垫船充满了鳝鱼.'))
    assert_equal([:Hant], ScriptDetector2.identify_scripts(' 我的氣墊船充滿了鱔魚.'))
    assert_equal([:Kore], ScriptDetector2.identify_scripts(' 내 호버크라프트는 장어로 가득 차 있어요.'))
    assert_equal([:Kore], ScriptDetector2.identify_scripts('乫')) # Korean-only ideograph
    assert_equal(%i[Hans Hant], ScriptDetector2.identify_scripts(' 你好'))
    assert_equal([:Zyyy], ScriptDetector2.identify_scripts(' Hello, world!'))
    assert_equal(%i[Hant Kore], ScriptDetector2.identify_scripts('123,456日元(含稅)'))
    assert_equal(%i[Hans Jpan Kore], ScriptDetector2.identify_scripts('猫'))
    assert_equal([:Hani], ScriptDetector2.identify_scripts('椩')) # Not in kUnihanCore2020
  end
end
