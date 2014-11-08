Facter.add(:has_battery) do
  setcode do
    Dir.glob('/sys/class/power_supply/*/type').any? do |filename|
      File.readlines(filename).any? do |line|
        line.include?('Battery')
      end
    end
  end
end
