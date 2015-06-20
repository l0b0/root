Puppet::Type.type(:package).provide(:pip2, :parent => :pip, :source => :pip) do
  def self.cmd
    'pip2'
  end
end
