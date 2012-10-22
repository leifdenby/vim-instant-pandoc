#!/usr/bin/env python2
 
import gtk
import webkit
 
window = gtk.Window()

view = webkit.WebView()
view.set_full_content_zoom(True)
view.open('http://localhost:8080/')

window.add(view)
window.show_all()

def destroy_cb(a, b):
  window.destroy()
  gtk.main_quit()

window.connect('delete-event',  lambda window, event: gtk.main_quit())
view.connect('close-web-view', lambda: gtk.main_quit())
 
gtk.main()
