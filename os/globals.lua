grid = {}

canvas = {}

systemApps = {}
userApps = {}

ticks = 0

state = {}
--state.activePEN = 0
--state.currentPEN = 0
state.active = 0
state.pid = 0
state.selectType = 1
state.selectNum = 1

apps = {}

appList = {}

gra = require("os.lib.gra")
app = require("os.lib.app")
lgc = require("os.lib.lgc")
api = require("packages.api")
utf8 = require("utf8")