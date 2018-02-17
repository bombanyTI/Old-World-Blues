//#define TESTING
#if DM_VERSION < 506
#warn This compiler is out of date. You may experience issues with projectile animations.
#endif

// Items that ask to be called every cycle.
var/global/datum/datacore/data_core      = null
var/global/list/all_areas                = list()
var/global/list/machines                 = list()
var/global/list/processing_objects       = list()
var/global/list/processing_power_items   = list()
var/global/list/active_diseases          = list()
var/global/list/med_hud_users            = list() // List of all entities using a medical HUD.
var/global/list/sec_hud_users            = list() // List of all entities using a security HUD.
var/global/list/hud_icon_reference       = list()

var/list/init_atoms = list()
var/list/init_lights = list()

// Those networks can only be accessed by pre-existing terminals. AIs and new terminals can't use them.
var/list/restricted_camera_networks = list("thunder","ERT","NUKE","Secret")

var/global/list/global_mutations  = list() // List of hidden mutation things.
var/global/defer_powernet_rebuild = 0      // True if net rebuild will be called manually after an event.

var/global/datum/universal_state/universe = new

var/global/list/global_map = null

// Noises made when hit while typing.
var/list/hit_appends = list("-OOF", "-ACK", "-UGH", "-HRNK", "-HURGH", "-GLORF")

var/list/paper_tag_whitelist = list(
	"center",  "p",     "div",   "span", "pre", "h1", "h2", "h3",  "h4",  "h5", "h6", "br", "hr",
	"big",     "small", "font",  "i",    "u",   "b",  "s",  "sub", "sup", "tt", "ol", "ul", "li",
	"caption", "col",   "table", "td",   "th",  "tr"
)
var/list/paper_blacklist = list(
	"java",        "onblur",    "onchange",    "onclick",    "ondblclick",  "onselect", "onfocus",
	"onsubmit",    "onreset",   "onload",      "onunload",   "onkeydown",   "onkeyup",  "onkeypress",
	"onmousedown", "onmouseup", "onmousemove", "onmouseout", "onmouseover",
)

var/skipupdate = 0

var/eventchance = 10 // Percent chance per 5 minutes.
var/event       = 0
var/hadevent    = 0
var/blobevent   = 0

var/diary          = null
var/href_logfile   = null
var/station_name   = "NSS Exodus"
var/game_version   = "BlueBay"
var/changelog_hash = ""
var/game_year      = (text2num(time2text(world.realtime, "YYYY")) + 544)

var/going             = 1.0
var/master_mode       = "extended" // "extended"
var/secret_force_mode = "secret"   // if this is anything but "secret", the secret rotation will forceably choose this mode.

var/host = null
var/shuttle_frozen = 0
var/shuttle_left   = 0
var/shuttlecoming  = 0

var/list/bombers       = list()
var/list/lastsignalers = list() // Keeps last 100 signals here in format: "[src] used \ref[src] @ location [src.loc]: [freq]/[code]"
var/list/lawchanges    = list() // Stores who uploaded laws to which silicon-based lifeform, and what the law was.
var/list/reg_dna       = list()
//var/list/traitobj    = list()

// Multiplier for watts per tick <> cell storage
//(e.g., 0.02 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
// It's a conversion constant. power_used*CELLRATE = charge_provided, or charge_used/CELLRATE = power_provided
var/CELLRATE = 0.002


// Cap for how fast cells charge, as a percentage-per-tick (0.01 means cellcharge is capped to 1% per second)
var/CHARGELEVEL = 0.0005

var/list/wizardstart     = list()
var/list/newplayer_start = list()

//Spawnpoints.
var/list/latejoin         = list()
var/list/latejoin_gateway = list()
var/list/latejoin_cryo    = list()
var/list/latejoin_cyborg  = list()

var/list/prisonwarp         = list() // Prisoners go to these
var/list/holdingfacility    = list() // Captured people go here
var/list/xeno_spawn         = list() // Aliens spawn at at these.
//var/list/mazewarp         = list()
var/list/tdome1             = list()
var/list/tdome2             = list()
var/list/tdomeobserve       = list()
var/list/tdomeadmin         = list()
var/list/prisonsecuritywarp = list() // Prison security goes to these.
var/list/prisonwarped       = list() // List of players already warped.
var/list/blobstart          = list()
var/list/ninjastart         = list()
//var/list/traitors         = list() // Traitor list.

var/list/cardinal    = list(NORTH, SOUTH, EAST, WEST)
var/list/alldirs     = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
var/list/reverse_dir = list( // reverse_dir[dir] = reverse of dir
	 2,  1,  3,  8, 10,  9, 11,  4,  6,  5,  7, 12, 14, 13, 15, 32, 34, 33, 35, 40, 42,
	41, 43, 36, 38, 37, 39, 44, 46, 45, 47, 16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21,
	23, 28, 30, 29, 31, 48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63
)

var/datum/station_state/start_state = null
var/datum/configuration/config      = null

var/list/powernets = list()

var/Debug  = 0 // Global debug switch.
var/Debug2 = 0

var/wavesecret    = 0
var/gravity_is_on = 1

var/join_motd = null

var/list/awaydestinations = list() // Away missions. A list of landmarks that the warpgate can take you to.

// MySQL configuration
var/sqladdress = "localhost"
var/sqlport    = "3306"
var/sqldb      = "tgstation"
var/sqllogin   = "root"
var/sqlpass    = ""

// Feedback gathering sql connection
var/sqlfdbkdb    = "test"
var/sqlfdbklogin = "root"
var/sqlfdbkpass  = ""
var/sqllogging   = 0 // Should we log deaths, population stats, etc.?

// Forum MySQL configuration. (for use with forum account/key authentication)
// These are all default values that will load should the forumdbconfig.txt file fail to read for whatever reason.
var/forumsqladdress = "localhost"
var/forumsqlport    = "3306"
var/forumsqldb      = "tgstation"
var/forumsqllogin   = "root"
var/forumsqlpass    = ""
var/forum_activated_group     = "2"
var/forum_authenticated_group = "10"

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
var/fileaccess_timer = 0
var/custom_event_msg = null

// Database connections. A connection is established on world creation.
// Ideally, the connection dies when the server restarts (After feedback logging.).
var/DBConnection/dbcon     = new() // Feedback    database (New database)
var/DBConnection/dbcon_old = new() // /tg/station database (Old database) -- see the files in the SQL folder for information on what goes where.

// Reference list for disposal sort junctions. Filled up by sorting junction's New()
/var/list/tagger_locations = list()

// Chemistry lists.
var/list/tachycardics  = list("coffee", "inaprovaline", "hyperzine", "nitroglycerin", "thirteenloko", "nicotine") // Increase heart rate.
var/list/bradycardics  = list("neurotoxin", "cryoxadone", "clonexadone", "space_drugs", "stoxin")                 // Decrease heart rate.
var/list/heartstopper  = list("potassium_phorochloride", "zombie_powder") // This stops the heart.
var/list/cheartstopper = list("potassium_chloride")                       // This stops the heart when overdose is met. -- c = conditional

// Some scary sounds.
var/static/list/scarySounds = list(
	'sound/weapons/thudswoosh.ogg',
	'sound/weapons/Taser.ogg',
	'sound/weapons/armbomb.ogg',
	'sound/voice/hiss1.ogg',
	'sound/voice/hiss2.ogg',
	'sound/voice/hiss3.ogg',
	'sound/voice/hiss4.ogg',
	'sound/voice/hiss5.ogg',
	'sound/voice/hiss6.ogg',
	'sound/effects/Glassbr1.ogg',
	'sound/effects/Glassbr2.ogg',
	'sound/effects/Glassbr3.ogg',
	'sound/items/Welder.ogg',
	'sound/items/Welder2.ogg',
	'sound/machines/airlock.ogg',
	'sound/effects/clownstep1.ogg',
	'sound/effects/clownstep2.ogg'
)

// Bomb cap!
var/max_explosion_range = 14

// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it.
var/global/obj/item/device/radio/intercom/global_announcer = new(null)

var/list/station_departments = list("Command", "Medical", "Engineering", "Science", "Security", "Cargo", "Civilian")

var/global/const/TICKS_IN_DAY = 864000
var/global/const/TICKS_IN_SECOND = 10
