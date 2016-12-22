function console::user::token (
  String $name,
) {
  include ::console
  if find_file("${::console::token_dir}/${name}") {
    notice "found file, reading"
    file("${::console::token_dir}/${name}")
  } else {
    notice "Didnt find file @ ${::console::token_dir}/${name}"
    ''
  }
}
