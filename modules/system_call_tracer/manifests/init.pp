class system_call_tracer {
  include shell

  package { 'strace':
    ensure => installed,
  }
}
