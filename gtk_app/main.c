#include <gtk/gtk.h>

static gint update_window_title(gpointer data) {
  GtkWidget *header_bar = gtk_window_get_titlebar(GTK_WINDOW(data));

  static gint i = -1;
  i = (i + 1) % 4;
  if (i == 0) {
    gtk_header_bar_set_title(GTK_HEADER_BAR(header_bar), "My App");
  } else {
    g_autofree gchar *title = g_strdup_printf("My App - document %d", i);
    gtk_header_bar_set_title(GTK_HEADER_BAR(header_bar), title);
  }
  return TRUE;
}

static void activate(GtkApplication *app, gpointer user_data) {
  GtkWidget *window;
  GtkWidget *header_bar;
  GtkWidget *gl_area;

  window = gtk_application_window_new(app);
  gtk_window_set_default_size(GTK_WINDOW(window), 600, 400);

  header_bar = gtk_header_bar_new();
  gtk_header_bar_set_title(GTK_HEADER_BAR(header_bar), "My App");
  gtk_header_bar_set_show_close_button(GTK_HEADER_BAR(header_bar), TRUE);
  gtk_window_set_titlebar(GTK_WINDOW(window), header_bar);

  gl_area = gtk_gl_area_new();
  gtk_container_add(GTK_CONTAINER(window), gl_area);

  gtk_widget_show_all(window);
  gtk_window_present(GTK_WINDOW(window));

  g_timeout_add(1000, update_window_title, window);
}

int main(int argc, char **argv) {
  GtkApplication *app;
  int status;

  app = gtk_application_new("org.gtk.gl-app", G_APPLICATION_FLAGS_NONE);
  g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
  status = g_application_run(G_APPLICATION(app), argc, argv);
  g_object_unref(app);

  return status;
}