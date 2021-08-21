# frozen_string_literal: true

module ScriptDetector2
  # A String refinement for replicating the API of the original script_detector
  # gem
  module StringUtil
    refine String do
      def japanese?
        ScriptDetector2.japanese?(self)
      end

      def chinese?
        ScriptDetector2.chinese?(self)
      end

      def simplified_chinese?
        ScriptDetector2.simplified_chinese?(self)
      end

      def traditional_chinese?
        ScriptDetector2.traditional_chinese?(self)
      end

      def korean?
        ScriptDetector2.korean?(self)
      end
    end
  end
end
