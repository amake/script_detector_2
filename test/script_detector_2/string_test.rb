# frozen_string_literal: true

require 'test_helper'

module ScriptDetector2
  class StringUtilTest < Minitest::Test
    using StringUtil

    def test_japanese?
      assert(' 私のホバークラフトは鰻でいっぱいです.'.japanese?)
      refute(' 我的气垫船充满了鳝鱼.'.japanese?)
      refute(' 我的氣墊船充滿了鱔魚.'.japanese?)
      refute(' 내 호버크라프트는 장어로 가득 차 있어요.'.japanese?)
    end

    def test_chinese?
      refute(' 私のホバークラフトは鰻でいっぱいです.'.chinese?)
      assert(' 我的气垫船充满了鳝鱼.'.chinese?)
      assert(' 我的氣墊船充滿了鱔魚.'.chinese?)
      refute(' 내 호버크라프트는 장어로 가득 차 있어요.'.chinese?)
    end

    def test_simplified_chinese?
      refute(' 私のホバークラフトは鰻でいっぱいです.'.simplified_chinese?)
      assert(' 我的气垫船充满了鳝鱼.'.simplified_chinese?)
      refute(' 我的氣墊船充滿了鱔魚.'.simplified_chinese?)
      refute(' 내 호버크라프트는 장어로 가득 차 있어요.'.simplified_chinese?)
    end

    def test_traditional_chinese?
      refute(' 私のホバークラフトは鰻でいっぱいです.'.traditional_chinese?)
      refute(' 我的气垫船充满了鳝鱼.'.traditional_chinese?)
      assert(' 我的氣墊船充滿了鱔魚.'.traditional_chinese?)
      refute(' 내 호버크라프트는 장어로 가득 차 있어요.'.traditional_chinese?)
    end

    def test_korean?
      refute(' 私のホバークラフトは鰻でいっぱいです.'.korean?)
      refute(' 我的气垫船充满了鳝鱼.'.korean?)
      refute(' 我的氣墊船充滿了鱔魚.'.korean?)
      assert(' 내 호버크라프트는 장어로 가득 차 있어요.'.korean?)
    end
  end
end
