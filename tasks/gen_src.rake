# frozen_string_literal: true

TMP_DIR = 'tmp'
UNIHAN_ZIP = File.join(TMP_DIR, 'Unihan.zip')
UNIHAN_URL = 'https://www.unicode.org/Public/UCD/latest/ucd/Unihan.zip'

directory TMP_DIR

file UNIHAN_ZIP => TMP_DIR do |t|
  require 'net/http'

  File.open(t.name, 'wb') do |out|
    out << Net::HTTP.get(URI(UNIHAN_URL))
  end
end

CLOBBER.include(UNIHAN_ZIP)

UNIHAN_READINGS = File.join(TMP_DIR, 'Unihan_Readings.txt')

file UNIHAN_READINGS => UNIHAN_ZIP do |t|
  extract_file(t.prerequisites.first, File.basename(t.name))
end

CLOBBER.include(UNIHAN_READINGS)

UNIHAN_VARIANTS = File.join(TMP_DIR, 'Unihan_Variants.txt')

file UNIHAN_VARIANTS => UNIHAN_ZIP do |t|
  extract_file(t.prerequisites.first, File.basename(t.name))
end

CLOBBER.include(UNIHAN_VARIANTS)

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

file PATTERNS_FILE => [UNIHAN_READINGS, UNIHAN_VARIANTS] do |t|
  require_relative 'unihan'

  readings_data = Unihan.parse_file(t.prerequisites.first)
  ja_pattern = Unihan.gen_japanese_pattern(readings_data)

  File.open(t.name, 'w') do |out|
    out << <<~SRC
      # frozen_string_literal: true

      # This file is generated! Do not edit manually!

      module ScriptDetector2
        JAPANESE_PATTERN = Regexp.new('#{ja_pattern}').freeze
      end
    SRC
  end
end

CLEAN.include(PATTERNS_FILE)
