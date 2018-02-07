class power_consumption_and_management_diagnosis_tool {
  include shell

  package { 'powertop':
    ensure => installed,
  }
}
