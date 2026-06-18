* Get the Gtk menu data:

```
gdbus call --session   --dest upower.indicator \
  --object-path /upower/indicator/phone  \
  --method org.gtk.Menus.Start   "[0,1]"

```

* Monitor all changes:

```
 gdbus monitor --session   --dest upower.indicator \
   --object-path /upower/indicator/phone

```
