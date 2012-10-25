function! PandocUpdate()
python << EOF
import vim

def get_free_port():
  # inspired by: http://stackoverflow.com/questions/1365265/on-localhost-how-to-pick-a-free-port-number
  import socket
  socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  socket.bind(('', 0))
  server_port = socket.getsockname()[1]
  socket.close()
  return server_port

def get_vim_var(var_name):
  if vim.eval('exists("%s")' % var_name) == "1":
    return vim.eval("%s" % var_name)
  else:
    return None

def spawn_server(port):
  import os, sys
  os.environ['INSTANT_PANDOC_SERVER_PORT'] = "%d" % port
  for setting in ["instant_pandoc_bibliography_path","instant_pandoc_csl_path","instant_pandoc_bin_path"]:
    setting_value = get_vim_var("g:%s" % setting)
    if setting_value is not None:
      if not os.path.exists(setting_value):
        raise Exception("File given in setting %s does not exist (%s)" % (setting, setting_value))
      else:
        os.environ[setting.upper()] = setting_value
  from subprocess import call
  home_path = os.environ["HOME"]
  # add more paths here if you have installed the vim-plugin somewhere different
  plugin_paths = [
                    os.path.join(home_path,".vim","bundle","vim-instant-pandoc"),
                    ]
  spawn_success = False
  nw_path = get_vim_var("g:instant_pandoc_nw_bin_path")
  if nw_path is None:
    if sys.platform == "darwin":
      nw_path = "node-webkit"
    elif "linux" in sys.platform:
      nw_path = "nw"


  for p in plugin_paths:
    app_path = os.path.join(p, "nw-app")
    try:
      if os.path.exists(app_path):
        if sys.platform == "darwin":
          call(["open","-a", nw_path, app_path])
        elif "linux" in sys.platform:
          call([nw_path, app_path])
        spawn_success = True
    except:
      pass
  if not spawn_success:
    raise Exception("Sorry, couldn't find where the vim-instant-pandoc plugin is installed, please add the path manually to the plugin")


def port_is_free(port_number):
  import socket
  try:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(('', port_number))
    s.close()
    return True
  except:
    return False


def get_document_content():
  (row, col) = vim.current.window.cursor
  previous_cursor_line = get_vim_var("b:last_cursor_line")

  if col != previous_cursor_line:
    buffer_copy = []
    for i, line in enumerate(vim.current.buffer):
      if i == row-1:
        if line == "":
          buffer_copy.append("")
        buffer_copy.append(line + 'cc_cursor_rr')
        if line == "":
          buffer_copy.append("")
      else:
        buffer_copy.append(line)
    buffer_copy.append("")
    buffer_copy.append("")
    buffer_copy.append(".")
    current_buffer = buffer_copy
    vim.command("let b:last_cursor_line=%d" % row)
    return '\n'.join(current_buffer)

doc_original = get_document_content()
try:
  server_port = int(get_vim_var("b:instant_pandoc_server_port"))
except TypeError:
  server_port = get_free_port()
  vim.command("let b:instant_pandoc_server_port=%d" % server_port)

import httplib
from time import sleep

output_received = False
attempt_counter = 0
while not output_received:
  try:
    conn = httplib.HTTPConnection("localhost", server_port)
    conn.request("PUT", "/", doc_original)
    conn.close()
    output_received = True
  except:
    attempt_counter += 1
    if attempt_counter > 10:
      break
    if port_is_free(server_port):
      spawn_server(server_port)
    else:
      # we hope that the daemon is iniating, so we just sleep for a bit and try again
      sleep(0.1)
EOF

endfunction

function! PandocEnd()
python << EOF
import vim, base64
if vim.eval('exists("b:instant_pandoc_server_port")') == "1":
  server_port = vim.eval("b:instant_pandoc_server_port")
  import httplib
  conn = httplib.HTTPConnection("localhost", server_port)
  conn.request("DELETE","/")
  conn.close()
EOF
endfunction

au BufWinEnter *.{markdown,md,mkd,pd,pdk,pandoc,text} silent call PandocUpdate()
au BufWinLeave *.{markdown,md,mkd,pd,pdk,pandoc,text} silent call PandocEnd()
au BufWrite,CursorHold,CursorHoldI *.{markdown,md,mkd,pd,pdk,pandoc,text} silent call PandocUpdate()
if exists("g:instant_pandoc_update_rate")
  execute "set updatetime=".g:instant_pandoc_update_rate
else
  set updatetime=100
endif
