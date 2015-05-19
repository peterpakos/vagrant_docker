# Disable deprecation warning
Package { allow_virtual => false }

#include mail_server

# Master node definition
node /.*1$/ {

}

# Slave nodes definition
node default {

  #contain common
  #contain mysql
  #contain mysql::proxy
  #contain git_multisite

  #Class['common']        ->
  #Class['mysql']         ->
  #Class['mysql::proxy']  ->
  #Class['git_multisite']
}
