font = {
        "medium": "9pt DejaVu Sans",
        "big": "10pt DejaVu Sans",
        "bold": "bold 10pt DejaVu Sans"
        }

c.fonts.tabs                    = font["big"]
c.fonts.completion.category     = font["medium"]
c.fonts.completion.entry        = font["medium"]
c.fonts.downloads               = font["medium"]
c.fonts.hints                   = "9pt Monaco"
c.fonts.keyhint                 = font["medium"]
c.fonts.messages.error          = font["medium"]
c.fonts.messages.info           = font["medium"]
c.fonts.messages.warning        = font["medium"]
c.fonts.prompts                 = font["medium"]
c.fonts.statusbar               = font["medium"]

c.tabs.indicator_padding        = {"top": 2, "right": 10, "bottom": 2, "left": 5}
c.tabs.padding                  = {"top": 8, "right": 8, "bottom": 8, "left": 8}
c.tabs.position                 = "right"
c.tabs.title.format             = "{title}"
c.tabs.width.bar                = "15%"
c.tabs.width.indicator          = 7
c.tabs.background               = True
c.tabs.mousewheel_switching     = False

c.completion.height             = "30%"
c.completion.shrink             = True

c.statusbar.padding             = {"top": 3, "right": 3, "bottom": 3, "left": 3}

c.content.headers.user_agent    = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36"
c.content.ssl_strict            = False
c.content.pdfjs                 = True

c.zoom.default                  = "150%"

c.hints.border                  = "2px solid #E3BE23"
c.hints.chars                   = "asdfghjklqwertyuiop"

c.input.partial_timeout         = 1000

c.url.searchengines             = {"DEFAULT": "https://encrypted.google.com/search?q={}"}

c.auto_save.session             = True

c.downloads.position            = "bottom"
c.downloads.remove_finished     = 500
c.downloads.location.directory  = "/home/oskar/downloads/"

c.editor.command                = ["urxvt", "-title", "qutebrowser", "-e",
                                   "vim", "-c", "startinsert", "{}"]

config.bind('gk', 'tab-move -')
config.bind('gj', 'tab-move +')

config.bind('x', 'hint links spawn mpv-youtube {hint-url}')
config.bind('X', 'spawn mpv-youtube {url}')
config.bind('c', 'hint links spawn streamTV {hint-url}')
config.bind('C', 'spawn streamTV {url}')

config.bind('pf', 'spawn --userscript /usr/share/qutebrowser/userscripts/password_fill ;; hint')

