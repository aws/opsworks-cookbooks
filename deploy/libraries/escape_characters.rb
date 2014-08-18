module OpsWorks
  module Escape

    def self.escape(env, pattern, sub)
      Hash[env.map{|key, value| [key, value.nil? ? value : value.gsub(pattern, sub)]}]
    end

    def self.escape_double_quotes(env)
      escape(env, /\"/, "\\\"")
    end

    def self.escape_xml(env)
      escape(env, /[&"'<>]/, {"&" => "&amp;", "\"" => "&quot;", "'" => "&apos;", "<" => "&lt;", ">" => "&gt;"})
    end

  end
end
