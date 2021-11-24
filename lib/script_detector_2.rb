# frozen_string_literal: true

require_relative 'script_detector_2/version'
require_relative 'script_detector_2/patterns.gen'
require_relative 'script_detector_2/string'

# Detect the CJK script of a string
module ScriptDetector2
  class << self
    # @param string [String]
    # @return [Boolean] true if +string+ appears to be Japanese
    def japanese?(string)
      return true if kana?(string)
      return false if hangul?(string)

      kanji = string.scan(/\p{Han}/)
      return false unless kanji.any?

      kanji.all?(JAPANESE_PATTERN)
    end

    # @param string [String]
    # @return [Boolean] true if +string+ contains Hiragana or Katakana
    def kana?(string)
      /[\p{Hiragana}\p{Katakana}]/.match?(string)
    end

    # @param string [String]
    # @return [Boolean] true if +string+ appears to be Chinese (either
    #   Simplified or Traditional)
    def chinese?(string)
      return false if string =~ /[\p{Hiragana}\p{Katakana}\p{Hangul}]/

      /\p{Han}/.match?(string)
    end

    # @param string [String]
    # @return [Boolean] true if +string+ appears to be Simplified Chinese
    def simplified_chinese?(string)
      return false if string =~ /[\p{Hiragana}\p{Katakana}\p{Hangul}]/

      hanzi = string.scan(/\p{Han}/)
      return false unless hanzi.any?

      hanzi.all?(SIMPLIFIED_CHINESE_PATTERN)
    end

    # @param string [String]
    # @return [Boolean] true if +string+ appears to be Traditional Chinese
    def traditional_chinese?(string)
      return false if string =~ /[\p{Hiragana}\p{Katakana}\p{Hangul}]/

      hanzi = string.scan(/\p{Han}/)
      return false unless hanzi.any?

      hanzi.all?(TRADITIONAL_CHINESE_PATTERN)
    end

    # @param string [String]
    # @return [Boolean] true if +string+ appears to be Korean
    def korean?(string)
      return true if hangul?(string)
      return false if kana?(string)

      hanja = string.scan(/\p{Han}/)
      return false unless hanja.any?

      hanja.all?(KOREAN_PATTERN)
    end

    # @param string [String]
    # @return [Boolean] true if +string+ contains Hangul
    def hangul?(string)
      /\p{Hangul}/.match?(string)
    end

    # Make a best-effort attempt to guess the singular script of +string+.
    # Result is a symbol representing one of the scripts defined by ISO 15924,
    # namely one of:
    # - Hans (Simplified Chinese)
    # - Hant (Traditional Chinese)
    # - Hani (Unspecified Han)
    # - Jpan (Japanese: Han, Hiragana, Katakana)
    # - Kore (Korean: Hangul, Han)
    # - Zyyy (Undetermined)
    #
    # Note that this is likely to give poor results for very short strings,
    # which are often inherently ambiguous.
    #
    # @param string [String]
    # @return [Symbol]
    def identify_script(string)
      return :Jpan if kana?(string)
      return :Kore if hangul?(string)

      is_hant = traditional_chinese?(string)
      is_hans = simplified_chinese?(string)
      return :Hani if is_hant && is_hans

      is_japanese = japanese?(string)
      return :Hani if is_japanese && (is_hant || is_hans)

      # At this point we have determined that the string does not contain
      # Hangul; for such a string to be Korean would be unusual. Allowing Korean
      # to dilute the result to Hani is going to be a loss on average, so we
      # don't handle it like Japanese above.

      if is_hans then :Hans
      elsif is_hant then :Hant
      elsif is_japanese then :Jpan
      elsif korean?(string) then :Kore
      elsif chinese?(string) then :Hani
      else
        :Zyyy
      end
    end

    # Identify all CJK scripts represented in +string+. Result is a list of symbols
    # representing scripts defined by ISO 15924, namely one or more of:
    # - Hans (Simplified Chinese)
    # - Hant (Traditional Chinese)
    # - Hani (Unspecified Chinese)
    # - Jpan (Japanese: Han, Hiragana, Katakana)
    # - Kore (Korean: Hangul, Han)
    # - Zyyy (Undetermined)
    #
    # This method does not attempt to identify other scripts such as Latn.
    #
    # @param string [String]
    # @return [Array<Symbol>]
    def identify_scripts(string)
      result = []

      result << :Hans if simplified_chinese?(string)
      result << :Hant if traditional_chinese?(string)
      result << :Jpan if japanese?(string)
      result << :Kore if korean?(string)
      result << :Zyyy if result.empty?

      result
    end
  end
end
