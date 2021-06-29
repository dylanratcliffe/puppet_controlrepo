function deferred_epp::eval(
  String $template,
  Hash   $options,
) {
  # First thing that we would need to do would be to find all possible locations
  # that the module could be. This includes:
  #
  # - basemodulepath
  # - environmentpath
  $module_locations = [
    $settings::basemodulepath,
    $settings::modulepath,
  ]

  # Read the template from the Puppetserver and store it in a variable so that it can be passed in the catalog
  # $template_contents = file("")

  $module_locations.each |$path| {
    notify { $path: }
  }
}
