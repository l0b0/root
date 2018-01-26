class filesystem_event_monitor {
  sysctl { 'fs.inotify.max_user_watches': value => '524288' }
}
