module AutoFs
  def self.config(node)
    node.value_for_platform_family({
      "rhel" => "/etc/sysconfig/autofs",
      "debian" => "/etc/default/autofs"
    })
  end
end
