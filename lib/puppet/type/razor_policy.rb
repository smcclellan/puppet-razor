# Custom Type: Razor - Policy

Puppet::Type.newtype(:razor_policy) do
  @doc = "Razor Policy"

  ensurable

  newparam(:name, :namevar => true) do
    desc "The policy name"    
  end

  newproperty(:repo) do
    desc "The repository to install from"      
  end

  newproperty(:task) do
    desc "The task to use to install the repo"      
  end

  newproperty(:broker) do
    desc "The broker to use after installation"      
  end

  newproperty(:hostname) do
    desc "The hostname to set up (use ${id} inside)"      
  end

  newproperty(:root_password) do
    desc "The root password to install with"      
  end

  newproperty(:no_max_count) do
    desc "Allow unlimited nodes to bind to the policy"
  end

  newproperty(:max_count) do
    desc "The maximum number of nodes for the policy (set nil or use no_max_count for unlimited)"
    
    newvalues(/^\d+$/)
  end

  newproperty(:before_policy) do
    desc "The policy before this one"
    
    def insync?(is)
      true
    end
  end

  newproperty(:after_policy) do
    desc "The policy after this one"
        
    def insync?(is)
      true
    end
  end

  newproperty(:node_metadata) do
    desc "The node metadata [Hash]"      
  end

  newproperty(:tags, :array_matching => :all) do
    desc "The tags to look for [Array]"      
  end

  newproperty(:enabled) do
    desc "Policies can be enabled or disabled"
    
    newvalues(:true, :false)
    defaultto(:true)
  end

  autorequire(:razor_broker) do
    self[:broker]
  end

  autorequire(:razor_repo) do
    self[:repo]
  end

  autorequire(:razor_tag) do
    self[:tags]
  end  

  # This is not support by Puppet (<= 3.7)...
#  autorequire(:class) do
#    'razor'
#  end

  validate do    
    if self[:before_policy] != nil and self[:after_policy] != nil  then
      raise(ArgumentError,"razor_policy can not define both before_policy and after_polciy.")
    end

    if self[:max_count] != nil and self[:no_max_count] != nil
      raise(ArgumentError,"razor_policy cannot define both max_count and no_max_count")
    end
  end
end