function console::user::token (
  String $name,
) {
  include ::console
  if find_file("${::console::token_dir}/${name}") {
    file("${::console::token_dir}/${name}")
  } else {
    undef
  }
}
