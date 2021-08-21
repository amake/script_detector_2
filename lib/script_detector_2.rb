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
      return true if string =~ /[\p{Hiragana}\p{Katakana}]/
      return false if string =~ /\p{Hangul}/

      kanji = string.scan(/\p{Han}/)
      return false unless kanji.any?

      kanji.all?(JAPANESE_PATTERN)
    end

    # @param string [String]
    # @return [Boolean]
    def chinese?(string)
      return false if string =~ /[\p{Hiragana}\p{Katakana}\p{Hangul}]/

      string =~ /\p{Han}/
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
      return true if string =~ /\p{Hangul}/
      return false if string =~ /[\p{Hiragana}\p{Katakana}]/

      hanja = string.scan(/\p{Han}/)
      return false unless hanja.any?

      hanja.all?(KOREAN_PATTERN)
    end

    # @param string [String]
    # @return [Symbol]
    def identify_script(string)
      if japanese?(string) then :Jpan
      elsif korean?(string) then :Kore
      elsif traditional_chinese?(string) then :Hant
      elsif simplified_chinese?(string) then :Hans
      elsif chinese?(string) then :Hani
      else :Zyyy
      end
    end
  end
end
