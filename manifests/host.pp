File {
  owner => root,
  group => 0,
  mode  => '0600',
}

if versioncmp($::puppetversion, '3.6.1') >= 0 {
  Package {
    allow_virtual => false,
  }
}

include advanced_configuration_and_power_interface_daemon
include android_tools
include antivirus
include automated_certificate_management_environment_client
include backup_client
include battery_indicator
include bitmap_image_editor
include bittorrent_client
include bluetooth
include browser
include cad_editor
include calculator
include desktop_management_interface_table_decoder
include desktop_publishing_platform
include development_tools
include diagram_editor
include dvcs
include dvcs_gui
include ebook_management_system
include email_reader
include extended_display_identification_data_tools
include file_copier
include file_locator
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
include instant_messaging_client
include integrated_development_environment
include job_scheduler
include json_processor
include keyboard_layout
include keyring_daemon
include lightweight_directory_access_protocol_client
include locale
include login_manager
include mail_transfer_agent
include media_player
include mind_mapper
include my_firewall
include network_analyzer
include network_manager
include nodejs
include nodejs_dependency_manager
include ntpd
include office_suite
include onion_router
include open_document_text_to_plain_text_converter
include openpgp_tools
include packet_analyzer
include panorama_editor
include partition_table_editor_gui
include password_manager
include pdf_editor
include pdf_reader
include perl_gnu_readline_library_interface
include photo_editor
include photo_metadata_editor
include plot_generator
include power_consumption_and_management_diagnosis_tool
include printing_system
include process_container
include random_access_file_generator
include root_privilege_simulator
include rust
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
include steam
include storage_hardware_monitor
include terminal
include text_editor
include text_searcher
include users
include userspace_virtual_filesystem
include vcard_validator
include vector_image_editor
include video_downloader
include virtual_machine_manager
include virtual_private_network_client
include web_downloader
include web_distributed_authoring_and_versioning_file_system_driver
include web_video_streamer
include window_manager
include x_server_automation_tool
include x_server_clipboard_cli
include x_server_compositor
include x_server_input_configuration_utility
include x_server_modifier_map_utility
include x_server_property_displayer
include x_server_resource_configuration
include x_server_resource_database_utility
include x_server_resource_killer
include x_server_video_driver
include x_server_window_information_utility

resources { 'firewall':
  purge => true,
}

Firewall {
  before  => Class['my_firewall::post'],
  require => Class['my_firewall::pre'],
}
