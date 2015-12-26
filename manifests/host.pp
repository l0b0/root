File {
  owner => root,
  group => 0,
  mode  => '0600',
}

if versioncmp($::puppetversion,'3.6.1') >= 0 {
  Package {
    allow_virtual => false,
  }
}

include battery_indicator
include bitmap_image_editor
include bittorrent_client
include browser
include cad_editor
include calculator
include process_container
include desktop_management_interface_table_decoder
include diagram_editor
include dvcs
include email_reader
include file_copier
include file_manager
include file_recovery_utility
include file_renamer
include file_transfer_protocol_client_gui
include firewall
include flash_plugin
include fonts
include general_development_tools
include graph_editor
include image_viewer
include image_viewer_cli
include integrated_development_environment
include json_processor
include locale
include media_player
include network_analyzer
include network_manager_gui
include ntpd
include office_suite
include onion_router
include openpgp_tools
include packet_analyzer
include panorama_editor
include password_manager
include pdf_editor
include pdf_reader
include photo_editor
include photo_metadata_editor
include printing_system
include scanner
include screen_backlight_adjuster
include screen_grabber
include screen_locker
include shell
include spell_checker
include sshd
include storage_hardware_monitor
include terminal
include text_editor
include users
include vcard_validator
include vector_image_editor
include video_downloader
include window_manager
