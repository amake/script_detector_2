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
  end

  def test_chinese?
    refute(ScriptDetector2.chinese?(' 私のホバークラフトは鰻でいっぱいです.'))
    assert(ScriptDetector2.chinese?(' 我的气垫船充满了鳝鱼.'))
    assert(ScriptDetector2.chinese?(' 我的氣墊船充滿了鱔魚.'))
    refute(ScriptDetector2.chinese?(' 내 호버크라프트는 장어로 가득 차 있어요.'))
  end

  def test_simplified_chinese?
    refute(ScriptDetector2.simplified_chinese?(' 私のホバークラフトは鰻でいっぱいです.'))
    assert(ScriptDetector2.simplified_chinese?(' 我的气垫船充满了鳝鱼.'))
    refute(ScriptDetector2.simplified_chinese?(' 我的氣墊船充滿了鱔魚.'))
    refute(ScriptDetector2.simplified_chinese?(' 내 호버크라프트는 장어로 가득 차 있어요.'))
  end

  def test_traditional_chinese?
    refute(ScriptDetector2.traditional_chinese?(' 私のホバークラフトは鰻でいっぱいです.'))
    refute(ScriptDetector2.traditional_chinese?(' 我的气垫船充满了鳝鱼.'))
    assert(ScriptDetector2.traditional_chinese?(' 我的氣墊船充滿了鱔魚.'))
    refute(ScriptDetector2.traditional_chinese?(' 내 호버크라프트는 장어로 가득 차 있어요.'))
  end

  def test_korean?
    refute(ScriptDetector2.korean?(' 私のホバークラフトは鰻でいっぱいです.'))
    refute(ScriptDetector2.korean?(' 我的气垫船充满了鳝鱼.'))
    refute(ScriptDetector2.korean?(' 我的氣墊船充滿了鱔魚.'))
    assert(ScriptDetector2.korean?(' 내 호버크라프트는 장어로 가득 차 있어요.'))
  end
end
