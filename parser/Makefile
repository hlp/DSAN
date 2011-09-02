
VALAC = valac

PARSER_SOURCES = expression.vala parser.vala program.vala scanner.vala util.vala

PACKAGES = --pkg gedit-2.20 --pkg gee-1.0 --pkg gtk+-2.0 --pkg libvala-0.12 --pkg vte

PACKAGE_VERSIONS = \
    gedit-2.20 >= 2.24.0 \
    gee-1.0 >= 0.1.3 \
    gtk+-2.0 >= 2.14.4 \
    libvala-0.12 >= 0.11.0 \
    vte >= 0.17.4

all: parser

parser: $(PARSER_SOURCES)
	@ pkg-config --print-errors --exists '$(PACKAGE_VERSIONS)'
	$(VALAC) $(VFLAGS) $(PACKAGES) $(PARSER_SOURCES) -o $@

clean:
	rm -f $(SOURCES:.vala=.c) $(SOURCES:.vala=.h) *.so
	rm -f parser

