class Object
#
# because since release 0.10.0 extlib is not used anymore and we assume 
# a lot of customers use this method. This implementation will be removed soon
  unless new.respond_to?(:blank?)
    def blank?
      Chef::Log.info "#"*80
      Chef::Log.info "#"
      Chef::Log.info "# Your recipe is using \'.blank?\' which is deprecated. "
      Chef::Log.info "# The method \'.blank?\' will be removed soon, please use \'.empty?\' and/or \'.nil?\'"
      Chef::Log.info "# You can implement this method by your self using chef's libraries."
      Chef::Log.info "#"
      Chef::Log.info "#"*80
      nil? || (respond_to?(:empty?) && empty?)
    end
  end
end
