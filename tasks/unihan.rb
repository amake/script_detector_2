# frozen_string_literal: true

# Utilities for manipulating Unihan data
module Unihan
  CODEPOINT_PATTERN = /U\+(?<hex>[A-F0-9]+)/.freeze

  class << self
    # @param dict_data [Hash<Integer,Hash{String => String}>]
    # @param tags [Array<String>]
    # @return [Regexp]
    def gen_unihan_core_pattern(dict_data, *tags)
      gen_pattern(codepoints_for_tags(dict_data, tags))
    end

    # @param dict_data [Hash<Integer,Hash{String => String}>]
    # @param tags [Array<String>]
    # @return [Array<Integer>]
    def codepoints_for_tags(dict_data, tags)
      dict_data.select do |_, data|
        tags.all? { |t| data['kUnihanCore2020']&.include?(t) }
      end.keys
    end

    # @param codepoints [Array<Integer>]
    # @return [Regexp]
    def gen_pattern(codepoints)
      alts = group(codepoints).map do |first, last|
        if first == last
          format('\u{%x}', first)
        elsif first.succ == last
          format('\u{%<first>x}\u{%<last>x}', first: first, last: last)
        else
          format('\u{%<first>x}-\u{%<last>x}', first: first, last: last)
        end
      end
      /\A[#{alts.join}]+\Z/
    end

    # @param codepoints [Array<Integer>]
    # @return [Array<Array(Integer,Integer)>]
    def group(codepoints)
      groups = [[codepoints.first, codepoints.first]]

      codepoints.drop(1).each do |cp|
        group = groups.last
        if group.last == cp - 1
          group[-1] = cp
        else
          groups << [cp, cp]
        end
      end

      groups
    end

    # @param data_file [String]
    # @return [Hash<Integer,Hash{String => String}>]
    def parse_file(data_file)
      result = {}

      File.open(data_file) do |f|
        f.each_line do |line|
          next if line.start_with?('#')
          next if line.empty?

          codepoint, field, data = line.chomp.split("\t")

          cp_int = CODEPOINT_PATTERN.match(codepoint) do |m|
            Integer(m['hex'], 16)
          end

          hash = result[cp_int] ||= {}
          hash[field] = data
        end
      end

      result
    end
  end
end
