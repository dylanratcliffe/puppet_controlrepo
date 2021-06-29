function deferred_epp (
  String $template,
  Hash   $options,
) {
  # First thing that we would need to do would be to find all possible locations
  # that the module could be. This includes:
  #
  # - basemodulepath
  # - environmentpath
  $module_locations = [
    $settings::basemodulepath.split(':'),
    $settings::modulepath.split(':'),
  ].flatten.unique

  # Get the individual name components so that we can construct the full paths
  # where we might find the file
  $module_name = $template.split('/')[0]
  $template_name = $template.split('/')[1,-1].join('')

  notify { "module_name: ${module_name}": }
  notify { "template_name: ${template_name}": }

  # Convert all into fully qualified paths, addin in /templates/ since this is
  # usually implied
  $all_locations = $module_locations.map |$location| {
    "${location}/${module_name}/templates/${template_name}"
  }

  # Read the template from the Puppetserver and store it in a variable so that
  # it can be passed in the catalog. All possible file locations will be read in
  # order until something is found
  $template_contents = file(*$all_locations)

  # Deferred('inline_epp', [ $template, $options ])

}
