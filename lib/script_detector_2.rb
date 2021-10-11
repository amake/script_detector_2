# frozen_string_literal: true

require_relative 'script_detector_2/version'
require_relative 'script_detector_2/patterns.gen'
require_relative 'script_detector_2/string'

# Detect the CJK script of a string
module ScriptDetector2
  class << self
    # @param string [String]
    # @return [Boolean]
    def japanese?(string)
      return true if kana?(string)
      return false if hangul?(string)

      kanji = string.scan(/\p{Han}/)
      return false unless kanji.any?

      kanji.all?(JAPANESE_PATTERN)
    end

    # @param string [String]
    # @return [Boolean]
    def kana?(string)
      /[\p{Hiragana}\p{Katakana}]/.match?(string)
    end

    # @param string [String]
    # @return [Boolean]
    def chinese?(string)
      return false if string =~ /[\p{Hiragana}\p{Katakana}\p{Hangul}]/

      /\p{Han}/.match?(string)
    end

    # @param string [String]
    # @return [Boolean]
    def simplified_chinese?(string)
      return false if string =~ /[\p{Hiragana}\p{Katakana}\p{Hangul}]/

      hanzi = string.scan(/\p{Han}/)
      return false unless hanzi.any?

      hanzi.all?(SIMPLIFIED_CHINESE_PATTERN)
    end

    # @param string [String]
    # @return [Boolean]
    def traditional_chinese?(string)
      return false if string =~ /[\p{Hiragana}\p{Katakana}\p{Hangul}]/

      hanzi = string.scan(/\p{Han}/)
      return false unless hanzi.any?

      hanzi.all?(TRADITIONAL_CHINESE_PATTERN)
    end

    # @param string [String]
    # @return [Boolean]
    def korean?(string)
      return true if hangul?(string)
      return false if kana?(string)

      hanja = string.scan(/\p{Han}/)
      return false unless hanja.any?

      hanja.all?(KOREAN_PATTERN)
    end

    # @param string [String]
    # @return [Boolean]
    def hangul?(string)
      /\p{Hangul}/.match?(string)
    end

    # @param string [String]
    # @return [Symbol]
    def identify_script(string)
      return :Jpan if japanese?(string)
      return :Kore if korean?(string)

      is_hant = traditional_chinese?(string)
      is_hans = simplified_chinese?(string)
      if is_hant && is_hans then :Hani
      elsif is_hans then :Hans
      elsif is_hant then :Hant
      elsif chinese?(string) then :Hani # rubocop:disable Lint/DuplicateBranch
      else :Zyyy
      end
    end
  end
end
