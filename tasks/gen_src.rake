# frozen_string_literal: true

TMP_DIR = 'tmp'
UNIHAN_ZIP = File.join(TMP_DIR, 'Unihan.zip')
UNIHAN_URL = 'https://www.unicode.org/Public/14.0.0/ucd/Unihan.zip'

directory TMP_DIR

file UNIHAN_ZIP => TMP_DIR do |t|
  require 'net/http'

  File.open(t.name, 'wb') do |out|
    out << Net::HTTP.get(URI(UNIHAN_URL))
  end
end

CLOBBER.include(UNIHAN_ZIP)

UNIHAN_DICT = File.join(TMP_DIR, 'Unihan_DictionaryLikeData.txt')

file UNIHAN_DICT => UNIHAN_ZIP do |t|
  extract_file(t.prerequisites.first, File.basename(t.name))
end

CLOBBER.include(UNIHAN_DICT)

# @param zip [String]
# @param entry_name [String]
def extract_file(zip, entry_name)
  require 'zip'

  Zip::File.open(zip) do |zf|
    entry = zf.get_entry(entry_name)
    out_path = File.join(File.dirname(zip), entry_name)
    entry.extract(out_path)
  end
end

PATTERNS_FILE = File.join('lib', 'script_detector_2', 'patterns.gen.rb')

file PATTERNS_FILE => [UNIHAN_DICT] do |t|
  require_relative 'unihan'

  dict_data = Unihan.parse_file(t.prerequisites.last)
  jpan_pattern = Unihan.gen_unihan_core_pattern(dict_data, 'J')
  hans_pattern = Unihan.gen_unihan_core_pattern(dict_data, 'G')
  hant_pattern = Unihan.gen_unihan_core_pattern(dict_data, 'H', 'M', 'T')
  kore_pattern = Unihan.gen_unihan_core_pattern(dict_data, 'K', 'P')

  File.open(t.name, 'w') do |out|
    out << <<~SRC
      # frozen_string_literal: true

      # This file is generated! Do not edit manually!

      module ScriptDetector2
        JAPANESE_PATTERN = Regexp.new('#{jpan_pattern}').freeze
        SIMPLIFIED_CHINESE_PATTERN = Regexp.new('#{hans_pattern}').freeze
        TRADITIONAL_CHINESE_PATTERN = Regexp.new('#{hant_pattern}').freeze
        KOREAN_PATTERN = Regexp.new('#{kore_pattern}').freeze
      end
    SRC
  end
end

CLEAN.include(PATTERNS_FILE)
