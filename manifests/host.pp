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

include advanced_configuration_and_power_interface_daemon
include antivirus
include automated_certificate_management_environment_client
include battery_indicator
include bitmap_image_editor
include bittorrent_client
include browser
include cad_editor
include calculator
include process_container
include desktop_management_interface_table_decoder
include development_tools
include diagram_editor
include dvcs
include dvcs_gui
include email_reader
include file_copier
include file_manager
include file_recovery_utility
include file_renamer
include file_transfer_protocol_client_gui
include firewall
include fonts
include general_development_tools
include graph_editor
include hardware_drivers
include image_viewer
include image_viewer_cli
include integrated_development_environment
include json_processor
include keyboard_layout
include keyring_daemon
include locale
include media_player
include network_analyzer
include network_manager
include ntpd
include office_suite
include onion_router
include open_document_text_to_plain_text_converter
include openpgp_tools
include packet_analyzer
include panorama_editor
include password_manager
include pdf_editor
include pdf_reader
include photo_editor
include photo_metadata_editor
include printing_system
include random_access_file_generator
include scanner
include screen_backlight_adjuster
include screen_grabber
include screen_locker
include shell
include shell_code_checker
include sound_system
include spell_checker
include ssh_client
include ssh_filesystem_client
include ssh_server
include storage_hardware_monitor
include terminal
include text_editor
include users
include userspace_virtual_filesystem
include vcard_validator
include vector_image_editor
include video_downloader
include virtual_machine_manager
include web_downloader
include web_video_streamer
include window_manager
include x_server_input_configuration_utility
include x_server_modifier_map_utility
include x_server_resource_configuration
include x_server_resource_database_utility
include x_server_resource_killer
include x_server_video_driver
