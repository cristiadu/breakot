extends CanvasLayer

signal level_won
signal level_lost

const SAVE_FILE = "user://breakot.save"
const INITIAL_TEXT = "Press ENTER to start."
const NEW_HIGHSCORE_MESSAGE = "NEW HIGHSCORE!!!"
const HEART_NODE_PATH = "Lives/Heart{}/AnimatedSprite2D"
const BLOCK_GROUP = "block"
const UNBREAKABLE_BLOCK_GROUP = "unbreakable_block"
const EMPTY_ANIMATION = "empty"
const FULL_ANIMATION = "full"

var new_highscore = false
var current_points = 0 setget set_current_points
var highscore = 0 setget set_highscore
var initial_lives = 3
var lives = initial_lives setget set_lives
var active_blocks_count : int setget on_blocks_count_setter

onready var title_background = $TitleBackground
onready var title_background_sound = $TitleBackgroundSound
onready var info_message = $InfoMessage
onready var hide_message_timer = $HideHUDMessageTimer
onready var current_score_label = $CurrentScore
onready var highscore_label = $Highscore

func _ready():
    connect_signals()
    load_highscore_if_exists()
    show_message(INITIAL_TEXT, false)

func connect_signals():
    connect_signal_or_print_error(self.tree_exiting, on_HUD_destroy)
    connect_signal_or_print_error(hide_message_timer.timeout, on_timeout_hide_message)

func connect_signal_or_print_error(signal, method):
    var err = signal.connect(method)
    if err:
        print("Error when linking HUD delete behavior")

func load_highscore_if_exists():
    if FileAccess.file_exists(SAVE_FILE):
        load_highscore()
    else:
        save_highscore()

func _process(_delta):
    if title_background.visible and not title_background_sound.playing:
        title_background_sound.play()

func on_HUD_destroy():
    if new_highscore:
        save_highscore()

func life_lost():
    get_node(HEART_NODE_PATH.format(str(lives))).animation = EMPTY_ANIMATION
    self.lives -= 1

func on_blocks_count_setter(new_count):
    active_blocks_count = new_count
    if active_blocks_count == 0:
        level_won.emit()

func reset():
    reset_lives_and_blocks()
    reset_hearts()

func reset_lives_and_blocks():
    self.lives = initial_lives
    new_highscore = false
    var blocks = get_tree().get_nodes_in_group(BLOCK_GROUP)
    self.active_blocks_count = blocks.size()
    for block in blocks:
        if block.is_in_group(UNBREAKABLE_BLOCK_GROUP):
            self.active_blocks_count -= 1
        block.hit.connect(increase_score)

func reset_hearts():
    for heart in $Lives.get_children():
        heart.get_node("AnimatedSprite2D").animation = FULL_ANIMATION

func hide_title_screen():
    $TitleScreen.visible = false
    title_background.visible = false
    title_background_sound.stop()

func show_title_screen():
    reset_score()
    $TitleScreen.visible = true
    title_background.visible = true
    show_message(INITIAL_TEXT, false)

func reset_score():
    self.current_points = 0

func show_message(message, disappear_after_timer = true):
    info_message.text = message
    info_message.show()
    if disappear_after_timer:
        hide_message_timer.start()

func on_timeout_hide_message():
    info_message.hide()

func increase_score(block_destroyed, points):
    self.current_points += points
    if block_destroyed:
        self.active_blocks_count -= 1
    check_highscore()

func set_current_points(points):
    current_points = points
    current_score_label.text = str(current_points)

func check_highscore():
    if highscore < current_points and not new_highscore:
        await get_tree().create_timer(0.5).timeout
        $NewHighscoreSound.play()
        new_highscore = true
        show_message(NEW_HIGHSCORE_MESSAGE, true)
        self.highscore = current_points

func set_highscore(score):	
    highscore = score
    highscore_label.text = str(highscore)

func set_lives(new_lives):
    lives = new_lives
    if lives == 0:
        level_lost.emit()

func load_highscore():
    var save = FileAccess.open(SAVE_FILE, FileAccess.READ)
    var save_data = save.get_var()
    self.highscore = save_data["highscore"]
    save.close()

func save_highscore():
    var save = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
    var save_data = { "highscore": highscore }
    save.store_var(save_data)
    save.close()