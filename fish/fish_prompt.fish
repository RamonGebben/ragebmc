function fish_prompt
  echo

  echo -n $USER

  set_color normal
  echo -n "@"

  set_color cyan
  echo -n (hostname)

  set_color normal
  echo -n ":"

  set_color green
  echo -n $PWD

  set_color -b normal 444
  echo -n "     "
  echo -n  (date +%H:%M) " "
  set_color -b normal 222
  echo -n (date +%b ) " " (date +%d)

  echo ""

  set_color -b normal yellow
  echo -n '>>  '
  set_color normal

end
