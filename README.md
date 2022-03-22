# flutter_window_title_issue

https://github.com/canonical/ubuntu-desktop-installer/issues/670

## Normal run

```sh
# any of these
$ flutter run -d linux --debug
$ flutter run -d linux --release
$ ./build/linux/x64/debug/bundle/flutter_window_title_issue
$ ./build/linux/x64/release/bundle/flutter_window_title_issue
```
https://user-images.githubusercontent.com/140617/158589543-174d8210-c678-456e-8bef-5b9430ad794f.mp4

## Under stress (e.g. integration test, snap, stress tool)

```sh
$ flutter test integration_test/
```
https://user-images.githubusercontent.com/140617/158589560-5a2a36bb-5cb3-49e3-b9d8-ed57a660a159.mp4

## Notes

- makes no difference
  - release vs. debug
  - direct execute vs. flutter run
  - flutter snap vs. git
  - flutter stable vs. master
  - latest flutter engine
  - latest gtk 3.24.33
  - `LIBGL_ALWAYS_SOFTWARE=1`
  - `--enable-software-rendering`
- a successful layout: `gtk_header_bar_set_title()` -> `gtk_widget_queue_resize()` -> `gtk_header_bar_allocate_contents()`
  - when the title is cut, `gtk_header_bar_allocate_contents()` does not get called
- the issue is not reproducible with a minimal GTK test case (`GtkGLArea` + `GtkHeaderBar` in the `gtk_app/` subdir)
- deactivating the window triggers triggers a relayout that "fixes" the problem
- the issue is reproducible outside the live environment with the `ubuntu_desktop_installer` snap
- the issue is also reproducible if the method channel is replaced with direct GTK calls via FFI (`ffi-gtk` branch)
- the issue is not reproducible with a snap config copied and adapted from ubuntu_desktop_installer (`snap-udi` branch)
- the window title gets correctly updated if `fl_view_begin_frame()` and `fl_view_end_frame()` are commented out
  - is the issue caused by composited `FlGLArea` layers in `FlView`?
  - it was a large and intrusive change over a year ago: https://github.com/flutter/engine/pull/24011
  - this is obviously not a solution, because it breaks Flutter's rendering, but replacing the layered areas with a single `FlGLArea` does avoid the titlebar update problem: https://github.com/jpnurmi/engine/commit/4dec73c5b2d85cc9454ce3f9306b9e3c958ad314
- **UPDATE**: the issue is reproducible with Flutter apps (not with the pure GTK+ test case) by simply running `stress` in the background
- `gtk_header_set_title()` calls `gtk_widget_queue_resize()` while the window's "idle sizer" timer is running
