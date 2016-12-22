function console::user::token (
  String $name,
) {
  include ::console
  if find_file("${::console::token_dir}/${name}") {
    notice regsubst(file("${::console::token_dir}/${name}"),/\n$/,'')
    regsubst(file("${::console::token_dir}/${name}"),/\n$/,'')
  } else {
    undef
  }
}
