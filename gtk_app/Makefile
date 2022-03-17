CC ?= gcc
PKGCONFIG = $(shell which pkg-config)
CFLAGS = $(shell $(PKGCONFIG) --cflags gtk+-3.0)
LDFLAGS = $(shell $(PKGCONFIG) --libs gtk+-3.0)

SRC = main.c
OBJS = $(SRC:.c=.o)

all: gtk_app

%.o: %.c
	$(CC) -c -o $(@F) $(CFLAGS) $<

gtk_app: $(OBJS)
	$(CC) -o $(@F) $(OBJS) $(LDFLAGS)

clean:
	rm -f $(OBJS)
	rm -f gtk_app
