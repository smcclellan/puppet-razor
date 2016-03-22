# Custom Type: Razor - Repository

Puppet::Type.newtype(:razor_repo) do
  @doc = "Razor Repository"

  ensurable

  newparam(:name, :namevar => true) do
    desc "The repository name"    
  end

  newproperty(:iso_url) do
    desc "The URL of the ISO to download and extract"
  end

  newproperty(:url) do
    desc "The URL of a mirror (no downloads)"
  end

  newproperty(:no_content) do
    desc "Keep the repo directory empty"

    def insync?(is)
      true
    end
  end

  newproperty(:task) do
    desc "The default task to perform to install the OS"        
  end
   
  validate do

    count = (!self[:iso_url].nil?    ? 1 : 0) +
            (!self[:url].nil?        ? 1 : 0) +
            (!self[:no_content].nil? ? 1 : 0)
    if count == 0
      raise(ArgumentError,"razor_repo must define iso_url (download), url (link), or no_content (none)")
    end

    if count > 1
      raise(ArgumentError,"razor_repo can only define one of iso_url (download), url (link), and no_content (none)")
    end
  end

  # This is not support by Puppet (<= 3.7)...
#   autorequire(:class) do
#     'razor'
#   end
end
