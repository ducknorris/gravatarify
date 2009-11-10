module Gravatarify  
  # Set of common utility methods to e.g. deep merge options etc.
  module Utils #:nodoc:        
    # Merge supplied list of +params+ with the globally defined default options and
    # any params. Then merge remaining params as hash.
    def self.merge_gravatar_options(*params)
      return (params[1] || {}) if params.first == false
      options = Gravatarify.options.dup
      deep_merge_html!(options, Gravatarify.styles[params.shift] || {}) unless params.first.is_a?(Hash)
      deep_merge_html!(options, params.first) unless params.empty?
      options
    end
    
    # Deeply merge the <tt>:html</tt> attribute.
    def self.deep_merge_html!(hash, to_merge)
      html = (hash[:html] || {}).merge(to_merge[:html] || {})
      hash.merge!(to_merge)
      hash[:html] = html unless html.empty?
    end
  
    # Tries first to call +email+, then +mail+ then +to_s+ on supplied
    # object.
    def self.smart_email(obj)
      str = (obj.respond_to?(:email) ? obj.send(:email) : (obj.respond_to?(:mail) ? obj.send(:mail) : obj)).to_s
      str = str.sub(/\A.*?<(.+?)>.*\z/, '\1') if str =~ /<.+>/
      str.strip.downcase
    end
  end
end